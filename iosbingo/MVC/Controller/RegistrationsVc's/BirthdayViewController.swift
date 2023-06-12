//
//  BirthdayViewController.swift
//  iosbingo
//
//  Created by apple on 30/08/22.
//

import UIKit

class BirthdayViewController: UIViewController {
    
    @IBOutlet weak var btn_selectDob: UIButton!
    @IBOutlet weak var view_confirmInfo: UIView!
    @IBOutlet weak var lbl_age: UILabel!
    @IBOutlet weak var lbl_years: UILabel!
    @IBOutlet weak var lbl_dob: UILabel!
    
    var age = 0
    
    var Day = Int()
    var Month = Int()
    var Year = Int()
    
//    var firstName = ""
//    var lastName = ""
//    var email = ""
//    var password = ""
    var birthday = ""
    var profileData : UserExistsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view_confirmInfo.isHidden = true
        do {
            profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .userData, castTo: UserExistsModel.self)
            print(profileData!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func btn_next(_ sender: Any) {
        if(age < 18){
            self.generateAlert(withMsg: "You must be at least 18 years of age", otherBtnTitle: "OK") { refresh in
            }
        }else{
            self.view_confirmInfo.isHidden = false
        }
    }
    
    
    @IBAction func btn_selectDob(_ sender: UIButton) {
        self.showDatePicker(title: "Select Date Of Birth")
    }
    
    @IBAction func btn_edit(_ sender: UIButton) {
        self.view_confirmInfo.isHidden = true
        self.showDatePicker(title: "Select Date Of Birth")
    }
    
    @IBAction func btn_confirm(_ sender: UIButton) {
        self.updateBirthday()
    }

    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName) as! NotificationSettingsViewController
        vc.profileData = self.profileData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateBirthday(){
        let params = ["birthday":self.birthday, "cache":randomString(length: 32)] as [String:Any]
        print(params)
        API.shared.sendData(url: APIPath.updateUserMetaVar, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
            if status {
                self.performSegue(withIdentifier: "notification", sender: self)
            }else{
                print("Error found")
            }
        }
    }
}

extension BirthdayViewController {
            
    func showDatePicker(title: String){
            
        let alertView = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
                alertView.view.tintColor = UIColor(named: "purpleColor")
                let height:NSLayoutConstraint = NSLayoutConstraint(item: alertView.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300)
                alertView.view.addConstraint(height)
                
                let pickerview = UIDatePicker(frame: CGRect(x: 16, y: 35, width: alertView.view.frame.size.width - 16, height: 200))
                pickerview.datePickerMode = .date
                if #available(iOS 13.4, *) {
                    pickerview.preferredDatePickerStyle = .wheels
                } else {
                    // Fallback on earlier versions
                }
                
                var frame = pickerview.frame
                frame.origin.x = (self.view.frame.size.width - frame.size.width)/2
                pickerview.frame = frame
                
                alertView.view.addSubview(pickerview)
                
                alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .none
                    print(formatter.string(from: pickerview.date))
                    
                    let formatters = DateFormatter()
                    formatters.dateFormat = "Y-M-d"
                    self.birthday = formatters.string(from: pickerview.date)
                 
                    self.btn_selectDob.setTitle(formatter.string(from: pickerview.date), for: .normal)
                    
//                    let date = Date()
                    let calendar = Calendar.current
                    let day = calendar.dateComponents([.year, .month, .day], from: pickerview.date)
                    self.Day = day.day!
                    self.Month = day.month!
                    self.Year = day.year!
                    
                    let dob = Date(year: self.Year, month: self.Month, day: self.Day)
                    self.age = dob.age
                    self.lbl_age.text =  "Age" + " " + String(self.age)
                    self.lbl_years.text = "\(self.age) years old"
                    self.lbl_dob.text = "Born \(formatter.string(from: pickerview.date))"

                }))
     
            self.present(alertView, animated: true, completion: nil)
           

        }

}


extension Date {

    var age: Int {
        get {
            let now = Date()
            let calendar = Calendar.current

            let ageComponents = calendar.dateComponents([.year], from: self, to: now)
            let age = ageComponents.year!
            return age
        }
    }
    init(year: Int, month: Int, day: Int) {
        var dc = DateComponents()
        dc.year = year
        dc.month = month
        dc.day = day

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        if let date = calendar.date(from: dc) {
            self.init(timeInterval: 0, since: date)
        } else {
            fatalError("Date component values were invalid.")
        }
    }

}
