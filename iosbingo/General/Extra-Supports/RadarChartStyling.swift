//
//  RadarChartStyling.swift
//  iosbingo
//
//  Created by Hamza Saeed on 30/08/2022.
//

import Charts

class DataSetValueFormatter: ValueFormatter {

    func stringForValue(_ value: Double,
        entry: ChartDataEntry,
        dataSetIndex: Int,
        viewPortHandler: ViewPortHandler?) -> String {
        ""
    }
}

class XAxisFormatter: NSObject,AxisValueFormatter {

    var labels: [String] = []

       func stringForValue(_ value: Double, axis: AxisBase?) -> String {
           if Int(value) < labels.count {
               return labels[Int(value)]
           }else{
               return String("")
           }
       }

       init(labels: [String]) {
           super.init()
           self.labels = labels
   }
}

class YAxisFormatter: AxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        "\(Int(value)) $"
    }
}
