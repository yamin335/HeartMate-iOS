//
//  NumberRegistrationViewController.swift
//  iosbingo
//
//  Created by apple on 30/08/22.
//

import UIKit
import FirebaseAuth
import CountryPickerView

class NumberRegistrationViewController: UIViewController {

    @IBOutlet weak var img_countryFlag: UIImageView!
    @IBOutlet weak var lbl_countryCode: UILabel!
    @IBOutlet weak var txt_number: UITextField!
    @IBOutlet weak var btn_selectCountry: UIButton!
    
    var countries: [[String: String]] = []
    
    let countryPickerView = CountryPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryPickerView.setCountryByPhoneCode("+1")
        countryPickerView.setCountryByName("United States")
        countryPickerView.setCountryByCode("US")
		self.txt_number.text = ""//6505557172"
        
        self.loadData()
    }
    
    @IBAction func btn_next(_ sender: Any) {
//        self.getNonce()
        if(self.validate(phone: txt_number.text!)){
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(countryPickerView.selectedCountry.phoneCode + txt_number.text!, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        //self.showMessagePrompt(error.localizedDescription)
                        print(error.localizedDescription)
						let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
						vc.number = self.countryPickerView.selectedCountry.phoneCode.replacingOccurrences(of: "+", with: "") + self.txt_number.text!
						vc.verificationCode = UUID().uuidString//verificationID!
						self.navigationController?.pushViewController(vc, animated: true)
                        return
                    }
                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
                    vc.number = self.countryPickerView.selectedCountry.phoneCode.replacingOccurrences(of: "+", with: "") + self.txt_number.text!
                    vc.verificationCode = verificationID!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
        }else{
            let alert = UIAlertController(title: "Oops!", message: "Please enter a valid mobile number", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alert) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    
    @IBAction func btn_selectCountry(_ sender: Any) {
        //self.showPickerView(title: "Select country")
        countryPickerView.showCountriesList(from: self)
    }

func validate(phone: String) -> Bool {
    let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    return phoneTest.evaluate(with: phone)
}
    

}

extension NumberRegistrationViewController: CountryPickerViewDelegate, CountryPickerViewDataSource{
    //MARK:- CountryPicker Delegate
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        img_countryFlag.image = countryPickerView.selectedCountry.flag
        lbl_countryCode.text = (countryPickerView.selectedCountry.code) + " " + (countryPickerView.selectedCountry.phoneCode)
    }
    
}

extension NumberRegistrationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func loadData() {
        countries.removeAll()
        if let url = Bundle.main.url(forResource: "phone_countyCode", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = object as? [[String: String]] {
                    countries = dictionary
                    print(countries)
                }
            } catch {
            }
        }
    }
       
   func showPickerView(title: String) {
       
       let alertView = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
       alertView.view.tintColor = UIColor(named: "purpleColor")
       let height:NSLayoutConstraint = NSLayoutConstraint(item: alertView.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300)
       alertView.view.addConstraint(height)
       
       let pickerview = UIPickerView(frame: CGRect(x: 0, y: 35, width: alertView.view.frame.size.width - 16, height: 200))
       pickerview.delegate = self
       pickerview.dataSource = self
       
       alertView.view.addSubview(pickerview)
       
       alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
           self.lbl_countryCode.text! = self.countries[pickerview.selectedRow(inComponent: 0)]["dial_code"] ?? ""
       }))
       present(alertView, animated: true, completion: nil)
   }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let country = countries[row]
        return "\(country["name"] ?? "") (\(country["dial_code"] ?? ""))"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
}

//MARK: API's -----

extension NumberRegistrationViewController{
 
}
