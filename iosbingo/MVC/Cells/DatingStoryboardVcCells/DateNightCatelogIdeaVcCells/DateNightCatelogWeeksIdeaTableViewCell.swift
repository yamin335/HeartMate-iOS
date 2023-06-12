//
//  DateNightCatelogWeeksIdeaTableViewCell.swift
//  iosbingo
//
//  Created by mac on 29/09/22.
//

import UIKit

class DateNightCatelogWeeksIdeaTableViewCell: UITableViewCell {

    @IBOutlet weak var collection_view: UICollectionView!
    
    var safeDateNightCatalog : [DateElements]?
    
    var routeAction : ((_ sender : Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func setData(dateNightCatalog: [DateElements]){
        safeDateNightCatalog = dateNightCatalog
        collection_view.register(DateNightCatelogWeeksIdeaCollectionViewCell.nib, forCellWithReuseIdentifier: DateNightCatelogWeeksIdeaCollectionViewCell.identifier)
        collection_view.reloadData()
    }
    
}

extension DateNightCatelogWeeksIdeaTableViewCell :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return safeDateNightCatalog?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection_view.dequeueReusableCell(withReuseIdentifier: DateNightCatelogWeeksIdeaCollectionViewCell.identifier, for: indexPath) as! DateNightCatelogWeeksIdeaCollectionViewCell
        cell.img_background.sd_setImage(with: URL(string: (safeDateNightCatalog?[indexPath.item].imageURL) ?? ""), placeholderImage: UIImage(named: ""))
        cell.lbl_title.text = safeDateNightCatalog?[indexPath.item].title
        cell.lbl_subTitle.text = safeDateNightCatalog?[indexPath.item].topics.joined(separator: ", ")
        cell.lbl_date.text = "\(safeDateNightCatalog?[indexPath.item].totalAspects ?? 0) aspects of me"
        cell.btn_route.tag = indexPath.item
        //cell.btn_route.addTarget(self, action: #selector(btnRouteClicked), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.routeAction?(indexPath.item)
    }
    
    @objc func btnRouteClicked(sender: UIButton){
        //self.routeAction?(sender)
    }

}
