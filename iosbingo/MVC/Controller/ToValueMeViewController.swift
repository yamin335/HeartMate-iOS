//
//  ToValueMeViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 30/08/2022.
//

import UIKit
import Charts
import SwiftUI

class ToValueMeReportViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var radarChatView: RadarChartView!
    @IBOutlet weak var lblTotalPresonality: UILabel!
    @IBOutlet weak var lblSummary1: UILabel!
    @IBOutlet weak var lblSummary2: UILabel!
    @IBOutlet weak var lblSummary3: UILabel!

    var inventoryModel : GetInventoryReportModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if AppUserDefault.shared.getValueBool(for: .isUserRegistering) {
            backButton.setTitle("See My Date Night Ideas", for: .normal)
        } else {
            backButton.setTitle("Back", for: .normal)
        }
        getInventoryData()
    }

    //MARK: - Custom Functions
    func chartStyling(){
        let blueDataSet = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: Double(inventoryModel.entertainment)),
                RadarChartDataEntry(value: Double(inventoryModel.intellectual)),
                RadarChartDataEntry(value: Double(inventoryModel.emotional)),
                RadarChartDataEntry(value: Double(inventoryModel.spiritual)),
                RadarChartDataEntry(value: Double(inventoryModel.village)),
                RadarChartDataEntry(value: Double(inventoryModel.professional)),
                RadarChartDataEntry(value: Double(inventoryModel.aesthetic)),
                RadarChartDataEntry(value: Double(inventoryModel.sexual)),
            ]
        )

        blueDataSet.lineWidth = 2

        let blueColor = UIColor(red: 34/255, green: 151/255, blue: 230/255, alpha: 1)
        let blueFillColor = UIColor(red: 34/255, green: 151/255, blue: 230/255, alpha: 0.6)
        blueDataSet.colors = [blueColor]
        blueDataSet.fillColor = blueFillColor
        blueDataSet.drawFilledEnabled = true
        let data = RadarChartData(dataSets: [blueDataSet])
        blueDataSet.valueFormatter = DataSetValueFormatter()

        // 2
        radarChatView.webLineWidth = 1
        radarChatView.innerWebLineWidth = 1
        radarChatView.webColor = .lightGray
        radarChatView.innerWebColor = .lightGray

        // 3
        let xAxis = radarChatView.xAxis
        xAxis.labelFont = UIFont(name: "Inter-SemiBold", size: 10)!
        xAxis.labelTextColor = #colorLiteral(red: 0.08235294118, green: 0.5882352941, blue: 0.631372549, alpha: 1)
        xAxis.xOffset = 5
        xAxis.yOffset = 5
        let labels = ["Entertainment","Intellectual","Emotional","Spiritual","Village","Professional","Aesthetic","Sexual"]
        xAxis.valueFormatter = XAxisFormatter(labels: labels)

        // 4
        let yAxis = radarChatView.yAxis
        yAxis.labelFont = UIFont(name: "Inter-SemiBold", size: 15)!
        yAxis.labelCount = 4
        yAxis.drawTopYLabelEntryEnabled = true
        yAxis.axisMinimum = 0
        yAxis.drawLabelsEnabled = false
        yAxis.valueFormatter = YAxisFormatter()

        // 5
        radarChatView.rotationEnabled = false
        radarChatView.legend.enabled = false

        radarChatView.data = data
    }

    func getInventoryData(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let cache = randomString(length: 32)
                let params = [ "cache":cache] as [String:Any]
                
                API.shared.sendData(url: APIPath.getInventoryReportModel, requestType: .post, params: params, objectType: GetInventoryReportModel.self) { (data,status)  in
                    if status {
                        guard let inventory = data else {return}
                        self.inventoryModel = inventory
                        self.updateUI()
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

    func updateUI(){
        
        AppUserDefault.shared.set(value: inventoryModel.totalPeronalityFacets, for: .aspectsOfMyLife)
        AppUserDefault.shared.set(value: "as of " + inventoryModel.inventory_last_updated, for: .inventoryLastUpdated)
        
        lblTotalPresonality.text = String(inventoryModel.totalPeronalityFacets)
        if inventoryModel.summary.isEmpty {
            return
        }
        lblSummary1.attributedText = inventoryModel.summary[0].convertToAttributedString()
        lblSummary2.attributedText = inventoryModel.summary[1].convertToAttributedString()
        lblSummary3.attributedText = inventoryModel.summary[2].convertToAttributedString()
        chartStyling()
    }

    //MARK: - IBActions

    @IBAction func btnActionBack(_ sender: UIButton) {
        if AppUserDefault.shared.getValueBool(for: .isUserRegistering) {
            let destination = UIStoryboard(name: "Dating", bundle: nil).instantiateViewController(identifier: "DateNightCatelogCoverViewController") as! DateNightCatelogCoverViewController
            //destination.selectedJourneys = selectedJourneys
            self.navigationController?.pushViewController(destination, animated: true)
        } else {
            Unity.shared.loadUnityFromProfile(fromVC: self)
        }
    }

}


struct ToValueMeReportViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = ToValueMeReportViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<ToValueMeReportViewControllerWrapper>) -> ToValueMeReportViewControllerWrapper.UIViewControllerType {

        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ToValueMeReportViewController") as! ToValueMeReportViewController
        return vc

    }

    func updateUIViewController(_ uiViewController: ToValueMeReportViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<ToValueMeReportViewControllerWrapper>) {
        //
    }
}
