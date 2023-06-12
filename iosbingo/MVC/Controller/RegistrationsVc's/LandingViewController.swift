//
//  LandingViewController.swift
//  iosbingo
//
//  Created by apple on 30/08/22.
//

import UIKit
import AVFoundation

class LandingViewController: UIViewController {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
    
    @IBOutlet weak var lbl_tnc: UILabel!
    @IBOutlet weak var btn_createAccount: UIButton!
    @IBOutlet weak var btn_signIn: UIButton!
    @IBOutlet weak var stack_view: UIStackView!
    
    @IBOutlet var video_View: UIView!
    var player : AVPlayer!
    
    var getCorporateInfos : GetCorporateInfo?{
        didSet{
            AppUserDefault.shared.set(value: getCorporateInfos?.onboardingVideo ?? "", for: .onBoardingVideo)
            AppUserDefault.shared.set(value: getCorporateInfos?.helpCenter ?? "", for: .helpCenter)
            AppUserDefault.shared.set(value: getCorporateInfos?.privacyPolicy ?? "", for: .privacyPolicy)
            AppUserDefault.shared.set(value: getCorporateInfos?.termsOfService ?? "", for: .termsOfService)
            AppUserDefault.shared.set(value: getCorporateInfos?.licenses ?? "", for: .licenses)
            AppUserDefault.shared.set(value: getCorporateInfos?.safeDatingTips ?? "", for: .safeDatingTips)
            AppUserDefault.shared.set(value: getCorporateInfos?.memberPrinciples ?? "", for: .memberPrinciples)
            AppUserDefault.shared.set(value: getCorporateInfos?.numberChanges ?? "", for: .numberChanges)
            AppUserDefault.shared.set(value: getCorporateInfos?.nonExclusiveDatingPartners ?? "", for: .nonExclusiveDatingPartners)
            AppUserDefault.shared.set(value: getCorporateInfos?.nonExclusiveDatingPartners ?? "", for: .nonExclusiveDatingPartners)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if AppUserDefault.shared.getValue(for: .onBoardingVideo) != "" {
            self.playVideo(videoUrl: AppUserDefault.shared.getValue(for: .onBoardingVideo))
            video_View.isHidden = false
        }else{
            video_View.isHidden = true
        }
        self.getCorporateInfo()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: nil,
                                               queue: nil) { [weak self] note in
            self?.player.seek(to: CMTime.zero)
            self?.player.play()
        }
        
        //let lbl = UILabel(frame : self.lbl_tnc.frame)
        lbl_tnc.translatesAutoresizingMaskIntoConstraints = false
        lbl_tnc.numberOfLines = 0
 
        let fullString = NSMutableAttributedString(string: "By tapping \"Continue\", you agree to our  ", attributes: [.font: UIFont(name: "Inter-Regular", size: 13)!, .foregroundColor: UIColor.white])
        
        fullString.append(NSAttributedString(string:"Terms of Service", attributes: [.font: UIFont(name: "Inter-Regular", size: 13)!, .foregroundColor: UIColor.white, .underlineStyle : NSUnderlineStyle.single.rawValue]))
        
        fullString.append(NSMutableAttributedString(string:". Learn how we process your data in our ", attributes: [.font: UIFont(name: "Inter-Regular", size: 13)!, .foregroundColor: UIColor.white]))
        
        fullString.append(NSAttributedString(string:"Privacy Policy", attributes: [.font: UIFont(name: "Inter-Regular", size: 13)!, .foregroundColor: UIColor.white, .underlineStyle : NSUnderlineStyle.single.rawValue]))
        
        fullString.append(NSMutableAttributedString(string:" and ", attributes: [.font: UIFont(name: "Inter-Regular", size: 13)!, .foregroundColor: UIColor.white]))
        
        fullString.append(NSAttributedString(string:"Cookies Policy.", attributes: [.font: UIFont(name: "Inter-Regular", size: 13)!, .foregroundColor: UIColor.white, .underlineStyle : NSUnderlineStyle.single.rawValue]))
        
        lbl_tnc.attributedText = fullString
        
        lbl_tnc.isUserInteractionEnabled = true
        lbl_tnc.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsTapOnLbl(_:))))

    }
    
    
    private func playVideo(videoUrl : String) {
        guard let path = URL(string: videoUrl) else {
            debugPrint("intro.mp4 not found")
            return
        }
        player = AVPlayer(url: path)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
        video_View.isHidden = false
        self.view.addSubview(video_View)
        

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LandingViewController{
    
    //MARK: - Custom Functions
    func getCorporateInfo(){
        //AppLoader.shared.show(currentView: self.view)
        let param = ["key":key] as [String:Any]
        API.shared.sendData(url: APIPath.getCorporateInfo, requestType: .get, params: param, objectType: GetCorporateInfo.self) { (data,status)  in
            if status {
                //AppLoader.shared.hide()
                guard let getInfo = data else {return}
                self.getCorporateInfos = getInfo
                self.playVideo(videoUrl: getInfo.onboardingVideo)
            }else{
                //AppLoader.shared.hide()
                print("Error found")
            }
        }
    }
    
    @objc func termsTapOnLbl(_ recognizer: UITapGestureRecognizer) {
        guard let text = lbl_tnc.attributedText?.string else {
            return
        }
        if let range = text.range(of: "Terms of Service"),
            recognizer.didTapAttributedTextInLabel(label: lbl_tnc, inRange: NSRange(range, in: text)) {
            guard let url = URL(string: self.getCorporateInfos?.termsOfService ?? "") else { return }
            UIApplication.shared.open(url)
        } else if let range2 = text.range(of: "Privacy Policy"),
            recognizer.didTapAttributedTextInLabel(label: lbl_tnc, inRange: NSRange(range2, in: text)) {
            guard let url = URL(string: self.getCorporateInfos?.privacyPolicy ?? "") else { return }
            UIApplication.shared.open(url)
        } else if let range3 = text.range(of: "Cookies Policy"),
                  recognizer.didTapAttributedTextInLabel(label: lbl_tnc, inRange: NSRange(range3, in: text)) {
            guard let url = URL(string: self.getCorporateInfos?.cookies ?? "") else { return }
            UIApplication.shared.open(url)
        }
    }
}


extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attrString = label.attributedText else {
            return false
        }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.1 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.1 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
