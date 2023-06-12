//
//  ReviewMyObservationsViewController.swift
//  iosbingo
//
//  Created by Macintosh on 15/12/22.
//

import UIKit


protocol newEntryProtocol {
//	func setupforNewEntry(_ show: Bool,topicID:String)
	func setupforNewEntry(_ show: Bool,topicID:String,getEntry:Bool,entryId:String)
}


class ReviewMyObservationsViewController: UIViewController {
	
	
	@IBOutlet weak var bottomView: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var discoverdStatusLabel: UILabel!
	@IBOutlet weak var discoveredStatusLabelCheckImg: UIImageView!
	@IBOutlet weak var mainLabel: UILabel!
	
    
		//MARK: - Properties
	var delegate: newEntryProtocol? = nil
	var observationsModel : ReviewMyObservationsModel?
	var topicId: String = ""
	var groupId: String = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.rowHeight = UITableView.automaticDimension

		getTopenteries()
	}
	
		//MARK: - New Observations Button Action
	@IBAction func newObservationsAction(_ sender: UIButton) {
		print("Dismissing")
		if self.delegate != nil{
//			self.delegate?.setupforNewEntry(true,topicID: self.topicId)
			self.delegate?.setupforNewEntry(true,topicID: topicId, getEntry: false, entryId: "")
			dismiss(animated: true, completion: nil)
		}
	}
	
	func getTopenteries(){
		AppLoader.shared.show(currentView: self.tableView)
		API.shared.ValidateToken { isValid in
			if isValid{
                let params = [
                    "group_id":self.groupId,
                    "topic_id":self.topicId
                ]
                API.shared.sendData(url: APIPath.getTopEntery+"?group_id=\(self.groupId)&topic_id=\(self.topicId)", requestType: .post, params: ["":""], objectType: ReviewMyObservationsModel.self) { (data,status)  in
					if status {
						guard let observations = data else {
							AppLoader.shared.hide()
							return}
						
						self.observationsModel = observations
						self.tableView.reloadData()
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
	
}

extension ReviewMyObservationsViewController:UITableViewDelegate, UITableViewDataSource {
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.observationsModel?.journals?.count ?? 0
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 110
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as? ReviewTableViewCell else{
            return UITableViewCell.init()
            }
		let data = self.observationsModel?.journals?[indexPath.row]
		cell.statusLabel.text = data?.reviewStatus
		cell.contentLabel.text = data?.content
		if data?.reviewStatus?.lowercased() == "pending" {
			cell.statusLabel.textColor = .red
		}else if data?.reviewStatus?.lowercased() == "draft" {
            cell.statusLabel.backgroundColor = .yellow
		}else if data?.reviewStatus?.lowercased() == "correct" {
            cell.statusLabel.backgroundColor = .green
		}
		cell.updatebutton.tag = indexPath.row
		if data?.reviewStatus?.lowercased() != "draft"{
			cell.updatebutton.isHidden = true
		}else{
			cell.updatebutton.isHidden = false
			cell.updatebutton.addTarget(self, action: #selector(updateAction), for: .touchUpInside)
		}
        cell.dateLbl.text = "month day year"
        cell.exp.text = "[Exp Type]"
		cell.selectionStyle = .none
        return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let data = self.observationsModel?.journals?[indexPath.row].id
//		let vc = UIStoryboard(name: "DatingJourney", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewJournalEntryViewController") as! NewJournalEntryViewController
//		vc.getEntry = true
//		vc.entryID = "\(self.observationsModel?.journals?[indexPath.row].id)"
//		self.navigationController?.present(vc, animated: true)
		print("Dismissing")
		if self.delegate != nil{
			self.delegate?.setupforNewEntry(true,topicID: self.topicId,getEntry:true,entryId:"\(self.observationsModel?.journals?[indexPath.row].id)")
			dismiss(animated: true, completion: nil)
		}
		
	}
	
	@objc func updateAction(_ sender:UIButton){
        let vc = UIStoryboard(name: "DatingJourney", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewJournalEntryViewController") as! NewJournalEntryViewController
        vc.getEntry = false
        vc.entryID = "\(self.observationsModel?.journals?[sender.tag].id)"
        self.navigationController?.pushViewController(vc, animated: true)
	}
	
	
}
