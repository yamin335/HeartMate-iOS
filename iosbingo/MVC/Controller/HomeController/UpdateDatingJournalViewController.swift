	//
	//  UpdateDatingJournalViewController.swift
	//  iosbingo
	//
	//  Created by Mac mac on 08/12/22.
	//

import UIKit


enum TableDataType {
	case ourStory
	case observations
}

class UpdateDatingJournalViewController: UIViewController,newEntryProtocol, UITextFieldDelegate {
	
	
	
		//MARK: - Outlets
	@IBOutlet weak var bannerImageView		: UIImageView!
	@IBOutlet weak var statsMainView		: UIView!
	@IBOutlet weak var nameLabel			: UILabel!
	@IBOutlet weak var statsLabel			: UILabel!
	@IBOutlet weak var toValueMeLabel		: UILabel!
	@IBOutlet weak var ourStoryButton		: UIButton!
	@IBOutlet weak var observationButton	: UIButton!
	@IBOutlet weak var tableView			: UITableView!
	
	@IBOutlet weak var topdisStatsuLabel: UILabel!
		//MARK: - Add New Entry Model Outlets
	
//	@IBOutlet weak var newEntryMainView		: UIView!
//	@IBOutlet weak var deleteButton			: UIButton!
//	@IBOutlet weak var discoveryDateField	: UITextField!
//	@IBOutlet weak var myObservetionTV		: UITextView!
//	@IBOutlet weak var uploadImageButton	: UIButton!
	
	//MARK: - Add New Entry Model Button Actions
	@IBAction func recentDateNightButtonAction(_ sender: UIButton) { }
	
	//MARK: - Upload Image Button Action
	@IBAction func uploadImageAction(_ sender: UIButton) { }
	
	//MARK: - Submit Button Action
	@IBAction func SubmitAction(_ sender: UIButton) { }
	
	//MARK: - Save Draft Button Action
	@IBAction func SaveDraftAction(_ sender: UIButton) { }
	
	//MARK: - Review Observations Sheet Outlets
	//MARK: - Properties
	var tableDataType		: TableDataType					= .observations
	var ObservationsModel	: UpdateDatingJournalModel?
	var ourStoryDataModel	: OurStoryModel?
	var groupId 											= 0
	var partnerId 											= 0
	var expendedCell		: Int?							= 0
	var expendStatus		: Bool 							= false
	var showEntryView		: Bool							= false
	var topicId				: String						= ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.isHidden = true
		self.tabBarController?.tabBar.isHidden = true
		AppLoader.shared.show(currentView: self.view)
		self.tableView.register(UINib(nibName: "OurStoryCell", bundle: nil), forCellReuseIdentifier: "OurStoryCell")
		self.tableView.register(UINib(nibName: "ObservationsCell", bundle: nil), forCellReuseIdentifier: "ObservationsCell")
		
		
		tableView.register(UINib(nibName: "ObservationHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ObservationHeader")

		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		getJournalHome()
	}
	
	//MARK: - Back Button Action
	@IBAction func btnActionBack(_ sender: UIButton) {
		self.tabBarController?.tabBar.isHidden = true
		self.navigationController?.popViewController(animated: true)
	}
	
	//MARK: - Our Story Action
	@IBAction func ourStoryAction(_ sender: UIButton) {
		self.tableDataType = .ourStory
        self.topdisStatsuLabel.isHidden = true
        self.topdisStatsuLabel.text = ""
        if self.ourStoryDataModel == nil { self.getOurStory() }
        self.ourStoryButton.BottomBorderWithColor(color: UIColor(red: 146, green: 202, blue: 210, alpha: 1), width: 1)
        self.observationButton.BottomBorderWithColor(color:UIColor(red: 146, green: 202, blue: 210, alpha: 1), width: 1, isHidden: true)
		self.tableView.reloadData()
	}
	
	//MARK: - Observations Action
	@IBAction func observationsAction(_ sender: UIButton) {
		self.tableDataType = .observations
        self.topdisStatsuLabel.isHidden = false
        self.topdisStatsuLabel.text = "\(self.ObservationsModel?.discoverAspectRatio ?? "") clues discoverd"
        if self.ObservationsModel == nil { self.getJournalHome() }
        self.observationButton.BottomBorderWithColor(color: UIColor(red: 146, green: 202, blue: 210, alpha: 1), width: 1)
        self.ourStoryButton.BottomBorderWithColor(color:UIColor(red: 146, green: 202, blue: 210, alpha: 1), width: 1, isHidden: true)
		self.tableView.reloadData()
	}
	
	//MARK: - Funtions
	func setupInitialState() {
		updateSegments()
	}
	
	
	
	func updateSegments() {
		if self.showEntryView{
			let vc = UIStoryboard(name: "DatingJourney", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewJournalEntryViewController") as! NewJournalEntryViewController
			vc.exp = self.ObservationsModel?.experienceTypes ?? [""]
			self.navigationController?.pushViewController(vc, animated: true)
        }else{
            showEntryView = false
        }
		switch self.tableDataType{
			case .observations:
				if self.ObservationsModel == nil { self.getJournalHome() }
				self.observationButton.BottomBorderWithColor(color: UIColor(red: 146, green: 202, blue: 210, alpha: 1), width: 1)
				self.ourStoryButton.BottomBorderWithColor(color:UIColor(red: 146, green: 202, blue: 210, alpha: 1), width: 1, isHidden: true)
			case .ourStory:
				if self.ourStoryDataModel == nil { self.getOurStory() }
				self.ourStoryButton.BottomBorderWithColor(color: UIColor(red: 146, green: 202, blue: 210, alpha: 1), width: 1)
				self.observationButton.BottomBorderWithColor(color:UIColor(red: 146, green: 202, blue: 210, alpha: 1), width: 1, isHidden: true)
		}
	}
	
	func setupforNewEntry(_ show: Bool, topicID: String, getEntry: Bool, entryId: String) {
		if getEntry{
			let vc = UIStoryboard(name: "DatingJourney", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewJournalEntryViewController") as! NewJournalEntryViewController
			vc.getEntry = true
			vc.entryID = entryId
			self.navigationController?.pushViewController(vc, animated: true)
		}else{
			self.showEntryView = show
			self.topicId = topicID
			updateSegments()
		}
	}
	
	func getJournalHome() {
		AppLoader.shared.show(currentView: self.tableView)
		API.shared.ValidateToken { isValid in
			if isValid {
				let params = ["group_id":self.groupId,
							  "partner_id":self.partnerId]
				API.shared.sendData(url: APIPath.getGroupDatingJournal+"?group_id=\(self.groupId)&details=1", requestType: .post, params: ["":""], objectType: UpdateDatingJournalModel.self) { (data,status)  in
					if status {
						guard let datingJournal = data else {
							AppLoader.shared.hide()
							return
						}
						self.ObservationsModel = datingJournal
						self.bannerImageView.sd_setImage(with: URL(string: self.ObservationsModel?.partnerImage ?? ""),placeholderImage: UIImage(named: "defaultProfile"))
						self.nameLabel.text = self.ObservationsModel?.name ?? ""
						self.statsLabel.text = "\(self.ObservationsModel?.totalDatesSoFar ?? 0) Date and other experience so far"
                        
						self.topdisStatsuLabel.text = "\(self.ObservationsModel?.discoverAspectRatio ?? "") clues discoverd"
						self.tableView.reloadData()
						AppLoader.shared.hide()
					} else {
						AppLoader.shared.hide()
						print("Error found")
					}
				}
			} else {
				AppLoader.shared.hideWithHandler(completion: { isDone in
					if isDone {
						removeUserPreference()
						navigatetoLoginScreen()
					}
				})
			}
		}
	}
	
	func getOurStory() {
		AppLoader.shared.show(currentView: self.tableView)
		API.shared.ValidateToken { isValid in
			if isValid {
				let params = ["group_id":self.groupId]
				API.shared.sendData(url: APIPath.getourStory,requestType: .post ,params: params, objectType: OurStoryModel.self) { (data, status) in
					if status {
						guard let ourStory = data else{
							AppLoader.shared.hide()
							return
						}
						self.ourStoryDataModel = ourStory
						self.tableView.reloadData()
						AppLoader.shared.hide()
					} else {
						AppLoader.shared.hide()
						print("error in ",#function)
					}
				}
			}
		}
	}
	
	func createEntry(isDraft:Bool) {
		AppLoader.shared.show(currentView: self.tableView)
		API.shared.ValidateToken { isValid in
			if isValid {
				let params = [
					"group_id":self.groupId,
					"date_night_id":"",
					"topic_id":self.topicId,
					"date_time":"",
					"date_number":"",
					"week_number":"",
					"content":"First time i saw you, wow!",
					"publish_status": isDraft ? "draft" :"publish",
					"review_status":"0"
                ] as [String : Any]
				API.shared.sendData(url: APIPath.createEntry,requestType: .post ,params: params, objectType: OurStoryModel.self) { (data, status) in
					if status {
						guard let ourStory = data else{
							AppLoader.shared.hide()
							return
						}
						self.ourStoryDataModel = ourStory
						self.tableView.reloadData()
						AppLoader.shared.hide()
					} else {
						AppLoader.shared.hide()
						print("error in ",#function)
					}
				}
			}
		}
	}
}

extension UpdateDatingJournalViewController:UITableViewDelegate,UITableViewDataSource {
	
	@objc func expentionSelector(_ sender:UIButton){
		if expendedCell == sender.tag{
			self.expendStatus = !self.expendStatus
			self.expendedCell  = sender.tag
			self.tableView.reloadData()
			
		}else{
			self.expendStatus = true
			self.expendedCell  = sender.tag
			self.tableView.reloadData()
		}
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		switch tableDataType {
			case .observations:
				let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ObservationHeader") as! ObservationHeader
				headerView.headerTitleLabel.text = self.ObservationsModel?.inventoryCategories?[section].label
				headerView.headerButton.tag = section
            var total = 0
            self.ObservationsModel?.inventoryCategories?[section].topics?.forEach({ topic in
                total = total + (topic.quantity ?? 0)
            })
				headerView.discoveryLabel.text = "\(total)"
				headerView.headerButton.addTarget(self, action: #selector(expentionSelector), for: .touchUpInside)
				return headerView
			case .ourStory:
				return UIView()
		}
		
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch tableDataType{
			case .observations:
				return 40
			case .ourStory:
				return 0
		}
		
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		switch tableDataType {
			case .observations:
				return self.ObservationsModel?.inventoryCategories?.count ?? 0
			case .ourStory:
				return 1
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch tableDataType {
			case .ourStory:
				return self.ourStoryDataModel?.response?.count ?? 0
			case .observations:
				if expendStatus && expendedCell == section {
					return self.ObservationsModel?.inventoryCategories?[section].topics?.count ?? 0
				}else{
					return 0
				}
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch tableDataType {
			case .ourStory:
				return 130
			case .observations:
				if expendStatus && expendedCell == indexPath.section {
					return 136
				} else {
					return 0
				}
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch tableDataType {
			case .ourStory:
            let cell = tableView.dequeCell(of: OurStoryCell(), with: "OurStoryCell", to: indexPath) as! OurStoryCell
            guard let data = ourStoryDataModel?.response?[indexPath.row] else { return UITableViewCell.init()}
            cell.discoveryLabelYou.text = "\(data.discoveries?.partnerADiscoveryScore ?? "0") You"
            cell.discoveryOtherLabel.text = "\(data.discoveries?.partnerADiscoveryScore ?? "0") \(self.ObservationsModel?.name?.split(separator: " ").first ?? "")"
            cell.MainLabel.text = data.title
            cell.dateCountLabel.text = "\((indexPath.row + 1).ordinal!) Date"
            cell.dateLabel.text = data.date!
            
            return cell
        case .observations:
				if expendStatus && expendedCell == indexPath.section {
					//show all data
					let cell = tableView.dequeCell(of: ObservationsCell(), with: "ObservationsCell", to: indexPath) as! ObservationsCell
					let data = self.ObservationsModel?.inventoryCategories?[indexPath.section].topics?[indexPath.row]
					cell.detailviewTitleLabel.text = data?.topicLabel
					cell.detailViewDescriptionLabel.text = "\(data?.myCorrectDiscoveries ?? 0) of \(data?.quantity ?? 0) \(data?.topicLabel ?? "") discovered"
					cell.reviewMyObservationButton.tag = indexPath.row
					cell.detailViewAddButton.tag = indexPath.row
					cell.detailViewAddButton.addTarget(self, action: #selector(newEntryAction), for: .touchUpInside)
					cell.reviewMyObservationButton.addTarget(self, action: #selector(reviewMyObservations), for: .touchUpInside)
					return cell
				}else{
					return UITableViewCell.init()
				}
		}
	}
	
	
	@objc func newEntryAction(_ sender:UIButton) {
		let vc = UIStoryboard(name: "DatingJourney", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewJournalEntryViewController") as! NewJournalEntryViewController
		vc.exp = self.ObservationsModel?.experienceTypes ?? [""]
        vc.groupID = "\(self.groupId)"
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	@objc func reviewMyObservations(_ sender:UIButton) {
		let controller = UIStoryboard(name: "DatingJourney", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReviewMyObservationsViewController") as! ReviewMyObservationsViewController
		controller.modalPresentationStyle = .pageSheet
		controller.delegate = self
		controller.groupId = "\(self.groupId)"//"40"//
		controller.topicId = "\(self.ObservationsModel?.inventoryCategories?[self.expendedCell ?? 0].topics![sender.tag].topicId)" //"1"//
		if let vc = controller.sheetPresentationController{
			vc.detents = [.medium(),.large()]
//			self.prese?.present(vc, animated: true)
		}
		present(controller, animated: true, completion: nil)
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		self.expendStatus = expendedCell == indexPath.section ? false : !expendStatus
//		expendedCell = indexPath
//		self.tableView.reloadRows(at: [indexPath], with: .automatic)
	}
//    func getDateNo(from :String)->String{
//        if from == "0"{
//            return "1st Date"
//        }else if from == "1"{
//            return "2nd Date"
//        }else if from == "2"{
//            return "3rd Date"
//        }else {
//            return "\(from + 1)th Date"
//        }
//    }
}

