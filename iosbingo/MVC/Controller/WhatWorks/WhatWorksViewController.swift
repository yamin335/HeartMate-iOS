//
//  WhatWorksViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 19/10/2022.
//

import UIKit
import SDWebImage

class WhatWorksViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!

    var guideData = [CardGuide]()
    var profileModel : ProfileModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        getWorksData()
    }

    //MARK: - Custom Functions

    func getWorksData(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.sendData(url: APIPath.getWhatWorks, requestType: .post, params: nil, objectType: WhatWorksModel.self) { (data,status)  in
            if status {
                guard let whatWorksData = data else {return}
                self.guideData.append(whatWorksData.guides[0].inventoryCard)
                self.guideData.append(whatWorksData.guides[0].invitationsCard)
                self.guideData.append(whatWorksData.guides[0].levelingCard)
                self.guideData.append(whatWorksData.guides[0].experienceCard)
                self.collectionView.reloadData()
                AppLoader.shared.hide()
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    func pushController (controllerName:String) {
        let vc = UIStoryboard(name: "WhatWorks", bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - IBActions

    @IBAction func btnBackAction(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - Collection View Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhatWorksCollectionViewCell", for: indexPath) as! WhatWorksCollectionViewCell
        cell.lblGuideTitle.text = guideData[indexPath.row].headerTitle
        cell.lblGuideDescription.text = guideData[indexPath.row].excerpt
        cell.imgGuide.sd_setImage(with: URL(string: (guideData[indexPath.row].headerImage)), placeholderImage: UIImage(named: "defaultProfile"))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = UIStoryboard(name: "WhatWorks", bundle: Bundle.main).instantiateViewController(withIdentifier: "WhatWorkDetailViewController") as! WhatWorkDetailViewController
            vc.profileModel = profileModel
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1 {
            pushController(controllerName: "WhatWorksInvitationDetailViewController")
        }else if indexPath.row == 2 {
            pushController(controllerName: "WhatWorksExperienceViewController")
        }else{
            pushController(controllerName: "WhatWorksLevelingViewController")
        }

    }

}


extension WhatWorksViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.collectionView.frame.size
        return CGSize(width: ((size.width/2) - 5), height: size.height/1.6)
    }
}
