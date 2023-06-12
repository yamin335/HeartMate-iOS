//
//  MyMindsetVC.swift
//  iosbingo
//
//  Created by Hamza Saeed on 14/12/2022.
//

import UIKit

class MyMindsetVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var visionModel : VisionBoardModel?
    var mindsetValue = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "My Mindset"
        lblSubtitle.text = visionModel?.response.userMindset ?? ""
        if let vision = visionModel {
            vision.response.mindsetForm = vision.response.mindsetForm.map{
                let currentObject = $0
                if currentObject.title.contains(vision.response.userMindset){
                    currentObject.isSelected = true
                    mindsetValue = vision.response.userMindset
                    return currentObject
                }else{
                    currentObject.isSelected = false
                    return currentObject
                }
            }
            tableView.reloadData()
        }

    }

    //MARK: - Custom Functions
    func submitMindset(){
        if mindsetValue != "" {
            AppLoader.shared.show(currentView: self.view)
            let params = ["mindset":mindsetValue] as [String:Any]
            API.shared.sendData(url: APIPath.submitMindset, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                if status {
                    AppLoader.shared.hide()
                    self.generateAlert(withMsg: "Mindset submitted successfully", otherBtnTitle: "Ok") { status in
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
            showAlert(message: "Please select mindset value")
        }

    }

    //MARK: - IBActions
    @IBAction func btnActonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActonSubmit(_ sender: UIButton) {
        submitMindset()
    }

    //MARK: - TableViewMethods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visionModel?.response.mindsetForm.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMindsetTableViewCell") as! MyMindsetTableViewCell
        if let vision = visionModel {
            if vision.response.mindsetForm[indexPath.row].isSelected ?? false {
                cell.imgRadio.image = UIImage(named: "checked")
            }else{
                cell.imgRadio.image = UIImage(named: "uncheckRadio-1")
            }
            cell.lblMindsetEntry.text = vision.response.mindsetForm[indexPath.row].title
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vision = visionModel {
            vision.response.mindsetForm = vision.response.mindsetForm.map{
                let currentObject = $0
                currentObject.isSelected = false
                return currentObject
            }
            vision.response.mindsetForm[indexPath.row].isSelected = true
            mindsetValue = vision.response.mindsetForm[indexPath.row].title
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
