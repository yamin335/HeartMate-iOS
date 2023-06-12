//
//  VisionBoardHomeVC.swift
//  iosbingo
//
//  Created by Hamza Saeed on 11/12/2022.
//

import UIKit
import CoreMIDI

class VisionBoardHomeVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var adultingView: CurvedShapes!
    @IBOutlet weak var partnerView: CurvedShapes!
    @IBOutlet weak var sessionView: CurvedShapes!
    @IBOutlet weak var datingView: CurvedShapes!
    @IBOutlet weak var lblMindset: UILabel!
    @IBOutlet weak var lblAdulting: UILabel!
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var lblDating: UILabel!

    var visionModel : VisionBoardModel?
    var isMindsetFormEmpty = true
    var isAdultingFormEmpty = true
    var isSessionFormEmpty = true
    var isDatingFormEmpty = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        getVisionModel()
    }

    //MARK: - Custom Functios

    func setupUI(){
        adultingView.viewColor = UIColor(hexString: "351C56")
        adultingView.drawCurve()
        partnerView.viewColor = UIColor(hexString: "0A4347")
        partnerView.drawCurve()
        sessionView.viewColor = UIColor(hexString: "1596A1")
        sessionView.drawCurve()
        datingView.viewColor = UIColor(hexString: "D99B3F")
        datingView.drawCurve()
    }

    func updateLabels(){
        lblMindset.text = visionModel?.response.userMindset
        lblAdulting.text = visionModel?.response.userAdultingSeasonPrimary
        lblSeason.text = visionModel?.response.userBlissPrimary
        lblDating.text = visionModel?.response.userDatingStyle?.count ?? 0 > 0 ? visionModel?.response.userDatingStyle?[0].title : "UNDECIDED"
    }

    func getVisionModel(){
        AppLoader.shared.show(currentView: self.view)
        let cache = randomString(length: 32)
        let params = ["cache":cache] as [String:Any]
        API.shared.sendData(url: APIPath.visionBoard, requestType: .post, params: params, objectType: VisionBoardModel.self) { (data,status)  in
            if status {
                guard let visionModel = data else {return}
                self.visionModel = visionModel
                self.updateLabels()
                AppLoader.shared.hide()
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    func sendValidationMessage() -> (String,String,String,String,String){
        var tapTitle = ""
        var firstLbl = ""
        var secondLabel = ""
        var thirdLabed = ""
        var colorCode = ""

        if isMindsetFormEmpty && isAdultingFormEmpty && isSessionFormEmpty && isDatingFormEmpty {
            tapTitle = "My Mindset"
            firstLbl = "My Adulting Season"
            secondLabel = "My Season of Bliss"
            thirdLabed = "My Dating Style"
            colorCode = "DE482F"

        }else if !isMindsetFormEmpty && !isAdultingFormEmpty && isSessionFormEmpty && isDatingFormEmpty{
            tapTitle = "My Season of Bliss"
            firstLbl = "My Dating Style"
            colorCode = "1596A1"

        }else if !isMindsetFormEmpty && !isAdultingFormEmpty && !isSessionFormEmpty && isDatingFormEmpty{
            tapTitle = "My Dating Style"
            colorCode = "D99B3F"

        }else if !isMindsetFormEmpty && isAdultingFormEmpty && isSessionFormEmpty && isDatingFormEmpty{
            tapTitle = "My Adulting Season"
            firstLbl = "My Season of Bliss"
            secondLabel = "My Dating Style"
            colorCode = "351C56"

        }else if isMindsetFormEmpty && !isAdultingFormEmpty && isSessionFormEmpty && isDatingFormEmpty{
            tapTitle = "My Mindset"
            firstLbl = "My Season of Bliss"
            secondLabel = "My Dating Style"
            colorCode = "DE482F"

        }else if isMindsetFormEmpty && isAdultingFormEmpty && !isSessionFormEmpty && isDatingFormEmpty{
            tapTitle = "My Mindset"
            firstLbl = "My Adulting Season"
            secondLabel = "My Dating Style"
            colorCode = "DE482F"

        }else if isMindsetFormEmpty && isAdultingFormEmpty && isSessionFormEmpty && !isDatingFormEmpty{
            tapTitle = "My Mindset"
            firstLbl = "My Adulting Season"
            secondLabel = "My Season of Bliss"
            colorCode = "DE482F"

        }else if !isMindsetFormEmpty && !isAdultingFormEmpty && isSessionFormEmpty && !isDatingFormEmpty{
            tapTitle = "My Season of Bliss"
            colorCode = "1596A1"

        }else if !isMindsetFormEmpty && isAdultingFormEmpty && !isSessionFormEmpty && !isDatingFormEmpty{
            tapTitle = "My Adulting Season"
            colorCode = "351C56"

        }else if isMindsetFormEmpty && !isAdultingFormEmpty && !isSessionFormEmpty && !isDatingFormEmpty{
            tapTitle = "My Mindset"
            colorCode = "DE482F"

        }else if !isMindsetFormEmpty && isAdultingFormEmpty && isSessionFormEmpty && !isDatingFormEmpty{
            tapTitle = "My Adulting Season"
            firstLbl = "My Season of Bliss"
            colorCode = "351C56"

        }else if isMindsetFormEmpty && !isAdultingFormEmpty && !isSessionFormEmpty && isDatingFormEmpty{
            tapTitle = "My Mindset"
            firstLbl = "My Dating Style"
            colorCode = "DE482F"

        }else if !isMindsetFormEmpty && isAdultingFormEmpty && !isSessionFormEmpty && isDatingFormEmpty{
            tapTitle = "My Adulting Season"
            firstLbl = "My Dating Style"
            colorCode = "351C56"
        }

        return (tapTitle,firstLbl,secondLabel,thirdLabed,colorCode)

    }

    func checkEmptyFormForVision() -> Bool{
        isMindsetFormEmpty = lblMindset.text?.lowercased() == "tap here to start" ? true : false
        isAdultingFormEmpty = lblAdulting.text?.lowercased() == "undecided" ? true : false
        isSessionFormEmpty = lblSeason.text?.lowercased() == "undecided" ? true : false
        isDatingFormEmpty = visionModel?.response.userDatingStyle?.count == 0 ? true : false

        if isMindsetFormEmpty || isAdultingFormEmpty || isSessionFormEmpty || isDatingFormEmpty{
            return false
        }else{
            return true
        }
    }

    //MARK: - IBActions

    @IBAction func btnActonMindset(_ sender: UIButton) {
        print("mindset")
        let vc = UIStoryboard(name: "VisionBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyMindsetVC") as! MyMindsetVC
        vc.visionModel = visionModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActonAdultig(_ sender: UIButton) {
        print("adulting")
        let vc = UIStoryboard(name: "VisionBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyAdultingVC") as! MyAdultingVC
        vc.visionModel = visionModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActonSession(_ sender: UIButton) {
        print("session")
        let vc = UIStoryboard(name: "VisionBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "SessionBlissVC") as! SessionBlissVC
        vc.visionModel = visionModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActonDating(_ sender: UIButton) {
        print("dating")
        let vc = UIStoryboard(name: "VisionBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyDatingStyleVC") as! MyDatingStyleVC
        vc.visionModel = visionModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActonPartner(_ sender: UIButton) {
        print("partner")
        if !checkEmptyFormForVision(){
            let (title,firstLbl,secondLbl,thirdLbl,colorCode) = sendValidationMessage()
            let vc = UIStoryboard(name: "VisionBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "VisionValidationBoardVC") as! VisionValidationBoardVC
            vc.tapTitle = title
            vc.firstLbl = firstLbl
            vc.secondLabel = secondLbl
            vc.thirdLabed = thirdLbl
            vc.colorCode = colorCode
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = UIStoryboard(name: "VisionBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "PartnerVisionVC") as! PartnerVisionVC
            vc.visionId = visionModel?.response.visionBoardID ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
