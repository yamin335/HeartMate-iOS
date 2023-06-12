//
//  WhatWorksExperienceViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 20/10/2022.
//

import UIKit

class WhatWorksExperienceViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var ImgHeaderGuide: UIImageView!
    @IBOutlet weak var lblTitleGuide: UILabel!
    @IBOutlet weak var lblTitleScreen: UILabel!
    @IBOutlet weak var lblDescriptionGuide: UILabel!
    @IBOutlet weak var btnNextTitle: UIButton!
    @IBOutlet weak var lblTip1PageNo: UILabel!
    @IBOutlet weak var lblTip1Title: UILabel!
    @IBOutlet weak var lblTip1Description: UILabel!
    @IBOutlet weak var ImgTip1: UIImageView!
    @IBOutlet weak var lblTip2PageNo: UILabel!
    @IBOutlet weak var lblTip2Title: UILabel!
    @IBOutlet weak var lblTip2Description: UILabel!
    @IBOutlet weak var ImgTip2: UIImageView!
    @IBOutlet weak var lblTip3PageNo: UILabel!
    @IBOutlet weak var lblTip3Title: UILabel!
    @IBOutlet weak var lblTip3Description: UILabel!
    @IBOutlet weak var ImgTip3: UIImageView!
    @IBOutlet weak var lblTip4PageNo: UILabel!
    @IBOutlet weak var lblTip4Title: UILabel!
    @IBOutlet weak var lblTip4Description: UILabel!
    @IBOutlet weak var ImgTip4: UIImageView!

    var guideDetail : WhatWorksDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        getWorksDetail()

    }

    //MARK: - Custom Functions
    func getWorksDetail(){
        AppLoader.shared.show(currentView: self.view)
        let params = ["guide_id": 4] as [String:Any]
        API.shared.sendData(url: APIPath.getWhatWorksDetail, requestType: .post, params: params, objectType: WhatWorksDetailModel.self) { (data,status)  in
            if status {
                guard let whatWorksDetail = data else {return}
                self.guideDetail = whatWorksDetail
                self.updateUI()
                AppLoader.shared.hide()
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    func submitAnswer(vote:Int){
        AppLoader.shared.show(currentView: self.view)
        let params = ["guide_id": 4,"vote":vote] as [String:Any]
        API.shared.sendData(url: APIPath.voteForWhatWorks, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
            if status {
                AppLoader.shared.hide()
                self.showAlert(message: "You have voted successfully", titled: "Alert")
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    func updateUI(){
        lblTitleGuide.text = guideDetail?.guide[0].headerTitle
        lblTitleScreen.text = guideDetail?.guide[0].headerTitle
        lblDescriptionGuide.text = guideDetail?.guide[0].summary
        ImgHeaderGuide.sd_setImage(with: URL(string: (guideDetail?.guide[0].headerImage ?? "")), placeholderImage: UIImage(named: "defaultProfile"))

        lblTip1Title.text = guideDetail?.guide[0].tipOne?.title
        lblTip1PageNo.text = guideDetail?.guide[0].tipOne?.tipTitle
        lblTip1Description.text = guideDetail?.guide[0].tipOne?.tipDescription
        ImgTip1.sd_setImage(with: URL(string: (guideDetail?.guide[0].tipOne?.image ?? "")), placeholderImage: UIImage(named: "defaultProfile"))

        lblTip2Title.text = guideDetail?.guide[0].tipTwo?.title
        lblTip2PageNo.text = guideDetail?.guide[0].tipTwo?.tipTitle
        lblTip2Description.text = guideDetail?.guide[0].tipTwo?.tipDescription
        ImgTip2.sd_setImage(with: URL(string: (guideDetail?.guide[0].tipTwo?.image ?? "")), placeholderImage: UIImage(named: "defaultProfile"))

        lblTip3Title.text = guideDetail?.guide[0].tipThree?.title
        lblTip3PageNo.text = guideDetail?.guide[0].tipThree?.tipTitle
        lblTip3Description.text = guideDetail?.guide[0].tipThree?.tipDescription
        ImgTip3.sd_setImage(with: URL(string: (guideDetail?.guide[0].tipThree?.image ?? "")), placeholderImage: UIImage(named: "defaultProfile"))

        lblTip4Title.text = guideDetail?.guide[0].tipFour?.title
        lblTip4PageNo.text = guideDetail?.guide[0].tipFour?.tipTitle
        lblTip4Description.text = guideDetail?.guide[0].tipFour?.tipDescription
        ImgTip4.sd_setImage(with: URL(string: (guideDetail?.guide[0].tipFour?.image ?? "")), placeholderImage: UIImage(named: "defaultProfile"))


        let nextBtnTitle = "Review my Date Night Catalog"
        btnNextTitle.setTitle(nextBtnTitle, for: .normal)

    }

    //MARK: - IBActions

    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActionYes(_ sender: Any) {
        submitAnswer(vote: 1)
    }

    @IBAction func btnActionNo(_ sender: Any) {
        submitAnswer(vote: 2)
    }

    @IBAction func btnActionNextScreen(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DateNightViewController") as! DateNightViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

