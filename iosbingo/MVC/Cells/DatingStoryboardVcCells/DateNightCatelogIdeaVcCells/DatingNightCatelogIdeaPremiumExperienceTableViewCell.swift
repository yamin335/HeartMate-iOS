//
//  DatingNightCatelogIdeaPremiumExperienceTableViewCell.swift
//  iosbingo
//
//  Created by mac on 29/09/22.
//

import UIKit

class DatingNightCatelogIdeaPremiumExperienceTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func setData(){
        collectionView.register(DatingNightCatelogIdeaPremiumExperienceCollectionViewCell.nib, forCellWithReuseIdentifier: DatingNightCatelogIdeaPremiumExperienceCollectionViewCell.identifier)
        collectionView.reloadData()
    }
    
}

extension DatingNightCatelogIdeaPremiumExperienceTableViewCell :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 154)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatingNightCatelogIdeaPremiumExperienceCollectionViewCell.identifier, for: indexPath) as! DatingNightCatelogIdeaPremiumExperienceCollectionViewCell
        return cell
         
    }

}
