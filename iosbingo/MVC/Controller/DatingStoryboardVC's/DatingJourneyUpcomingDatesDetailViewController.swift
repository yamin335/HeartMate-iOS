//
//  DatingJourneyUpcomingDatesDetailViewController.swift
//  iosbingo
//
//  Created by mac on 30/09/22.
//

import UIKit

class DatingJourneyUpcomingDatesDetailViewController: UIViewController {

    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var view_poUpCancelReason: UIView!
    @IBOutlet weak var view_popUpReschedule: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.table_view.separatorStyle = .none
        self.table_view.register(DatingJourneyUpcomingDatesDetailImageTableViewCell.nib, forCellReuseIdentifier: DatingJourneyUpcomingDatesDetailImageTableViewCell.identifier)
        self.table_view.register(DatingJourneyUpcomingDatesDetailTableViewCell.nib, forCellReuseIdentifier: DatingJourneyUpcomingDatesDetailTableViewCell.identifier)
     
        self.view_poUpCancelReason.isHidden = true
        self.view_popUpReschedule.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view_poUpCancelReason.addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view_popUpReschedule.addGestureRecognizer(tap1)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view_poUpCancelReason.isHidden = true
        self.view_popUpReschedule.isHidden = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view_poUpCancelReason.isHidden = true
        self.view_popUpReschedule.isHidden = true
    }
    @objc func buttonCrossClick(sender: UIButton!) {
        self.view_poUpCancelReason.isHidden = false
    }
    
    @objc func buttonRescheduleClick(sender: UIButton!) {
        self.view_popUpReschedule.isHidden = false
    }
   
    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func btn_cross(_ sender: Any) {
        self.view_poUpCancelReason.isHidden = true
    }
}
extension DatingJourneyUpcomingDatesDetailViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            let cell = table_view.dequeueReusableCell(withIdentifier: DatingJourneyUpcomingDatesDetailImageTableViewCell.identifier) as! DatingJourneyUpcomingDatesDetailImageTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = table_view.dequeueReusableCell(withIdentifier: DatingJourneyUpcomingDatesDetailTableViewCell.identifier) as! DatingJourneyUpcomingDatesDetailTableViewCell
            cell.btn_cancel.addTarget(self, action: #selector(buttonCrossClick), for: .touchUpInside)
            cell.btn_reschedule.addTarget(self, action: #selector(buttonRescheduleClick), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        
       
    }
    
}

