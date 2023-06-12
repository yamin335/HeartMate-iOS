//
//  ObservationsCell.swift
//  iosbingo
//
//  Created by Mac mac on 09/12/22.
//

import UIKit

class ObservationsCell: UITableViewCell {
	
	@IBOutlet weak var detailsStackView: UIStackView!
	@IBOutlet weak var detailsView: UIView!
	@IBOutlet weak var detailviewTitleLabel: UILabel!
	@IBOutlet weak var detailViewDescriptionLabel: UILabel!
	@IBOutlet weak var reviewMyObservationButton: UIButton!
	@IBOutlet weak var detailViewAddButton: UIButton!
	
    //    MARK: - Properties
	var ShowHidebuttonClicked: (() -> Void)?
	var ReviewObservationbuttonClicked: (() -> Void)?
	var AddbuttonClicked: (() -> Void)?

	override func awakeFromNib() {
        super.awakeFromNib()
    }
	
}
