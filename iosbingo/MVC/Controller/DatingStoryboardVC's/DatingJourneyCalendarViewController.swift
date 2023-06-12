//
//  DatingJourneyCalendarViewController.swift
//  iosbingo
//
//  Created by mac on 30/09/22.
//

import UIKit
import FSCalendar

class DatingJourneyCalendarViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calanderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_popUpDateNight: UIView!
    @IBOutlet weak var view_popUpScratchOffer: UIView!
    
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

        self.view_popUpDateNight.isHidden = true
        self.view_popUpScratchOffer.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view_popUpDateNight.addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view_popUpScratchOffer.addGestureRecognizer(tap1)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view_popUpDateNight.isHidden = true
        self.view_popUpScratchOffer.isHidden = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view_popUpDateNight.isHidden = true
        self.view_popUpScratchOffer.isHidden = true
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

    //MARK: - Button Actions

    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func btn_timer(_ sender: Any) {
    }
    
    @IBAction func btn_plus(_ sender: Any) {
        self.view_popUpDateNight.isHidden = false
    }

    @IBAction func btn_CreateCustomDateNightOffer(_ sender: Any) {
        self.view_popUpScratchOffer.isHidden = false
    }
}

extension DatingJourneyCalendarViewController: FSCalendarDelegateAppearance,FSCalendarDelegate,FSCalendarDataSource{

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calanderHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        for obj in customPlans {
            for plan in obj.plans{
                let planStringDate = plan.date
                let planDate = dateFromString(fromString: planStringDate, format: .FullDOB)
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

        let currentDate = stringFromDate(date: date, format: .FullDOB)
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
