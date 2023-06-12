//
//  MyDatingStyleVC.swift
//  iosbingo
//
//  Created by Hamza Saeed on 14/12/2022.
//

import UIKit

class MyDatingStyleVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITableViewDragDelegate {

    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var lblDesTitle: UILabel!
    @IBOutlet weak var txtViewDecription: UITextView!

    var visionModel : VisionBoardModel?
    var mindsetValue = ""
    var datingForm = [Form]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewDescription.isHidden = true
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        lblTitle.text = "My Dating Style"
        if let vision = visionModel{
            if vision.response.userDatingStyle?.count ?? 0 > 0 {
                for obj in vision.response.userDatingStyle!{
                    datingForm.append(obj)
                }
            }else{
                for obj in vision.response.datingStyleForm{
                    datingForm.append(obj)
                }
            }

            lblSubtitle.text = datingForm[0].headerTitle
            tableView.reloadData()
        }

    }

    //MARK: - Custom Functions
    func submitDatingStyle(){
        if datingForm.count > 0 {
            AppLoader.shared.show(currentView: self.view)
            var params = [String:Any]()
            var count = 0
            for obj in datingForm{
                count = count + 1
                params["entry_\(count)"] = obj.title
            }
            API.shared.sendData(url: APIPath.submitDatingStyle, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                if status {
                    AppLoader.shared.hide()
                    self.generateAlert(withMsg: "Dating Style submitted successfully", otherBtnTitle: "Ok") { status in
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
            showAlert(message: "No dating style found")
        }

    }

    //MARK: - IBActions
    @IBAction func btnActonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActonHideBox(_ sender: UIButton) {
        self.viewDescription.isHidden = true
    }

    @IBAction func btnActonSubmit(_ sender: UIButton) {
        submitDatingStyle()
    }

    //MARK: - TableViewMethods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datingForm.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyDatingStyleTableViewCell") as! MyDatingStyleTableViewCell
        cell.lblTitle.text = datingForm[indexPath.row].title
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200/3
    }

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = datingForm[indexPath.row]
        return [dragItem]
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else {
            return
        }
        let item = datingForm[sourceIndexPath.row]
        if sourceIndexPath.row < destinationIndexPath.row {
            datingForm.insert(item, at: destinationIndexPath.row + 1)
            datingForm.remove(at: sourceIndexPath.row)
        } else {
            datingForm.remove(at: sourceIndexPath.row)
            datingForm.insert(item, at: destinationIndexPath.row)
        }

        lblSubtitle.text = datingForm[0].headerTitle

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        lblDesTitle.text = datingForm[indexPath.row].title
        txtViewDecription.text = datingForm[indexPath.row].definition
        viewDescription.isHidden = false

    }
}
