//
//  PrimerXViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 05/09/2022.
//

import UIKit

class PrimerXViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Button Actions

    @IBAction func btnActionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}


