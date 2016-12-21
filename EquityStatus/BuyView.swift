//
//  BuyView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit
import Charts


class BuyView: UIView, ChartViewDelegate {
    
    let barChartView = HorizontalBarChartView()
    let subTitle: UILabel = UILabel()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.barChartView.delegate = self
        self.pageLayout()
        self.updateChartWithData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageLayout() {
        // layout
        self.addSubview(self.subTitle)
        self.subTitle.translatesAutoresizingMaskIntoConstraints = false
        self.subTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
        self.subTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.subTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        self.subTitle.text = "Expected returns for approved equities."
        self.subTitle.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        self.addSubview(self.barChartView)
        self.barChartView.translatesAutoresizingMaskIntoConstraints = false
        self.barChartView.topAnchor.constraint(equalTo: self.subTitle.bottomAnchor, constant: 6).isActive = true
        self.barChartView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
        self.barChartView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6).isActive = true
        self.barChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -46).isActive = true
        
        self.layoutIfNeeded()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("\(entry.description)")
    }
    
    func updateChartWithData() {
        
        let stringFormatter = ChartStringFormatter()              // allow labels to be shown for bars
        var dataEntries: [BarChartDataEntry] = []
        
        // data and names of the bars
        let dataPoints: [Double] = [12, 13.1, 14, 12.6, 13.2]
        stringFormatter.nameValues = ["CEC", "AA", "ORCL", "F", "APPL"]
        
        // formatting, the horizontal bar chart is rotated so the axis labels are odd
        barChartView.xAxis.valueFormatter = stringFormatter       // allow labels to be shown for bars
        barChartView.xAxis.drawGridLinesEnabled = false     // hide horizontal grid lines
        barChartView.xAxis.drawAxisLineEnabled = false      // hide right axis
        barChartView.xAxis.labelFont = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.medium.rawValue)!
        barChartView.xAxis.setLabelCount(stringFormatter.nameValues.count, force: false)
        
        barChartView.rightAxis.enabled = false              // hide values on bottom axis
        barChartView.leftAxis.enabled = false               // hide values on top axis
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
        barChartView.legend.enabled = false
        barChartView.chartDescription?.enabled = false

        barChartView.leftAxis.axisMinimum = 0.0             // required to show values on the bars, its a bug
        barChartView.leftAxis.axisMaximum = 16.0
        
        for (index, dataPoint) in dataPoints.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: dataPoint)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = [UIColor.brown]
        
        chartDataSet.valueFont = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)!
        chartDataSet.valueTextColor = UIColor(named: UIColor.ColorName.white)
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.drawValueAboveBarEnabled = false       // places values inside the bars

        self.barChartView.data = chartData
    }
}
