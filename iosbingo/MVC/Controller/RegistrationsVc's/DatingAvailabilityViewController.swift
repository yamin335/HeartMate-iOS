//
//  DatingAvailabilityViewController.swift
//  iosbingo
//
//  Created by apple on 30/08/22.
//

import UIKit

class DatingAvailabilityViewController: UIViewController {

    @IBOutlet weak var table_view: UITableView!
    
    var days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday","I’m available \n7 days-a-week"]
    var arrDays : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.table_view.separatorStyle = .none
        self.table_view.register(DatingAvailabilityTableViewCell.nib, forCellReuseIdentifier: DatingAvailabilityTableViewCell.identifier)
        
    }
    
    @IBAction func btn_next(_ sender: Any) {
        updateAvailability()
    }
    
    func updateAvailability(){
        var values = ""
        for i in 0..<days.count - 1{
            if arrDays.contains(days[i]){
                if (values.count > 0){
                    values.append(",")
                }
                if(i == 3){
                    values.append("R")
                }else if(i == 6){
                    values.append("Su")
                }else{
                    let value = days[i].first?.description ?? ""
                    values.append(value)
                }
            }
        }
        let params = ["dating_availability": values] as [String:Any]
        API.shared.sendData(url: APIPath.updateUserMetaVar, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
            if status {
                AppUserDefault.shared.set(value: 1, for: .IsLoggedIn)
                AppLoader.shared.hideWithHandler { isComplete in
                    if isComplete {
                        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrimerThreeVC") as!
                        PrimerThreeVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }
}

extension DatingAvailabilityViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: DatingAvailabilityTableViewCell.identifier) as! DatingAvailabilityTableViewCell
        cell.selectionStyle = .none
        cell.lbl_days.text = days[indexPath.row]
        cell.btn_checkUncheck.tag = indexPath.row
        
        if arrDays.contains(days[indexPath.row]){
            cell.btn_checkUncheck.setImage(UIImage(named: "checked-1"), for: .normal)
        }else{
            cell.btn_checkUncheck.setImage(UIImage(named: "emptyCheckBox"), for: .normal)
        }
        
        if arrDays.count == 7{
            cell.btn_checkUncheck.isSelected = true
            cell.btn_checkUncheck.setImage(UIImage(named: "checked-1"), for: .normal)
        }else{
            cell.btn_checkUncheck.isSelected = false
            cell.btn_checkUncheck.setImage(UIImage(named: "emptyCheckBox"), for: .normal)
        }
        
        cell.btnAvailabilityAction = { index, sender in
            if(index == 7){
                if(sender.isSelected){
                    self.arrDays = []
                    self.table_view.reloadData()
                }else{
                    for i in 0..<self.days.count - 1{
                        if !self.arrDays.contains(self.days[i]){
                            self.arrDays.append(self.days[i])
                        }
                    }
                    sender.setImage(UIImage(named: "checked-1"), for: .normal)
                    self.table_view.reloadData()
                }
            }else{
                if self.arrDays.contains(self.days[index]){
                    sender.isSelected = false
                    let index = self.arrDays.firstIndex{$0 == self.days[index]}!
                    self.arrDays.remove(at: index)
                    sender.setImage(UIImage(named: "emptyCheckBox"), for: .normal)
                    //print(print(self.arrDays))
                }else{
                    sender.isSelected = true
                    self.arrDays.append(self.days[index])
                    sender.setImage(UIImage(named: "checked-1"), for: .normal)
                    //print(arrDays)
                }
            }
        }
        
        return cell
        
    }
    
}
