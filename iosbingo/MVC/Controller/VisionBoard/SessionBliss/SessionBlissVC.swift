//
//  SessionBlissVC.swift
//  iosbingo
//
//  Created by Hamza Saeed on 16/12/2022.
//

import UIKit

class SessionBlissVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblPrimaryText: UILabel!
    @IBOutlet weak var lblSecondaryText: UILabel!
    @IBOutlet weak var tableViewPrimary: UITableView!
    @IBOutlet weak var tableViewSecondary: UITableView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var lblDesTitle: UILabel!
    @IBOutlet weak var txtViewDecription: UITextView!

    var visionModel : VisionBoardModel?
    var mindsetValue = ""
    var seasonPrimaryForm = [Form]()
    var seasonSecondaryForm = [Form]()
    var primarySelectionText = ""
    var secondarySelectionText = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "My Session of Bliss"
        lblSubtitle.text = visionModel?.response.userBlissPrimary ?? ""
        viewDescription.isHidden = true
        lblDetail.attributedText = NSMutableAttributedString().normal("Which of the adulting seasons could you spend ", point: 16).bold("18 years of your life  ", point: 16).normal("maintaining and reaching for new heights of excellence within?", point: 16)

        lblPrimaryText.attributedText = NSMutableAttributedString().bold("Select primary choice ", point: 14).normal("- spending 80% of your money, time, focus, & energy on", point: 14)
        lblSecondaryText.attributedText = NSMutableAttributedString().bold("Select secondary choice ", point: 14).normal("- spending 20% of your money, time, focus, & energy on", point: 14)

        updateModel()


    }

    //MARK: - Custom Functions

    func updateModel(){
        if let data = visionModel{
            for obj in data.response.seasonOfBlissForm{
                seasonPrimaryForm.append(obj)
                seasonSecondaryForm.append(obj)
            }

            tableViewPrimary.reloadData()
            tableViewSecondary.reloadData()
        }
    }

    func submitSession(){
        if primarySelectionText != "" && secondarySelectionText != ""{
            AppLoader.shared.show(currentView: self.view)
            let params = ["primary_selection":primarySelectionText,"secondary_selection":secondarySelectionText] as [String:Any]
            API.shared.sendData(url: APIPath.submitSeasonBliss, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                if status {
                    AppLoader.shared.hide()
                    self.generateAlert(withMsg: "Season of Bliss submitted successfully", otherBtnTitle: "Ok") { status in
                        if status{
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }else{
                    AppLoader.shared.hide()
                    print("Error found")
                }
            }
        }else{
            showAlert(message: "Please select the primary and secondary value")
        }

    }

    //MARK: - IBActions
    @IBAction func btnActonHideDescriptionBox(_ sender: UIButton) {
        viewDescription.isHidden = true
    }

    @IBAction func btnActonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActonSubmit(_ sender: UIButton) {
        submitSession()
    }

    //MARK: - TableViewMethods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewPrimary{
            return seasonPrimaryForm.count

        }else{
            return seasonSecondaryForm.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewPrimary{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SessionBlissTableViewCell") as! SessionBlissTableViewCell
            if seasonPrimaryForm[indexPath.row].isSelected ?? false {
                cell.imgRadio.image = UIImage(named: "checked")
            }else{
                cell.imgRadio.image = UIImage(named: "uncheckRadio-1")
            }
            cell.lblSessionEntry.text = seasonPrimaryForm[indexPath.row].title
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SessionBlissTableViewCell") as! SessionBlissTableViewCell
            if seasonSecondaryForm[indexPath.row].isSelected ?? false {
                cell.imgRadio.image = UIImage(named: "checked")
            }else{
                cell.imgRadio.image = UIImage(named: "uncheckRadio-1")
            }
            cell.lblSessionEntry.text = seasonSecondaryForm[indexPath.row].title
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewPrimary{
            seasonPrimaryForm = seasonPrimaryForm.map{
                let currentObject = $0
                currentObject.isSelected = false
                return currentObject
            }
            seasonPrimaryForm[indexPath.row].isSelected = true
            primarySelectionText = seasonPrimaryForm[indexPath.row].title
            tableViewPrimary.reloadData()

        }else if tableView == tableViewSecondary{
            seasonSecondaryForm = seasonSecondaryForm.map{
                let currentObject = $0
                currentObject.isSelected = false
                return currentObject
            }
            seasonSecondaryForm[indexPath.row].isSelected = true
            secondarySelectionText = seasonSecondaryForm[indexPath.row].title
            tableViewSecondary.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
