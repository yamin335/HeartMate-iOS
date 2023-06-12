//
//  DatingPartnerStatisticsViewController.swift
//  iosbingo
//
//  Created by mac on 30/09/22.
//

import UIKit

class DatingPartnerStatisticsViewController: UIViewController {

    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var view_popUpAddNewEntry: UIView!
    
    var selectedSection = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *){
            self.table_view.sectionHeaderTopPadding = 0.0
        }
        self.table_view.separatorStyle = .none
        self.table_view.register(DatingPartnerStatisticsHeader.nib, forHeaderFooterViewReuseIdentifier: DatingPartnerStatisticsHeader.identifier)
        self.table_view.register(DatingPartnerStatisticsTableViewCell.nib, forCellReuseIdentifier: DatingPartnerStatisticsTableViewCell.identifier)

        self.view_popUpAddNewEntry.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view_popUpAddNewEntry.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view_popUpAddNewEntry.isHidden = true
    }

    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_dates(_ sender: Any) {
    }
    
    @IBAction func btn_observations(_ sender: Any) {
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view_popUpAddNewEntry.isHidden = true
    }
    
    @objc func buttonHeaderAction(sender: UIButton!) {
        self.selectedSection = sender.tag
        self.table_view.reloadData()
    }
    @objc func buttonPlusClick(sender: UIButton!) {
        self.view_popUpAddNewEntry.isHidden = false
    }
}

extension DatingPartnerStatisticsViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView  = tableView.dequeueReusableHeaderFooterView(withIdentifier: DatingPartnerStatisticsHeader.identifier) as! DatingPartnerStatisticsHeader
        headerView.btn_click.tag = section
        headerView.btn_click.addTarget(self, action: #selector(buttonHeaderAction), for: .touchUpInside)
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == self.selectedSection){
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table_view.dequeueReusableCell(withIdentifier: DatingPartnerStatisticsTableViewCell.identifier) as! DatingPartnerStatisticsTableViewCell
        cell.selectionStyle = .none
        cell.btn_plus.addTarget(self, action: #selector(buttonPlusClick), for: .touchUpInside)
        return cell
    }
    
}
