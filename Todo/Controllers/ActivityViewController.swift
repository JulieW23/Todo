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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
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
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        barChartView.chartDescription?.text = ""
        barChartView.leftAxis.spaceBottom = 0.0
    }
    
    // loads data for the selected segment
    private func checkSelectedSegment() {
        var labels: [String] = []
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.loadStats(for: .day)
            titleLabel.text = "Items done today:"
            labels = ["12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
            averageLabel.text = "AVERAGE: \(round(100 * viewModel.itemsDone.reduce(0, {x, y in x  + y}) / 24) / 100) / hour"
        case 1:
            viewModel.loadStats(for: .week)
            titleLabel.text = "Items done this week:"
            labels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            averageLabel.text = "AVERAGE: \(round(100 * viewModel.itemsDone.reduce(0, {x, y in x  + y}) / 7) / 100) / day"
        case 2:
            titleLabel.text = "Items done this month:"
            viewModel.loadStats(for: .month)
            // get number of days in the current month to fill graph labels
            let now = Date()
            let calendar = NSCalendar.current
            if let range = calendar.range(of: .day, in: .month, for: now) {
                for i in 1..<range.upperBound {
                    labels.append(String(i))
                }
                averageLabel.text = "AVERAGE: \(round(100 * viewModel.itemsDone.reduce(0, {x, y in x  + y}) / Double(range.upperBound - 1)) / 100) / day"
            }
        case 3:
            titleLabel.text = "Items done this year:"
            viewModel.loadStats(for: .year)
            labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            averageLabel.text = "AVERAGE: \(round(100 * viewModel.itemsDone.reduce(0, {x, y in x  + y}) / 12) / 100) / month"
        default: break
        }
        totalLabel.text = "TOTAL: \(viewModel.itemsDone.reduce(0, {x, y in x + y}))"
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
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
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        chartDataSet.colors = [FlatNavyBlue()]
        let chartData = BarChartData(dataSets: [chartDataSet])
        barChartView.data = chartData
    }
}
