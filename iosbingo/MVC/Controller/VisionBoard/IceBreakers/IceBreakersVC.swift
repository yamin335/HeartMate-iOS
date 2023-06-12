//
//  IceBreakersVC.swift
//  iosbingo
//
//  Created by Hamza Saeed on 17/12/2022.
//

import UIKit
import SDWebImage

class IceBreakersVC: UIViewController,UITableViewDelegate,UITableViewDataSource,IceBreakerCopy {

    //MARK: - IBOutlets
    @IBOutlet weak var imgIceBreaker: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    var visionModel : VisionIceBreakerModel?
    var mindsetValue = ""
    var visionId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        getIceBreakers()

    }

    //MARK: - Custom Functions
    func getIceBreakers(){
        AppLoader.shared.show(currentView: self.view)
        let cache = randomString(length: 32)
        let params = ["cache":cache,"vision_board_id":visionId] as [String:Any]
        API.shared.sendData(url: APIPath.getIceBreakers, requestType: .post, params: params, objectType: VisionIceBreakerModel.self) { (data,status)  in
            if status {
                guard let vision = data else {
                    AppLoader.shared.hide()
                    return}
                AppLoader.shared.hide()
                self.visionModel = vision
                self.imgIceBreaker.sd_setImage(with: URL(string: vision.backgroundImage), placeholderImage: UIImage(named: "defaultProfile"))
                self.tableView.reloadData()
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    func onPress(index: IndexPath) {
        UIPasteboard.general.string = visionModel?.response[index.row].icebreakerQuestion
        showToast(message: "Saved to clipboard")
    }

    //MARK: - IBActions
    @IBAction func btnActonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActonSubmit(_ sender: UIButton) {
        getIceBreakers()
    }

    //MARK: - TableViewMethods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visionModel?.response.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IceBreakerTableViewCell") as! IceBreakerTableViewCell
        if let vision = visionModel {
            cell.lblIceBreaker.text = vision.response[indexPath.row].icebreakerQuestion
        }
        cell.delegate = self
        cell.index = indexPath
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
