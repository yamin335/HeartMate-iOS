//
//  DatingPreferenceController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 03/08/2022.
//

import UIKit
import DropDown

class DatingPreferenceController: UIViewController,LocationData{

    //MARK: - IBOutlets
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var table_view: UITableView!

    var days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday","I’m available \n7 days-a-week"]
    var arrDays : [String] = []
    let radiusDropDown = DropDown()
    var radiusModel = ["10","20","30","40","50","60","70","80","90","100"]
    var profileData:ProfileModel?
    var currentAvailability = [String]()
    var locationData = [String:Any]()
    var distance = ""
    var defaultLatitude = "0.0"
    var defaultLongitude = "0.0"
    var defaultLocation = ""


    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        self.table_view.separatorStyle = .none
        self.table_view.register(DatingAvailabilityTableViewCell.nib, forCellReuseIdentifier: DatingAvailabilityTableViewCell.identifier)

        if profileData != nil {
            currentAvailability = profileData!.datingAvailability.components(separatedBy: ",")
            print(currentAvailability)
            updateCurrentAvailabilityStatus()
            defaultLocation = profileData!.location
            defaultLatitude = profileData!.latitude
            defaultLongitude = profileData!.longitude

        }
        if profileData?.location != "" {
            lblLocation.text = profileData?.location
        }else{
            lblLocation.text = "N/A"
        }

        if profileData?.maxDistance != "" {
            lblDistance.text = "\(profileData?.maxDistance ?? "10") miles"
            distance = profileData?.maxDistance ?? "10"
        }else{
            lblDistance.text = "N/A"
        }

    }

    //MARK: - Custom Functions
    func updateCurrentAvailabilityStatus(){
        for data in currentAvailability {
            switch data.uppercased() {
            case "M":
                arrDays.append("Monday")
            case "T":
                arrDays.append("Tuesday")
            case "W":
                arrDays.append("Wednesday")
            case "R":
                arrDays.append("Thursday")
            case "F":
                arrDays.append("Friday")
            case "SU":
                arrDays.append("Saturday")
            case "S":
                arrDays.append("Sunday")
            default:
                print("N/A")
            }
        }

        if currentAvailability.count == 7 {
            arrDays.append("I’m available \n7 days-a-week")
        }
        if !currentAvailability.isEmpty{
            table_view.reloadData()
        }
    }

    func sendData(locationData:[String:Any]){
        var values = ""
        for i in 0..<days.count - 1{
            if arrDays.contains(days[i]){
                if (values.count > 0){
                    values.append(",")
                }
                if(i == 3){
                    values.append("R")
                }else if(i == 6){
                    values.append("Su")
                }else{
                    let value = days[i].first?.description ?? ""
                    values.append(value)
                }
            }
        }
        var params = [String:Any]()
        params = ["latitude" : locationData["latitude"] as? Double ?? Double(defaultLatitude)!,
                  "longitude" : locationData["longitude"] as? Double ?? Double(defaultLongitude)!,
                          "location": locationData["city"] as? String ?? defaultLocation,
                          "dating_availability": values,
                      "max_distance":distance] as [String:Any]

        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
//                self.sendDistance()
                API.shared.sendData(url: APIPath.updateUserMetaVar, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                    if status {
                        AppLoader.shared.hide()
                    }else{
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

    func sendDistance(){
        let params = ["max_distance": distance] as [String:Any]
        API.shared.sendData(url: APIPath.updateUserMetaVar, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
            if status {
            }else{
                print("Error found")
            }
        }
    }

    func selectedLocation(data: [String : Any]) {
        self.lblLocation.text = data["city"] as? String
        locationData = data
    }

    //MARK: - Btn Actions
    @IBAction func btnActionRadiusUpdate(_ sender: UIButton) {
        radiusDropDown.cellHeight = 60
        radiusDropDown.dataSource = radiusModel.map({$0})
        radiusDropDown.anchorView = sender
        radiusDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        radiusDropDown.separatorColor = .gray
        radiusDropDown.show()
        radiusDropDown.selectionAction = { [weak self] (index: Int, item: String) in
          guard let _ = self else { return }
            print("selected radius is",(self?.radiusModel[index]) ?? "no value")
            self?.lblDistance.text = "\(self?.radiusModel[index] ?? "10") miles"
            self?.distance = (self?.radiusModel[index] ?? "10")
        }
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActionSaveData(_ sender: UIButton) {
        sendData(locationData: locationData)
    }

    @IBAction func btnActionLocation(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DatingPreferenceSearchLocationViewController") as! DatingPreferenceSearchLocationViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension DatingPreferenceController : UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = table_view.dequeueReusableCell(withIdentifier: DatingAvailabilityTableViewCell.identifier) as! DatingAvailabilityTableViewCell
        cell.selectionStyle = .none
        cell.lbl_days.text = days[indexPath.row]
        cell.btn_checkUncheck.tag = indexPath.row

        if arrDays.count == 7{
            cell.btn_checkUncheck.isSelected = true
            cell.btn_checkUncheck.setImage(UIImage(named: "checked-1"), for: .normal)
        }else{
            if arrDays.contains(days[indexPath.row]){
                cell.btn_checkUncheck.setImage(UIImage(named: "checked-1"), for: .normal)
                cell.btn_checkUncheck.isSelected = true
            }else{
                cell.btn_checkUncheck.setImage(UIImage(named: "emptyCheckBox"), for: .normal)
                cell.btn_checkUncheck.isSelected = false

            }
        }

        cell.btnAvailabilityAction = { index, sender in
            if(index == 7){
                if(sender.isSelected){
                    self.arrDays = []
                    self.table_view.reloadData()
                }else{
                    for i in 0..<self.days.count - 1{
                        if !self.arrDays.contains(self.days[i]){
                            self.arrDays.append(self.days[i])
                        }
                    }
                    sender.setImage(UIImage(named: "checked-1"), for: .normal)
                    self.table_view.reloadData()
                }
            }else{
                if self.arrDays.contains(self.days[index]){
                    sender.isSelected = false
                    let index = self.arrDays.firstIndex{$0 == self.days[index]}!
                    self.arrDays.remove(at: index)
                    sender.setImage(UIImage(named: "emptyCheckBox"), for: .normal)
                    //print(print(self.arrDays))
                }else{
                    sender.isSelected = true
                    self.arrDays.append(self.days[index])
                    sender.setImage(UIImage(named: "checked-1"), for: .normal)
                    //print(arrDays)
                }
            }
        }

        return cell

    }

}
