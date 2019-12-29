//
//  OwnView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/28/19.
//  Copyright © 2019 Paul Tangen. All rights reserved.
//

import UIKit
import Charts

protocol OwnViewDelegate: class {
    func openCompanyDetail(company: Company)
}

class OwnView: UIView, ChartViewDelegate {
    
    let store = DataStore.sharedInstance
    weak var delegate: OwnViewDelegate?
    let barChartView = HorizontalBarChartView()
    let countLabel = UILabel()
    let companiesLabel = UILabel()
    let pageDescLabel = UILabel()
    
    //var equitiesForBuyTickers = [String]()
    
    var companiesToBuyExpectedROI = [Double]()
    var companiesToBuyTickers = [String]()
    var companiesToBuyNames = [String]()
    
    let activityIndicator = UIView()
    var chartHeight = CGFloat()
    let barHeight:Int = 60
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.barChartView.delegate = self
        self.accessibilityLabel = "buyView"
        self.barChartView.accessibilityLabel = "barChartView"
        self.pageLayoutLabels()
        self.updateCompaniesOwned()
        
        // if data is available, update the display
        if self.store.companies.count > 0 {
            self.setHeadingLabels()
            self.pageLayoutWithData()
        }
    }
    
    func setHeadingLabels() {
        self.companiesToBuyExpectedROI.count > 0 ? (self.pageDescLabel.text = "These are the companies with stock we have purchased.") : (self.pageDescLabel.text = "Mark the companies with stock that has been pu")
        self.countLabel.text = "\(self.companiesToBuyExpectedROI.count)"
        self.companiesToBuyExpectedROI.count == 1 ? (self.companiesLabel.text = "company") : (self.companiesLabel.text = "companies")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pageLayoutLabels() {
        self.addSubview(self.countLabel)
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.countLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 110).isActive = true
        self.countLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.countLabel.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -45).isActive = true
        self.countLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xxlarge.rawValue)
        self.countLabel.textAlignment = .right
    
        self.addSubview(self.companiesLabel)
        self.companiesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.companiesLabel.topAnchor.constraint(equalTo: self.countLabel.bottomAnchor, constant: 0).isActive = true
        self.companiesLabel.leftAnchor.constraint(equalTo: self.countLabel.leftAnchor, constant: 0).isActive = true
        self.companiesLabel.rightAnchor.constraint(equalTo: self.countLabel.rightAnchor, constant: 0).isActive = true
        self.companiesLabel.font = UIFont(name: Constants.appFont.bold.rawValue, size: Constants.fontSize.small.rawValue)
        self.companiesLabel.textAlignment = .right
    
        self.addSubview(self.pageDescLabel)
        self.pageDescLabel.translatesAutoresizingMaskIntoConstraints = false
        self.pageDescLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: -30).isActive = true
        self.pageDescLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.pageDescLabel.bottomAnchor.constraint(equalTo: self.companiesLabel.bottomAnchor, constant: 0).isActive = true
        self.pageDescLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)
        self.pageDescLabel.numberOfLines = 0
    }
    
    func pageLayoutNoData() {
        self.addSubview(self.activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func pageLayoutWithData() {
        self.addSubview(self.barChartView)
        self.barChartView.translatesAutoresizingMaskIntoConstraints = false
        self.barChartView.topAnchor.constraint(equalTo: self.pageDescLabel.bottomAnchor, constant: 24).isActive = true
        self.barChartView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.barChartView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.barChartView.heightAnchor.constraint(equalToConstant: self.chartHeight).isActive = true
        self.updateChartWithData()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let companyClickedArr = self.store.companies.filter({$0.ticker == self.companiesToBuyTickers[Int(entry.x)]})
        if let companyClicked = companyClickedArr.first {
            self.delegate?.openCompanyDetail(company: companyClicked)
        }
    }
    
    // create array for buy view
    func updateCompaniesOwned() {
        self.companiesToBuyExpectedROI.removeAll()
        self.companiesToBuyNames.removeAll()
        self.companiesToBuyTickers.removeAll()
        
        let companiesOwned = self.store.companies.filter({$0.tab == .own})
        
        for company in companiesOwned {
            if let expected_roi = company.expected_roi {
                self.companiesToBuyExpectedROI.append(Double(expected_roi))
            } else {
                self.companiesToBuyExpectedROI.append(0.0)
            }
            self.companiesToBuyNames.append(String(company.name.prefix(18)))
            self.companiesToBuyTickers.append(company.ticker)
        }
        self.companiesToBuyExpectedROI.reverse()
        self.companiesToBuyNames.reverse()
        self.companiesToBuyTickers.reverse()
        
        self.chartHeight = CGFloat(self.companiesToBuyNames.count * self.barHeight)
        let maxChartHeight: CGFloat = UIScreen.main.bounds.height - 260 // subtract for heading and tabs at bottom
        
        if self.chartHeight > maxChartHeight {
            self.chartHeight = maxChartHeight
        }
        
        self.updateChartWithData()
    }
    
    func updateChartWithData() {
        let stringFormatter = ChartStringFormatter()        // allow labels to be shown for bars
        let percentFormatter = PercentValueFormatter()      // allow labels to be shown for bars
        var dataEntries: [BarChartDataEntry] = []
        
        // data and names of the bars
        let dataPoints: [Double] = self.companiesToBuyExpectedROI   // values for the bars
        stringFormatter.nameValues = self.companiesToBuyNames      // labels for the y axis
        
        // formatting, the horizontal bar chart is rotated so the axis labels are odd
        barChartView.xAxis.valueFormatter = stringFormatter // allow labels to be shown for bars
        barChartView.xAxis.drawGridLinesEnabled = false     // hide horizontal grid lines
        barChartView.xAxis.drawAxisLineEnabled = false      // hide right axis
        barChartView.xAxis.labelFont = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)!
        barChartView.xAxis.setLabelCount(stringFormatter.nameValues.count, force: false)
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1.0
        barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        barChartView.rightAxis.enabled = false              // hide values on bottom axis
        barChartView.leftAxis.enabled = false               // hide values on top axis
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 0.6)
        barChartView.legend.enabled = false
        if let chartDescription = barChartView.chartDescription {
            chartDescription.enabled = false
        }
        barChartView.drawValueAboveBarEnabled = false       // places values inside the bars

        barChartView.leftAxis.axisMinimum = 0.0             // required to show values on the horz bars, its a bug
        if let maxBarValue = self.companiesToBuyExpectedROI.max() {
            barChartView.leftAxis.axisMaximum = maxBarValue + 2
        }
        
        for (index, dataPoint) in dataPoints.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: dataPoint)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = [UIColor(named: .statusGreen)]
        chartDataSet.valueFont = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)!
        chartDataSet.valueTextColor = UIColor.white
        chartDataSet.valueFormatter = percentFormatter      // formats the values into a %
        let chartData = BarChartData(dataSet: chartDataSet)

        self.barChartView.data = chartData
    }
    
    func showActivityIndicator(uiView: UIView) {
        self.activityIndicator.backgroundColor = UIColor(named: .blue)
        self.activityIndicator.layer.cornerRadius = 10
        self.activityIndicator.clipsToBounds = true
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.style = UIActivityIndicatorView.Style.whiteLarge
        actInd.center = CGPoint(x: 40, y: 40)
        
        self.activityIndicator.addSubview(actInd)
        actInd.startAnimating()
    }
}

