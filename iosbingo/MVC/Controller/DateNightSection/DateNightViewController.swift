//
//  DateNightViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 29/08/2022.
//

import UIKit

class DateNightViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var btnPossibilites: UIButton!
    @IBOutlet weak var btnDateNight: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCounting: UILabel!

    var dateNightModel : GetDateNightModel!
    var isDateNightListActive = true

    override func viewDidLoad() {
        super.viewDidLoad()

        if isPremium {
            helpView.isHidden = true
        }
        self.tabBarController?.tabBar.isHidden = true
        btnDateNight.backgroundColor = #colorLiteral(red: 0.8456994891, green: 0.9093562961, blue: 0.9628029466, alpha: 1)
        btnPossibilites.backgroundColor = #colorLiteral(red: 0.784393847, green: 0.7843937278, blue: 0.7843937278, alpha: 1)
        self.tableView.rowHeight = UITableView.automaticDimension
        getDateNightApi()
    }

    //MARK: - Custom Fuctions

    func getDateNightApi(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                API.shared.sendData(url: APIPath.getDateNight, requestType: .post, params: nil, objectType: GetDateNightModel.self) { (data,status)  in
                    if status {
                        guard let dateNight = data else {return}
                        self.dateNightModel = dateNight
                        self.tableView.reloadData()
                        self.lblTitle.text = self.dateNightModel?.facetDescription
                        self.lblCounting.text = String(self.dateNightModel?.totalPeronalityFacets ?? 0)
                        AppLoader.shared.hide()
                    }else{
                        AppLoader.shared.hide()
                        print("Error found")
                    }
                }
            }else{
                AppLoader.shared.hideWithHandler(completion: { isDone in
                    if isDone{
                        removeUserPreference()
                        navigatetoLoginScreen()
                    }
                })
            }
        }
    }

    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: - IBActions

    @IBAction func btnActionLearnMore(_ sender: UIButton) {
        pushController(controllerName: "MembershipController", storyboardName: "Main")
    }

    @IBAction func btnActionBack(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActionDateNight(_ sender: UIButton) {
        btnDateNight.backgroundColor = #colorLiteral(red: 0.8456994891, green: 0.9093562961, blue: 0.9628029466, alpha: 1)
        btnPossibilites.backgroundColor = #colorLiteral(red: 0.784393847, green: 0.7843937278, blue: 0.7843937278, alpha: 1)
        isDateNightListActive = true
        if dateNightModel?.ideasTab?.count ?? 0 > 0 {
            let topIndex = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: topIndex, at: .top, animated: true)
        }
        tableView.reloadData()
    }

    @IBAction func btnActionPossibilities(_ sender: UIButton) {
        btnPossibilites.backgroundColor = #colorLiteral(red: 0.8456994891, green: 0.9093562961, blue: 0.9628029466, alpha: 1)
        btnDateNight.backgroundColor = #colorLiteral(red: 0.784393847, green: 0.7843937278, blue: 0.7843937278, alpha: 1)
        isDateNightListActive = false
        if dateNightModel?.possibilitiesTab?.count ?? 0 > 0 {
            let topIndex = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: topIndex, at: .top, animated: true)
        }
        tableView.reloadData()
    }

    //MARK: - TableView Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDateNightListActive {
            return dateNightModel?.ideasTab?.count ?? 0
        }else{
            return dateNightModel?.possibilitiesTab?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateNightTableViewCell") as! DateNightTableViewCell
        if isDateNightListActive {
            cell.lbldateNightDetail.attributedText = dateNightModel?.ideasTab?[indexPath.row].convertToAttributedString()
            self.tableView.backgroundColor = .white
        }else{
            cell.lbldateNightDetail.attributedText = dateNightModel?.possibilitiesTab?[indexPath.row].convertToAttributedString()
            self.tableView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.9176470588, blue: 0.8274509804, alpha: 1)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
