//
//  LoveController.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 3/9/22.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    var UIState: UIStateModel = UIStateModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIState.onHeartAction = { (journey) in //<-- Get Heart Button Action
            if journey.ourStatus?.level?.lowercased() == "level 1" {
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Level2DatingJourneySubscriptionVC") as! Level2DatingJourneySubscriptionVC
                vc.journey = journey
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateLevel2InvitationViewController") as! CreateLevel2InvitationViewController
                vc.journey = journey
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }

        UIState.onDatingJournal = { (journey) in //<-- Get Dating Journal Action
            let vc = UIStoryboard(name: "DatingJourney", bundle: Bundle.main).instantiateViewController(withIdentifier: "DatingJournalViewController") as! DatingJournalViewController
            vc.journey = journey
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        UIState.onInvitationAction = { (journey) in//<-- Get Invitation Button Action
            let vc = UIStoryboard(name: "Dating", bundle: Bundle.main).instantiateViewController(withIdentifier: "DateNightCatelogCoverViewController") as! DateNightCatelogCoverViewController
            vc.from = "Partner"
            vc.groupId = journey.groupId ?? 0
            vc.partnerUserId = journey.dating_partner_id ?? 0
            vc.firstName = journey.first_name ?? ""
            vc.tvm = journey.value_me_score ?? 0
            //vc.selectedJourneys = self.selectedJourneys
            //vc.dateNightCatelogData = self.dateNightCatelogData
            self.navigationController?.pushViewController(vc, animated: true)
            
//            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Level1GuidanceViewController") as! Level1GuidanceViewController
//            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    @IBSegueAction func LoveViewSwiftUI(_ coder: NSCoder) -> UIViewController? {
        let hostingController = UIHostingController(coder: coder, rootView: SnapCarousel(UIState: UIState))
        hostingController?.rootView.present = { selectedJourneys in
            let destination = UIStoryboard(name: "Dating", bundle: nil).instantiateViewController(identifier: "DateNightCatelogCoverViewController") as! DateNightCatelogCoverViewController
            destination.selectedJourneys = selectedJourneys
            self.navigationController?.pushViewController(destination, animated: true)
        }
        return hostingController
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

