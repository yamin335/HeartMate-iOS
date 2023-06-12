//
//  PrimerThreeVC.swift
//  iosbingo
//
//  Created by Md. Yamin on 11/19/22.
//

import UIKit
import SwiftUI

enum UnityLoadMode: Int {
  case DEMO_MODE = 0
 case REGISTRATION_MODE = 1
 case Profile_MODE = 2
}


class PrimerThreeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostController = UIHostingController(rootView: PrimerThreeView())
        hostController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChild(hostController)
        self.view.addSubview(hostController.view)
        hostController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            hostController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            hostController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            hostController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    /*
     
     let vc = UIHostingController(coder: coder, rootView: PrimerThreeView())
     return vc
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class ValueMeInventoryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostController = UIHostingController(rootView: ValueMeInventoryView())
        hostController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChild(hostController)
        self.view.addSubview(hostController.view)
        hostController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            hostController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            hostController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            hostController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    /*
     
     let vc = UIHostingController(coder: coder, rootView: PrimerThreeView())
     return vc
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

public class UIButtonActionDelegateForDatingJourney: ObservableObject {
    var onYesButtonAction: (()-> Void)!
    var onNotYetButtonAction: (()-> Void)!
}

class DatingJourneyTutorialViewVC: UIViewController {
    
    let buttonAction: UIButtonActionDelegateForDatingJourney = UIButtonActionDelegateForDatingJourney()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let hostController = UIHostingController(rootView: DatingJourneyTutorialView(buttonActionDelegate: buttonAction))
        hostController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChild(hostController)
        self.view.addSubview(hostController.view)
        hostController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            hostController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            hostController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            hostController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        
        buttonAction.onYesButtonAction = {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Level1GuidanceViewController") as! Level1GuidanceViewController
            //vc.navigationItem.setHidesBackButton(true, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        buttonAction.onNotYetButtonAction = {
            let tabBarController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            //tabBarController.selectedIndex = 3
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if AppUserDefault.shared.getValueBool(for: .isUserRegistering) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    /*
     
     let vc = UIHostingController(coder: coder, rootView: PrimerThreeView())
     return vc
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

