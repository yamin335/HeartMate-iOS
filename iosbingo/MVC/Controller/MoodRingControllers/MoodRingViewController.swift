//
//  MoodRingViewController.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 10/13/22.
//

import UIKit
import Foundation
import SwiftUI

class MoodRingViewController: UIViewController {

    var id = 0
    var isCameFromNotification = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//      //  let backItem = UIBarButtonItem()
//        backItem.title = "Something Else"
//        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
//    }
//
    @IBSegueAction func prepareMyMoodRingView(_ coder: NSCoder) -> UIViewController? {

        if isCameFromNotification {
            let vc = UIHostingController(coder: coder, rootView: MyMoodRingView(existingMoodRingID: 24))
            vc?.navigationItem.setHidesBackButton(true, animated: true)
            return vc
        }else{
            let vc = UIHostingController(coder: coder, rootView: MyMoodRingView(existingMoodRingID: 0))
            vc?.navigationItem.setHidesBackButton(true, animated: true)
            return vc
        }
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
