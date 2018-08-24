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
    
    private let viewModel: ActivityViewModel = ActivityViewModel()

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func handleSegmentChange(_ sender: Any) {
        checkSelectedSegment()
        setChart(values: viewModel.itemsDone)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkSelectedSegment()
        setChart(values: viewModel.itemsDone)
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        navBar.tintColor = UIColor.white
        barChartSetup()
    }
    
    
    // styling
    private func barChartSetup() {
        barChartView.highlightPerTapEnabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        barChartView.chartDescription?.text = ""
    }
    
    // loads data for the selected segment
    private func checkSelectedSegment() {
        switch segmentedControl.selectedSegmentIndex {
        case 0: viewModel.loadStats(for: .day)
        case 1: viewModel.loadStats(for: .week)
        case 2: viewModel.loadStats(for: .month)
        case 3: viewModel.loadStats(for: .year)
        default: break
        }
        barChartView.data?.notifyDataChanged()
        barChartView.notifyDataSetChanged()
    }
    
    // display data in chart
    private func setChart(values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: viewModel.itemsDone[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Items Done")
        chartDataSet.colors = [FlatNavyBlue()]
        let chartData = BarChartData(dataSets: [chartDataSet])
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration:1.0, easingOption: .linear)
    }
}
