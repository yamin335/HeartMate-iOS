//
//  DefaultProfileCollectionViewCell.swift
//  iosbingo
//
//  Created by Hamza Saeed on 02/09/2022.
//

import UIKit

protocol WhatWorks{
    func onPress()
}
class DefaultProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    var delegate : WhatWorks?

    @IBAction func btnToggleAction(_ sender: UIButton) {
        delegate?.onPress()
    }
}
