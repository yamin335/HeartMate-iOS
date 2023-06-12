//
//  Level1HistoyViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 17/11/2022.
//

import UIKit

class Level1HistoyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,OnInvitationDelete {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEmptyHistory: UILabel!

    var historyModel :  Level1HistoryModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        lblEmptyHistory.isHidden = true
        getHistory()

    }

    //MARK: - CustomActions
    func onDelete(index: IndexPath, sender: UIButton) {
        guard let histroyData = historyModel else {return}
        deleteHistoy(code: histroyData.data?[index.row].invitationCode ?? "", groupId: histroyData.data?[index.row].groupID ?? 0)
    }

    func getHistory(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let cookie = randomString(length: 32)
                let params = ["cookie":cookie] as [String:Any]
                API.shared.sendData(url: APIPath.getLevel1History, requestType: .post, params: params, objectType: Level1HistoryModel.self) { (data,status)  in
                    if status {
                        guard let historyData = data else {
                            AppLoader.shared.hide()
                            return
                        }
                        self.historyModel = historyData
                        if historyData.data == nil {
                            self.lblEmptyHistory.isHidden = false
                            self.lblEmptyHistory.text = historyData.message ?? ""
                            self.tableView.reloadData()
                        }else{
                            self.lblEmptyHistory.isHidden = true
                            self.tableView.reloadData()
                        }
                        AppLoader.shared.hide()
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

    func deleteHistoy(code:String,groupId:Int){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = ["invitation_code":code,"group_id":groupId] as [String:Any]
                API.shared.sendData(url: APIPath.deleteLevel1History, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                    if status {
                        self.showAlert(message: "Invitation Deleted Successfully", titled: "Alert")
                        self.getHistory()
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
    
    //MARK: - Button Actions

    @IBAction func btnActionBack(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let history = historyModel {
            return history.data?.count ?? 0
        }else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Level1HistoyTableViewCell") as! Level1HistoyTableViewCell
        cell.lblPhone.text = historyModel?.data?[indexPath.row].inviteeNumber ?? ""
        cell.lblPending.text = String(historyModel?.data?[indexPath.row].daysPending ?? 0)
        cell.delegate = self
        cell.index = indexPath
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    

}

protocol OnInvitationDelete{
    func onDelete(index:IndexPath,sender:UIButton)
}


class Level1HistoyTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblPending: UILabel!

    var delegate : OnInvitationDelete?
    var index:IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0))
    }

    @IBAction func btnDeleteAction(_ sender: UIButton) {
        delegate?.onDelete(index: index!, sender: sender)
    }

}
