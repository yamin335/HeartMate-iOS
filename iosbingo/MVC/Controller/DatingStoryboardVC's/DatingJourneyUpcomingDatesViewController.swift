//
//  DatingJourneyUpcomingDatesViewController.swift
//  iosbingo
//
//  Created by mac on 30/09/22.
//

import UIKit

class DatingJourneyUpcomingDatesViewController: UIViewController {

    @IBOutlet weak var table_view: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.table_view.separatorStyle = .none
        self.table_view.register(DatingJourneyUpcomingDatesTableViewCell.nib, forCellReuseIdentifier: DatingJourneyUpcomingDatesTableViewCell.identifier)
        
       
    }
   
    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
       
    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName) as! DatingJourneyUpcomingDatesDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
        
}
extension DatingJourneyUpcomingDatesViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table_view.dequeueReusableCell(withIdentifier: DatingJourneyUpcomingDatesTableViewCell.identifier) as! DatingJourneyUpcomingDatesTableViewCell
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushController(controllerName: "DatingJourneyUpcomingDatesDetailViewController", storyboardName: "Dating")
    }
    
}
