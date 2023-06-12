//
//  UpdateValueInventoryViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 02/09/2022.
//

import UIKit

class UpdateValueInventoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    var profileModel : ProfileModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Button Actions

    @IBAction func btnActionBack(_ sender: Any) {
        Unity.shared.loadUnityFromProfile(fromVC: self)
    }

    @IBAction func btnActionWhyIsThisImportant(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrimerXViewController") as! PrimerXViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: - TableView Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileModel.inventoryCategories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateValueInventoryTableCell") as! UpdateValueInventoryTableCell
        cell.lblInventory.text = profileModel.inventoryCategories[indexPath.row].category
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        AppUserDefault.shared.selectedCategoryIndex  = indexPath.row
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ValueMeInventoryVC") as! ValueMeInventoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
