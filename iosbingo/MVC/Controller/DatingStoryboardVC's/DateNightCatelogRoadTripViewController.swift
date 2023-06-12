//
//  DateNightCatelogRoadTripViewController.swift
//  iosbingo
//
//  Created by mac on 29/09/22.
//

import UIKit

class DateNightCatelogRoadTripViewController: UIViewController {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_main: UIImageView!
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var view_popUpRoadTrip: UIView!
    @IBOutlet weak var btn_sendOffer: UIButton!
    @IBOutlet weak var lbl_history: UILabel!
    
    var titles = ""
    var selectedIdea = 0
    var dateNightCatelogData : DateNightCatalogDetail?
    var from = ""
    var imageUrl = ""
    var groupId = 0
    var partnerId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(from == "Partner"){
            btn_sendOffer.isHidden = false
            lbl_history.isHidden = true
        }else{
            lbl_history.isHidden = false
            btn_sendOffer.isHidden = true
        }
        
        lbl_title.text = titles
        self.img_main.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: ""))
        self.table_view.separatorStyle = .none
        self.table_view.register(DateNightCatelogRoadTripTableViewCell.nib, forCellReuseIdentifier: DateNightCatelogRoadTripTableViewCell.identifier)
        
        self.view_popUpRoadTrip.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view_popUpRoadTrip.addGestureRecognizer(tap)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view_popUpRoadTrip.isHidden = true
    }
    
    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_sendDateNightOffer(_ sender: Any) {
        //dateNightView.isHidden = true
        let vc = UIStoryboard(name: "DatingJourney", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomDateNightViewController") as! CustomDateNightViewController
        vc.groupId = self.groupId
        vc.partnerId = self.partnerId
        //vc.weekId = self.journeyModel?.journeyHome[0].weekId ?? 1
        //vc.topicId = self.journeyModel?.journeyHome[0].topicId ?? 1

        self.navigationController?.pushViewController(vc, animated: true)
        
        //self.view_popUpRoadTrip.isHidden = false
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        //self.view_popUpRoadTrip.isHidden = true
    }
    
    @IBAction func btn_send(_ sender: Any) {
        
    }
    
    
}
extension DateNightCatelogRoadTripViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table_view.dequeueReusableCell(withIdentifier: DateNightCatelogRoadTripTableViewCell.identifier) as! DateNightCatelogRoadTripTableViewCell
        cell.selectionStyle = .none
        if(indexPath.row == 0){
            cell.lbl_title.text = "The Setting"
            cell.text_subTitle.text = dateNightCatelogData?.setting
        }else if(indexPath.row == 1){
            cell.lbl_title.text = "The Experience"
            cell.lbl_title.textColor = UIColor(red: 21/255, green: 150/255, blue: 16/255, alpha: 1.0)
            cell.text_subTitle.text = dateNightCatelogData?.experience
        }else {
            cell.lbl_title.text = "The Possibilities"
            cell.lbl_title.textColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
            cell.text_subTitle.text = dateNightCatelogData?.possibilities
        }
        
        return cell
        
    }
    
}


extension DateNightCatelogRoadTripViewController {
    
    func dateNightCatelogDetail(){
        AppLoader.shared.show(currentView: self.view)
        let params = ["date_night_id": selectedIdea, "cache": randomString(length: 32)] as [String:Any]
        API.shared.sendData(url: APIPath.dateNightCatalog, requestType: .post, params: params, objectType: DateNightCatalogDetail.self) { (data,status)  in
            if status {
                print(data)
                AppLoader.shared.hide()
                guard data != nil else {return}
                self.dateNightCatelogData = data
                self.table_view.reloadData()
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }
    
}

