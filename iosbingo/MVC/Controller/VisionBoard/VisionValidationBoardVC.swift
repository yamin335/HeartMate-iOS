//
//  VisionValidationBoardVC.swift
//  iosbingo
//
//  Created by Hamza Saeed on 13/12/2022.
//

import UIKit

class VisionValidationBoardVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    @IBOutlet weak var lblThird: UILabel!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var firstBullet: UIView!
    @IBOutlet weak var secondBullet: UIView!
    @IBOutlet weak var thirdBullet: UIView!

    var tapTitle = ""
    var firstLbl = ""
    var secondLabel = ""
    var thirdLabed = ""
    var colorCode = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    //MARK: - Custom Functions

    func updateUI(){
        lblTitle.text = tapTitle
        lblFirst.text = firstLbl
        lblSecond.text = secondLabel
        lblThird.text = thirdLabed
        tapView.backgroundColor = UIColor(hexString: colorCode)

        if firstLbl == ""{
            firstBullet.isHidden = true
        }
        if secondLabel == ""{
            secondBullet.isHidden = true
        }
        if thirdLabed == ""{
            thirdBullet.isHidden = true
        }
    }

    //MARK: - Button Actions

    @IBAction func btnActonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }



}
