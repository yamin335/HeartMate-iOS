//
//  MyAdultingVC.swift
//  iosbingo
//
//  Created by Hamza Saeed on 16/12/2022.
//

import UIKit

class MyAdultingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, VisionSeeDescriptionProtocol {

    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblPrimaryText: UILabel!
    @IBOutlet weak var lblSecondaryText: UILabel!
    @IBOutlet weak var tableViewPrimary: UITableView!
    @IBOutlet weak var tableViewDescription: UITableView!
    @IBOutlet weak var tableViewSecondary: UITableView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var lblDesTitle: UILabel!
    @IBOutlet weak var txtViewDecription: UITextView!

    var visionModel : VisionBoardModel?
    var mindsetValue = ""
    var adultingDecForm = [Form]()
    var adultingPrimaryForm = [Form]()
    var adultingSecondaryForm = [Form]()
    var primarySelectionText = ""
    var secondarySelectionText = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "My Adulting Season"
        lblSubtitle.text = visionModel?.response.userAdultingSeasonPrimary ?? ""
        viewDescription.isHidden = true

        lblPrimaryText.attributedText = NSMutableAttributedString().bold("Select secondary choice ", point: 14).normal("- spending 80% of your money, time, focus, & energy on", point: 14)
        lblSecondaryText.attributedText = NSMutableAttributedString().bold("Select secondary choice ", point: 14).normal("- spending 20% of your money, time, focus, & energy on", point: 14)

        if let data = visionModel{
            for obj in data.response.adultingSeasonForm{
                adultingDecForm.append(obj)
                adultingPrimaryForm.append(obj)
                adultingSecondaryForm.append(obj)
            }
            tableViewPrimary.reloadData()
            tableViewDescription.reloadData()
            tableViewSecondary.reloadData()

        }


    }

    //MARK: - Custom Functions
    func submitAdulting(){
        if primarySelectionText != "" && secondarySelectionText != ""{
            AppLoader.shared.show(currentView: self.view)
            let params = ["primary_selection":primarySelectionText,"secondary_selection":secondarySelectionText] as [String:Any]
            API.shared.sendData(url: APIPath.submitAdultingSeason, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                if status {
                    AppLoader.shared.hide()
                    self.generateAlert(withMsg: "Adulting Season submitted successfully", otherBtnTitle: "Ok") { status in
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

    func onPress(index: IndexPath) {
        lblDesTitle.text = adultingDecForm[index.row].title
        txtViewDecription.text = adultingDecForm[index.row].definition
        viewDescription.isHidden = false

    }

    //MARK: - IBActions
    @IBAction func btnActonHideDescriptionBox(_ sender: UIButton) {
        viewDescription.isHidden = true
    }

    @IBAction func btnActonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActonSubmit(_ sender: UIButton) {
        submitAdulting()
    }

    //MARK: - TableViewMethods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewDescription{
            return adultingDecForm.count

        }else if tableView == tableViewPrimary{
            return adultingPrimaryForm.count

        }else{
            return adultingSecondaryForm.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewDescription{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAdultingDesTableViewCell") as! MyAdultingDesTableViewCell
            cell.lblSessionEntry.text = adultingDecForm[indexPath.row].title
            cell.delegate = self
            cell.index = indexPath
            return cell

        }else if tableView == tableViewPrimary{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAdultingListTableViewCell") as! MyAdultingListTableViewCell
            if adultingPrimaryForm[indexPath.row].isSelected ?? false {
                cell.imgRadio.image = UIImage(named: "checked")
            }else{
                cell.imgRadio.image = UIImage(named: "uncheckRadio-1")
            }
            cell.lblSessionEntry.text = adultingPrimaryForm[indexPath.row].title
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAdultingListTableViewCell") as! MyAdultingListTableViewCell
            if adultingSecondaryForm[indexPath.row].isSelected ?? false {
                cell.imgRadio.image = UIImage(named: "checked")
            }else{
                cell.imgRadio.image = UIImage(named: "uncheckRadio-1")
            }
            cell.lblSessionEntry.text = adultingSecondaryForm[indexPath.row].title
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewPrimary{
            adultingPrimaryForm = adultingPrimaryForm.map{
                var currentObject = $0
                currentObject.isSelected = false
                return currentObject
            }
            adultingPrimaryForm[indexPath.row].isSelected = true
            primarySelectionText = adultingPrimaryForm[indexPath.row].title
            tableViewPrimary.reloadData()

        }else if tableView == tableViewSecondary{
            adultingSecondaryForm = adultingSecondaryForm.map{
                var currentObject = $0
                currentObject.isSelected = false
                return currentObject
            }
            adultingSecondaryForm[indexPath.row].isSelected = true
            secondarySelectionText = adultingPrimaryForm[indexPath.row].title
            tableViewSecondary.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewDescription{
            return 60
        }else{
            return 50
        }
    }

}
