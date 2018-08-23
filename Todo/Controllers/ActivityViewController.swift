//
//  ActivityViewController.swift
//  Todo
//
//  Created by Julie Wang on 2018-08-23.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import UIKit
import Charts
import ChameleonFramework

class ActivityViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    
    var unitsSold: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // for testing purposes, generate random data
        for _ in 0..<24 {
            unitsSold.append(Double(arc4random_uniform(10)))
        }
        
        setChart(xNumber: 24, values: unitsSold)
        
        barChartView.highlightPerTapEnabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        barChartView.chartDescription?.text = ""
    }
    
    func setChart(xNumber: Int, values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<xNumber {
            let dataEntry = BarChartDataEntry(x: Double(i), y: unitsSold[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Items Done")
        chartDataSet.colors = [FlatNavyBlue()]
        let chartData = BarChartData(dataSets: [chartDataSet])
        barChartView.data = chartData
//        barChartView.animate(xAxisDuration: 2.0, yAxisDuration:1.0, easingOption: .linear)
    }
}
