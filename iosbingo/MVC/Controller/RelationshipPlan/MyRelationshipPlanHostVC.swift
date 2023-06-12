//
//  MyRelationshipPlanHostVC.swift
//  iosbingo
//
//  Created by Md. Yamin on 12/16/22.
//

import UIKit
import SwiftUI

class MyRelationshipPlanHostVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBSegueAction func loadMyRelationshipPlansView(_ coder: NSCoder) -> UIViewController? {
        let vc = UIHostingController(coder: coder, rootView: MyRelationshipPlansView())
        vc?.navigationItem.setHidesBackButton(true, animated: true)
        return vc
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
