//
//  CancelEventViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 02/11/2022.
//

import UIKit

class CancelEventViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    var eventId = 0
    var cancelResonModel : CancelReasonModel?
    var isDatingJourneyModule = false
    var isComingFromNotificationScreen = false

    override func viewDidLoad() {
        super.viewDidLoad()

        getReasons()
    }

    //MARK: - Custom Functions
    func getReasons(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                API.shared.sendData(url: APIPath.getCancelReason, requestType: .post, params: nil, objectType:
                        CancelReasonModel.self) { (data,status)  in
                    if status {
                        guard let data = data else {
                            AppLoader.shared.hide()
                            return
                        }
                        self.cancelResonModel = data
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

    func cancelEvent(reason:Int){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let param = ["event_id":self.eventId,"cancel_reason_id":reason] as [String:Any]

                API.shared.sendData(url: APIPath.cancelEventDateNight, requestType: .post, params: param, objectType:
                        EmptyModel.self) { (data,status)  in
                    if status {
                        self.generateAlert(withMsg: "Event Cancelled", otherBtnTitle: "Ok") { isPressed in
                            if isPressed{
                                if self.isDatingJourneyModule{
                                    for controller in self.navigationController!.viewControllers as Array {
                                        if controller.isKind(of: JourneyCalendarViewController.self) {
                                            self.navigationController!.popToViewController(controller, animated: true)
                                            break
                                        }
                                    }
                                }else if self.isComingFromNotificationScreen{
                                    self.tabBarController?.tabBar.isHidden = false
                                    self.tabBarController?.selectedIndex = 0
                                }else{
                                    self.tabBarController?.tabBar.isHidden = false
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        }
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

    //MARK: - IBActions

    @IBAction func btnActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cancelResonModel?.cancelReasons.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CancelEventTableViewCell") as! CancelEventTableViewCell
        cell.lblReason.text = cancelResonModel?.cancelReasons[indexPath.row].reasonText
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cancelEvent(reason: cancelResonModel?.cancelReasons[indexPath.row].id ?? 0)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}


class CancelEventTableViewCell : UITableViewCell{

    @IBOutlet weak var lblReason: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
