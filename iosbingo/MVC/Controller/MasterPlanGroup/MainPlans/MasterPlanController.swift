//
//  MasterPlanController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 16/09/2022.
//

import UIKit
import FSCalendar

class MasterPlanController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnCalendarScope: UIButton!
    @IBOutlet weak var lblNoPlans: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var calanderHeightConstraint: NSLayoutConstraint!

    var isMonthyActive = false
    var masterModel : MasterPlanModel!
    var groupModel = [UserModel]()
    var customPlans = [CustomMasterPlanModel]()
    var countOfEventsAtDate = [String:Int]()
    var datesForDifferentColorsOfEvents = [[String:String]]()
    var usersList = [[String:String]]()
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    private var datesRange: [Date]?

    override func viewDidLoad() {
        super.viewDidLoad()

        leftArrow.isHidden = true
        rightArrow.isHidden = true
        lblNoPlans.isHidden = true
        calendar.allowsMultipleSelection = true
        calendar.setScope(FSCalendarScope.week, animated: false)
        calendar.allowsMultipleSelection = false
        imgDropDown.image = UIImage(named: "dropUp")
        getPlanData()

    }

    //MARK: - Custom Functions

    func getPlanData(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                API.shared.sendData(url: APIPath.getPlan, requestType: .post, params: nil, objectType: MasterPlanModel.self) { (data,status)  in
                    if status {
                        guard let planData = data else {
                            AppLoader.shared.hide()
                            return
                        }
                        self.masterModel = planData
                        self.categorizePlans()
                        AppLoader.shared.hide()
                    }else{
                        self.categorizePlans()
                        AppLoader.shared.hide()
                        print("Error found")
                    }
                }
            }else{
                AppLoader.shared.hideWithHandler(completion: { isDone in
                    if isDone{
                        removeUserPreference()
                        navigatetoLoginScreen()
                    }
                })
            }
        }
    }

    func getFilterPlans(params:[String:Any]?){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = params
                API.shared.sendData(url: APIPath.getPlan, requestType: .post, params: params, objectType: MasterPlanModel.self) { (data,status)  in
                    if status {
                        guard let planData = data else {
                            AppLoader.shared.hide()
                            return
                        }
                        self.masterModel = nil
                        self.masterModel = planData
                        self.categorizePlans()
                        AppLoader.shared.hide()
                    }else{
                        self.categorizePlans()
                        AppLoader.shared.hide()
                        print("Error found")
                    }
                }
            }else{
                AppLoader.shared.hideWithHandler(completion: { isDone in
                    if isDone{
                        removeUserPreference()
                        navigatetoLoginScreen()
                    }
                })
            }
        }
    }

    func validateDateRangeAndGroupId(){
        guard let calendarModel = masterModel else {return}
        guard let masterUser = calendarModel.user else {return}
        var selectedGorupIds = [Int]()
        for id in groupModel{
            if id.isSelected!{
                selectedGorupIds.append(id.groupID ?? 0)
            }
        }

        var groupIDs = ""
        if selectedGorupIds.count > 0 {
            groupIDs = selectedGorupIds.map{String($0)}.joined(separator: ",")
        }

        var params = [String:Any]()
        let cache = randomString(length: 32)
        if firstDate != nil && lastDate == nil && !selectedGorupIds.isEmpty{
            let firstDate = stringFromDate(date: firstDate ?? Date(), format: .short)
            params = ["from_date":firstDate,"to_date":firstDate,"group_id":groupIDs] as [String:Any]
        }else if firstDate != nil && lastDate != nil && !selectedGorupIds.isEmpty{
            let firstDate = stringFromDate(date: firstDate ?? Date(), format: .short)
            let lastDate = stringFromDate(date: lastDate ?? Date(), format: .short)
            params = ["from_date":firstDate,"to_date":lastDate,"group_id":groupIDs] as [String:Any]
        }else if firstDate == nil && lastDate == nil && !selectedGorupIds.isEmpty{
            params = ["group_id":groupIDs] as [String:Any]
        }else if firstDate != nil && lastDate != nil && selectedGorupIds.isEmpty{
            let firstDate = stringFromDate(date: firstDate ?? Date(), format: .short)
            let lastDate = stringFromDate(date: lastDate ?? Date(), format: .short)
            params = ["from_date":firstDate,"to_date":lastDate] as [String:Any]
        }
        else if firstDate != nil && lastDate == nil && selectedGorupIds.isEmpty{
            let firstDate = stringFromDate(date: firstDate ?? Date(), format: .short)
            params = ["from_date":firstDate,"to_date":firstDate] as [String:Any]
        }
        else if firstDate == nil && lastDate == nil && selectedGorupIds.isEmpty{
            //Will call master plan API wihout any params
        }

        params["cache"] = cache
        getFilterPlans(params: params)

    }

    func categorizePlans(){
        var plansDic = [String:Any]()
        var plansDicArray = [[String:Any]]()
        var currentUserList = [[String:String]]()
        var isKeyFound = false

        if let calendarModel = masterModel {

            if groupModel.isEmpty{
                if let groups = calendarModel.user {
                    groupModel = groups
                    if groups.count > 3 {
                        rightArrow.isHidden = false
                    }
                }
            }

            if let calendarModelPartners = calendarModel.partners {
                for obj in calendarModelPartners{
                    isKeyFound = false
                    plansDic["timeOfDay"] = (obj.timeOfDay ?? "") as String
                    if let newPlan = obj.plans {
                        plansDic["plans"] = newPlan as [Plan]
                    }

                    //Adding first value in the array
                    if plansDicArray.count == 0 {
                        plansDicArray.append(plansDic)
                    }else{
                        //Checking if value is matched in array then add the remaining plans in the same key
                        for index in plansDicArray.indices{
                            let currentValue = plansDic["timeOfDay"] as! String
                            let previousValue = plansDicArray[index]["timeOfDay"] as! String
                            //If key found then update the values of the current key
                            if currentValue == previousValue{
                                isKeyFound = true
                                var plans = plansDicArray[index]["plans"] as! [Plan]
                                plans.append(contentsOf: plansDic["plans"] as! [Plan])
                                plansDicArray[index]["plans"] = plans

                            }
                        }
                        //If key is not exist in the existing array then add in the array
                        if !isKeyFound {
                            plansDicArray.append(plansDic)
                        }
                    }
                }

                //Removing all values from custom plans model for initializing again
                customPlans.removeAll()

                countOfEventsAtDate.removeAll()
                datesForDifferentColorsOfEvents.removeAll()
                usersList.removeAll()

                //Adding values in customPlanModel
                for plansObj in plansDicArray {
                    let plans = plansObj["plans"] as! [Plan]
                    var customPlan = [CustomPlan]()
                    for plan in plans{
                        customPlan.append(CustomPlan(bookingID: plan.id!, date: plan.date!, startTime: plan.startTime!, excerpt: plan.excerpt!, groupID: plan.groupID!, colorCode: plan.colorCode!, firstName: plan.firstName ?? "N/A", avatar: plan.avatar!, type: plan.type!))

                        //saving date values in dictionary that how many number of times is repeating
                        if countOfEventsAtDate.keys.contains(plan.date!){
                            let currentCount = countOfEventsAtDate[plan.date!]
                            countOfEventsAtDate[plan.date!] = (currentCount ?? 0) + 1
                        }else{
                            countOfEventsAtDate[plan.date!] = 1
                        }

                        //saving events dates and colors for showing different events colors on calendar
                        datesForDifferentColorsOfEvents.append(["date":plan.date!,"color":plan.colorCode!])

                        //saving usernames in the list for showing in horizontal list
                        usersList.append(["firstName":plan.firstName ?? "N/A","color":plan.colorCode!])
                    }

                    //Adding objects in custome models
                    customPlans.append(CustomMasterPlanModel(timeOfDay: plansObj["timeOfDay"] as! String, plans: customPlan))
                }


                //removing duplicate values from the userlist array
                for user in usersList{
                    if currentUserList.count > 0{
                        let isUserExist = currentUserList.filter { $0["firstName"] == user["firstName"] }
                        if isUserExist.isEmpty{
                            currentUserList.append(user)
                        }
                        print("username is exist",isUserExist.count)
                    }else{
                        currentUserList.append(user)
                    }
                }
            }
        }

        usersList.removeAll()
        usersList = currentUserList

        if customPlans.isEmpty{
            lblNoPlans.isHidden = false
        }else{
            lblNoPlans.isHidden = true
        }

        //reloading tableveiw and collectionview
        collectionView.reloadData()
        tableView.reloadData()
    }

    func loadJson<T:Codable>(of type:T.Type,filename fileName: String) -> T? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                return try decoder.decode(type.self, from: data)
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }

    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
            print("from is \(from)")
        print("to is \(to)")

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView{
            for cell in collectionView.visibleCells {
                let indexPath = collectionView.indexPath(for: cell)
                print(indexPath?.row ?? -1)
                let currentRow = indexPath?.row ?? -1
                if currentRow == 3{
                    leftArrow.isHidden = false
                }else if currentRow == 0{
                    leftArrow.isHidden = true
                }

                if currentRow == groupModel.count - 1{
                    rightArrow.isHidden = true
                }else if groupModel.count > 3 && currentRow < groupModel.count - 1{
                    rightArrow.isHidden = false
                }
            }
        }

    }

    //MARK: - Button Actions

    @IBAction func btnActionCalenderHeight(_ sender: Any) {
        if isMonthyActive{
            calendar.setScope(FSCalendarScope.week, animated: true)
            isMonthyActive = false
            imgDropDown.image = UIImage(named: "dropUp")

        }else{
            calendar.setScope(FSCalendarScope.month, animated: true)
            isMonthyActive = true
            imgDropDown.image = UIImage(named: "dropDownCaledndar")
        }
    }

    @IBAction func btnActionValidateDateRanges(_ sender: Any) {
        validateDateRangeAndGroupId()
    }

    @IBAction func btnActionAddPersonalEvent(_ sender: Any) {
        pushController(controllerName: "AddPersonalPlanViewController", storyboardName: "MasterPlan")
    }

    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension MasterPlanController: UITableViewDelegate,UITableViewDataSource{

    //MARK: - Tableview Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return customPlans.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customPlans[section].plans.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return customPlans[section].timeOfDay.uppercased()
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let header = view as? UITableViewHeaderFooterView
        let customFont = UIFont(name: "Inter-Regular", size: 15)
        header?.textLabel?.font = customFont
        header?.textLabel?.textColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterPlanTableViewCell") as! MasterPlanTableViewCell
        cell.lblDate.text = customPlans[indexPath.section].plans[indexPath.row].startTime
        cell.lblExcerpt.text = customPlans[indexPath.section].plans[indexPath.row].excerpt
        cell.lblExcerpt.textColor = UIColor(hexString: customPlans[indexPath.section].plans[indexPath.row].colorCode)
        cell.imgPlan.sd_setImage(with: URL(string: customPlans[indexPath.section].plans[indexPath.row].avatar), placeholderImage: UIImage(named: "defaultProfile"))
        cell.imgStart.isHidden = customPlans[indexPath.section].plans[indexPath.row].type != "me_time"
        cell.lblOffer.isHidden = customPlans[indexPath.section].plans[indexPath.row].type != "me_time"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if customPlans[indexPath.section].plans[indexPath.row].type == "date_night_offer" || customPlans[indexPath.section].plans[indexPath.row].type == "reschedule_offer"{

            let vc = UIStoryboard(name: "MasterPlan", bundle: Bundle.main).instantiateViewController(withIdentifier: "DateOfferViewController") as! DateOfferViewController
            vc.type = customPlans[indexPath.section].plans[indexPath.row].type
            vc.bookingId = customPlans[indexPath.section].plans[indexPath.row].bookingID
            self.navigationController?.pushViewController(vc, animated: true)

        }else if customPlans[indexPath.section].plans[indexPath.row].type == "event" || customPlans[indexPath.section].plans[indexPath.row].type == "me_time" || customPlans[indexPath.section].plans[indexPath.row].type == "date_night"{

            let vc = UIStoryboard(name: "MasterPlan", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpcomingPlanViewController") as! UpcomingPlanViewController
            vc.type = customPlans[indexPath.section].plans[indexPath.row].type
            vc.bookingId = customPlans[indexPath.section].plans[indexPath.row].bookingID
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
}

extension MasterPlanController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MasterPlanCollectionViewCell", for: indexPath) as! MasterPlanCollectionViewCell
        cell.lblFirstName.text = groupModel[indexPath.row].firstName ?? ""
        cell.mainView.backgroundColor = UIColor(hexString: groupModel[indexPath.row].colorCode ?? "#000000")
        cell.imgCheckBox.image = groupModel[indexPath.row].isSelected ?? true ? UIImage(named: "checkedWhite") : UIImage(named: "unchecked")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        groupModel[indexPath.row].isSelected = !(groupModel[indexPath.row].isSelected ?? true)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.collectionView.frame.size
        return CGSize(width: size.width/3, height: size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

}

extension MasterPlanController: FSCalendarDelegateAppearance,FSCalendarDelegate,FSCalendarDataSource{

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calanderHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        for obj in customPlans {
            for plan in obj.plans{
                let planStringDate = plan.date
                let planDate = dateFromString(fromString: planStringDate, format: .short)
                if stringFromDate(date: date, format: .short) == stringFromDate(date: planDate ?? date, format: .short) {
                    if countOfEventsAtDate.keys.contains(plan.date){
                        let currentCount = countOfEventsAtDate[plan.date] ?? 0
                        return currentCount
                    }else{
                        return 1
                    }
                }
            }
        }
        return 0
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {

        let currentDate = stringFromDate(date: date, format: .short)
        for event in datesForDifferentColorsOfEvents {
            if event["date"] == currentDate {

                //Getting count of same dates from the array and then assignind each date color to the event
                let filteredArray = self.datesForDifferentColorsOfEvents.filter { $0["date"] == event["date"]}
                let colors = filteredArray.map { (obj) -> UIColor in
                    return UIColor(hexString: obj["color"]!)
                }
                return colors
            }
        }
        return nil
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]

            print("datesRange contains: \(datesRange!)")

            return
        }

        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]

                print("datesRange contains: \(datesRange!)")

                return
            }

            let range = datesRange(from: firstDate!, to: date)

            lastDate = range.last
            let firstDateInString = stringFromDate(date: firstDate ?? date, format: .FullDOB)
            let lastDateInString = stringFromDate(date: lastDate ?? date, format: .FullDOB)
            print("first date is \(firstDateInString)")
            print("last date is \(lastDateInString)")

            for d in range {
                calendar.select(d)
            }

            datesRange = range

            print("datesRange contains: \(datesRange!)")

            return
        }

        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []

            print("datesRange contains: \(datesRange!)")
        }
    }


    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:

        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []
            print("datesRange contains: \(datesRange!)")
        }else if firstDate != nil && lastDate == nil{
            firstDate = nil
            datesRange = []
        }
    }


}
