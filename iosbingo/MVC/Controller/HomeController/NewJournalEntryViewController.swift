//
//  NewJournalEntryViewController.swift
//  iosbingo
//
//  Created by Macintosh on 20/12/22.
//

import UIKit

class NewJournalEntryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate,GetPlanerId {

	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var myobservationTV: UITextView!
	@IBOutlet weak var dateTF: UITextField!
	@IBOutlet weak var tblView: UITableView!
	@IBOutlet weak var datepicker: UIDatePicker!
	@IBOutlet weak var pickerView: UIView!
	@IBOutlet weak var selectedTagLabel: UILabel!
	@IBOutlet weak var buttonstackView: UIStackView!
	@IBOutlet weak var expTypeButton: UIButton!
    @IBOutlet weak var expTypeButtonLabel: UILabel!
    @IBOutlet weak var selectedtabBtn: UIButton!
	@IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var deletebutton:UIButton!
    
		//    MARK: - Properties
	var exp			 	: [String] 		= [""]
	var imagePicker		: ImagePicker!
	var groupID			: String		= ""
	var topicId			: String 		= ""
	var imageDate		: (Data?,String?)
	var seletedTag		: String 		= ""
	var getEntry		: Bool 			= false
	var entryID			: String 		= ""
    var datenightID     : String        = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tblView.delegate = self
		tblView.dataSource = self
		tblView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
		self.imagePicker = ImagePicker(presentationController: self, delegate: self)
		setupUI()
    }
	
	func setupUI(){
		if getEntry {
            self.deletebutton.isHidden = true
			buttonstackView.isHidden = true
			uploadButton.isHidden = true
			expTypeButton.isHidden = true
			dateTF.isUserInteractionEnabled = false
			myobservationTV.isUserInteractionEnabled = false
			getEntryData()
		}else{
            self.deletebutton.isHidden = false
			buttonstackView.isHidden = false
			uploadButton.isHidden = false
			expTypeButton.isHidden = false
			dateTF.isUserInteractionEnabled = true
			myobservationTV.isUserInteractionEnabled = true
            if entryID != ""{
                getEntryData()
            }
		}
	}
	
	@IBAction func backgroundButton(_ sender: UIButton) {
		self.tabBarController?.tabBar.isHidden = true
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func openTags(_ sender: UIButton) {
		self.tblView.isHidden = !self.tblView.isHidden
		self.tblView.reloadData()
	}
	
	@IBAction func openDatePicker(_ sender: Any) {
		self.pickerView.isHidden = false
		self.datepicker.addTarget(self, action: #selector(onValueChage), for: .valueChanged)
	}
	
	@IBAction func submitButton(_ sender: UIButton) {
        guard let imageDate = imageDate.0 else{
			showAlert(message: "Select an image", titled: "Error")
			return
		}
        self.APICall(image: imageDate, saveDraft: true)
	}
	
	@IBAction func draftButton(_ sender: UIButton) {
        guard let imageDate = imageDate.0 else{
			showAlert(message: "Select an image", titled: "Error")
			return
		}
        self.APICall(image: imageDate, saveDraft: false)
	}
	
	@IBAction func uploadImage(_ sender: UIButton) {
		self.imagePicker.present(from: sender)
	}
	
	
	@IBAction func dismissButtonAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func deleteButton(_ sender: UIButton) {
		self.deleteEntry()
	}
	
	@IBAction func pickerDoneButton(_ sender: UIButton) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "YYYY-MM-dd"
		self.dateTF.text = dateFormatter.string(from: datepicker.date)
		self.pickerView.isHidden = true
	}
	
    
    @IBAction func tabButtonAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "DatingJourney", bundle: Bundle.main).instantiateViewController(withIdentifier: "JourneyCalendarViewController") as! JourneyCalendarViewController
        vc.fromNewEnrtry = true
        vc.groupId = Int(self.groupID) ?? 0
        vc.Iddelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
	func initializeview(){
		self.mainView.layer.cornerRadius = 10
		self.dateTF.delegate = self
		self.myobservationTV.delegate = self
		getExp()
	}
	
	@objc func onValueChage(_ sender:UIDatePicker){
		print("Current date",sender.date)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "YYYY-MM-dd"
        self.dateTF.text = dateFormatter.string(from: sender.date)//dateFormatter.string(from: sender.date)
	}
	
	func getExp(){
		var expp = [String]()
		for string in exp {
			let str = string.uppercased().replacingOccurrences(of: "_", with: " ")
			expp.append(str)
		}
		self.exp = expp
	}
}

extension NewJournalEntryViewController:UITableViewDelegate,UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return exp.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        cell.textLabel?.text = exp[indexPath.row].replacingOccurrences(of: "_", with: " ").uppercased()
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let txt = "Tag a recent \(exp[indexPath.row].replacingOccurrences(of: "_", with: " "))"
		self.seletedTag = exp[indexPath.row].replacingOccurrences(of: "_", with: " ")
        if exp[indexPath.row].replacingOccurrences(of: "_", with: " ").lowercased() != "date night" {
            self.selectedTagLabel.isHidden = true
            self.selectedtabBtn.isHidden = true
            expTypeButtonLabel.text = exp[indexPath.row].replacingOccurrences(of: "_", with: " ").capitalized
        }else{
            expTypeButton.setTitle(exp[indexPath.row].replacingOccurrences(of: "_", with: " ").capitalized, for: .normal)
            self.selectedTagLabel.isHidden = false
            self.selectedtabBtn.isHidden = false
            self.selectedTagLabel.text = txt
            expTypeButtonLabel.text = exp[indexPath.row].replacingOccurrences(of: "_", with: " ").capitalized
        }
		self.tblView.isHidden = true
	}
	
	
	func deleteEntry(){
		AppLoader.shared.show(currentView: self.view)
		API.shared.ValidateToken { isValid in
			let param = [
				"group_id":self.groupID,
				"journal_entry_id":self.entryID
			]
			API.shared.sendData(url: APIPath.deleteEntry, requestType: .post, params: param, objectType: DeleteEntryModel.self) { (data, status) in
				if status{
					guard data != nil else {return}
					AppLoader.shared.hide()
					let alert = UIAlertController(title: "Successful", message: "Entry Deleted.", preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in
						self.navigationController?.popViewController(animated: true)
					}))
				}
			}
		}
	}
	
	func APICall(image:Data,saveDraft:Bool){
		AppLoader.shared.show(currentView: self.view)
		API.shared.ValidateToken { isValid in
			if isValid {
				let cache = randomString(length: 32)
				let param = [
					"cache":cache,
					"group_id":self.groupID,
                    "date_night_id":self.datenightID,
					"topic_id":self.topicId,
                    "date_time":self.dateTF.text,
					"date_number":"",
					"week_number":"",
					"content":self.myobservationTV.text,
					"publish_status":saveDraft ? "publish" : "draft",
					"review_status":"",
					"experience_type":self.seletedTag
                ] as [String : Any]
				API.shared.sendMultiPartData(url: APIPath.createEntry, requestType: .post, params: param, objectType: NewJournalEntryModel.self, imageData: image) { (data, status) in
					if status {
						guard data != nil else {return}
						AppLoader.shared.hide()
						let alert = UIAlertController(title: "Successful", message: "New entry created.", preferredStyle: .alert)
						alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in
							self.navigationController?.popViewController(animated: true)
						}))
                        self.present(alert, animated: true)
					}else{
						AppLoader.shared.hide()
						print("Error found")
					}
				}
			}else{
				AppLoader.shared.hide()
				removeUserPreference()
				navigatetoLoginScreen()
			}
		}
	}
	func getEntryData(){
		AppLoader.shared.show(currentView: self.view)
		API.shared.ValidateToken { isValid in
			let param = [
				"journal_entry_id":self.entryID
			]
			API.shared.sendData(url: APIPath.getJournalEntry, requestType: .post, params: param, objectType: JournalEntryModel.self) { (data, status) in
				if status{
					guard data != nil else {return}
					AppLoader.shared.hide()
					self.selectedTagLabel.text = "Tag to recent \(data?.entry?.experienceType ?? "")"
					self.dateTF.text = data?.entry?.dateTime ?? ""
					self.myobservationTV.text = data?.entry?.content ?? ""
                    
				}
			}
		}
	}
    
    func idFromCalanderView(_ id: String) {
        let _ = self.selectedTagLabel.text
        self.selectedTagLabel.text = "Date night Id \(id)"
        self.datenightID = id
    }
    
}
 
	//4. Viewcontroller Extension for ImagePickerDelegate
extension NewJournalEntryViewController : ImagePickerDelegate {
	func didSelect(image: UIImage?, imageURL: String?) {
        guard let image = image, let url = imageURL else { return }
        self.imageDate.0 = image.jpegData(compressionQuality: 0.5)
        self.imageDate.1 = url
        self.uploadButton.setTitle(url, for: .normal)
	}
	
}
