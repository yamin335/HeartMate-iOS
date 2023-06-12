//
//  DateNightCatelogIdeaViewController.swift
//  iosbingo
//
//  Created by mac on 29/09/22.
//

import UIKit

class DateNightCatelogIdeaViewController: UIViewController {

    @IBOutlet weak var table_view: UITableView!
    var selectedJourneys: Journey?
    var dateNightCatelogData : [DateNightCatalogs]?
    @IBOutlet weak var view_upgrade: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
    var tvm = 0
    var from = ""
    var firstName = ""
    var groupId = 0
    var partnerId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(from == "Partner"){
            view_upgrade.isHidden = false
            lbl_title.text = "\(tvm) Experiences, Dates, &\nInteractions"
            lbl_subTitle.text = "Learn the story behind \n\(firstName) numbers"
        }else{
            view_upgrade.isHidden = true
            lbl_title.text = "\(tvm) Date Ideas"
            lbl_subTitle.text = "Set the scene and setting \nto share your story."
        }
        
        if #available(iOS 15.0, *){
            self.table_view.sectionHeaderTopPadding = 0.0
        }
        self.table_view.separatorStyle = .none
        self.table_view.register(DatingNightCatelogHeader.nib, forHeaderFooterViewReuseIdentifier: DatingNightCatelogHeader.identifier)
        self.table_view.register(DateNightCatelogWeeksIdeaTableViewCell.nib, forCellReuseIdentifier: DateNightCatelogWeeksIdeaTableViewCell.identifier)
        self.table_view.register(DatingNightCatelogIdeaPremiumExperienceTableViewCell.nib, forCellReuseIdentifier: DatingNightCatelogIdeaPremiumExperienceTableViewCell.identifier)
       
        //self.dateNightCatelog()
    }
    
    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btn_upgradeClicked(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipController") as! MembershipController
        vc.subscritionType = .level2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension DateNightCatelogIdeaViewController : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0){
            let headerView  = tableView.dequeueReusableHeaderFooterView(withIdentifier: DatingNightCatelogHeader.identifier) as! DatingNightCatelogHeader
            if(dateNightCatelogData?.count ?? 0 > 0){
                headerView.lbl_title.text! = from == "Partner" ? "This week’s ideas" : dateNightCatelogData?[0].weekNumber ?? "Week 1"
            }else{
                headerView.lbl_title.text! = from == "Partner" ? "This week’s ideas" : "Week 1"
            }
            
            headerView.btn_seeAll.isHidden = true
            return headerView
        } else {
            let headerView  = tableView.dequeueReusableHeaderFooterView(withIdentifier: DatingNightCatelogHeader.identifier) as! DatingNightCatelogHeader
            headerView.lbl_title.text! = "Premium Experiences Near Us"
            return headerView
        }
      
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return from == "Partner" ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = table_view.dequeueReusableCell(withIdentifier: DateNightCatelogWeeksIdeaTableViewCell.identifier) as! DateNightCatelogWeeksIdeaTableViewCell
            cell.selectionStyle = .none
            if(dateNightCatelogData?.count ?? 0 > 0){
                if let safeDates = dateNightCatelogData?[0].dates{
                    cell.setData(dateNightCatalog: safeDates)
                }
                cell.routeAction = { (sender) in
                    let vc = UIStoryboard(name: "Dating", bundle: Bundle.main).instantiateViewController(withIdentifier: "DateNightCatelogRoadTripViewController") as! DateNightCatelogRoadTripViewController
                    vc.from = self.from
                    if let safeDates = self.dateNightCatelogData?[0].dates{
                        vc.selectedIdea = safeDates[sender].dateNightID
                        vc.titles = safeDates[sender].title
                        vc.imageUrl = safeDates[sender].imageURL ?? ""
                        vc.groupId = self.groupId
                        vc.partnerId = self.partnerId
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return cell
        } else {
            let cell = table_view.dequeueReusableCell(withIdentifier: DatingNightCatelogIdeaPremiumExperienceTableViewCell.identifier) as! DatingNightCatelogIdeaPremiumExperienceTableViewCell
            cell.setData()
            cell.selectionStyle = .none
            return cell
        }
    }
    
}

extension DateNightCatelogIdeaViewController{
    
//    func loadDateNightCatalog() {
//       AppLoader.shared.show(currentView: self.view)
//       let userID = AppUserDefault.shared.getValueInt(for: .UserID)
//
//        let queryItems = [URLQueryItem(name: "page", value: "1"), URLQueryItem(name: "can_see_promoted", value: "1"),  URLQueryItem(name: "group_id", value: "40")]
//        var urlComps = URLComponents(string: APIPath.dateNightCatalog)!
//        urlComps.queryItems = queryItems
//
//        API.shared.sendData(url: urlComps.url?.absoluteString ?? "", requestType: .get, params: [:], objectType: DateNightCatalogsData.self) { (data, status)  in
//            if status {
//                AppLoader.shared.hide()
//                guard data != nil else {return}
//                self.dateNightCatelogData = data
//                self.table_view.reloadData()
//            }else{
//                AppLoader.shared.hide()
//                print("Error found")
//            }
//        }
//    }
//
//    func dateNightCatelog(){
//        AppLoader.shared.show(currentView: self.view)
//        let params = ["page": "1", "group_id":"40"] as [String:Any]
//        API.shared.sendData(url: APIPath.dateNightCatalog, requestType: .post, params: params, objectType: DateNightCatalogsData.self) { (data,status)  in
//            if status {
//                print(data)
//                AppLoader.shared.hide()
//                guard data != nil else {return}
//                self.dateNightCatelogData = data
//                self.table_view.reloadData()
//            }else{
//                AppLoader.shared.hide()
//                print("Error found")
//            }
//        }
//    }
    
}
