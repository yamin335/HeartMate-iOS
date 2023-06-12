//
//  DateNightCatelogCoverViewController.swift
//  iosbingo
//
//  Created by mac on 29/09/22.
//

import UIKit
import SDWebImage

class DateNightCatelogCoverViewController: UIViewController {

    @IBOutlet weak var img_cover: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    var selectedJourneys: Journey?
    var dateNightCatelogData : DateNightCatalogsData?
    var dateNightCatelogPartnerData : DateNightCatalogPartnerData?
    
    var from = ""
    var groupId = 0
    var partnerUserId = 0
    var firstName = ""
    var tvm = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(from == "Partner"){
            dateNightCatelogPartner()
            self.lbl_title.text = "\(firstName)\nDate Night Catalog"
        }else{
            dateNightCatelog()
            self.lbl_title.text = "My Date Night Catalog"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btn_back(_ sender: Any) {
        if AppUserDefault.shared.getValueBool(for: .isUserRegistering) {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrimerVIViewController") as! PrimerVIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
       
    }

    @IBAction func btn_guideMeClick(_ sender: Any) {
        self.pushController(controllerName: "DateNightCatelogIdeaViewController", storyboardName: "Dating")
    }
    
    func dateNightCatelog(){
        AppLoader.shared.show(currentView: self.view)
        let params = ["page": "1", "cache": randomString(length: 32)] as [String:Any]
        API.shared.sendData(url: APIPath.dateNightCatalog, requestType: .post, params: params, objectType: DateNightCatalogsData.self) { (data,status)  in
            if status {
                AppLoader.shared.hide()
                guard data != nil else {return}
                self.dateNightCatelogData = data
                self.img_cover.sd_setImage(with: URL(string: self.dateNightCatelogData?.dateNightCatalogCover.url ?? ""), placeholderImage: UIImage(named: "Datingbackground"))
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }
    
    func dateNightCatelogPartner(){
        AppLoader.shared.show(currentView: self.view)
        let params = ["group_id": groupId, "partner_user_id" : partnerUserId, "cache": randomString(length: 32)] as [String:Any]
        API.shared.sendData(url: APIPath.getPartnerDateNightCatalog, requestType: .post, params: params, objectType: DateNightCatalogPartnerData.self) { (data,status)  in
            if status {
                AppLoader.shared.hide()
                guard data != nil else {return}
                self.dateNightCatelogPartnerData = data
                self.img_cover.sd_setImage(with: URL(string: self.dateNightCatelogPartnerData?.dateNightCatalogCover.url ?? ""), placeholderImage: UIImage(named: "Datingbackground"))
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }
    
}

extension DateNightCatelogCoverViewController{
    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName) as! DateNightCatelogIdeaViewController
        vc.selectedJourneys = self.selectedJourneys
        vc.from = self.from
        vc.tvm = self.tvm
        vc.firstName = self.firstName
        vc.groupId = self.groupId
        vc.partnerId = self.partnerUserId
        if(from == "Partner"){
            print(self.dateNightCatelogPartnerData)
            if let safeDateNightCatalog = self.dateNightCatelogPartnerData?.dateNightCatalog{
                vc.dateNightCatelogData = safeDateNightCatalog
            }
        }else{
            if let safeDateNightCatalog = self.dateNightCatelogData?.dateNightCatalog{
                vc.dateNightCatelogData = safeDateNightCatalog
                
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


