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
    let scrollView = UIScrollView()
    var heightOfScrolledContent = CGFloat()
    let barChartView = HorizontalBarChartView()
    let countLabel = UILabel()
    let companiesLabel = UILabel()
    let pageDescLabel = UILabel()
    
    var companiesExpectedROI = [Double]()
    var companiesPreviousROI = [Double]()
    var companiesTickers = [String]()
    var companiesNames = [String]()
    
    let activityIndicator = UIView()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.accessibilityLabel = "buyView"
        
        self.setHeadingLabels()
                
        self.barChartView.delegate = self
        self.barChartView.accessibilityLabel = "barChartView"
        
        self.pageLayoutLabels()
        self.updateCompanyData(selectedTab: .own) // must init chart even though there is no data yet
    }
    
    func setHeadingLabels() {
        self.companiesExpectedROI.count > 0 ? (self.pageDescLabel.text = "These are the companies with stock we have purchased.\r\rThe previous and expected returns are displayed.") : (self.pageDescLabel.text = "Mark the companies with stock that has been pu")
        self.countLabel.text = "\(self.companiesExpectedROI.count)"
        self.companiesExpectedROI.count == 1 ? (self.companiesLabel.text = "company") : (self.companiesLabel.text = "companies")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pageLayoutLabels() {
        self.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.scrollView.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        self.scrollView.contentSize = CGSize(width: self.bounds.width, height: 200) // height is reset below
        
        self.scrollView.addSubview(self.countLabel)
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.countLabel.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 46).isActive = true
        self.countLabel.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 0).isActive = true
        self.countLabel.rightAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant: -45).isActive = true
        self.countLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xxlarge.rawValue)
        self.countLabel.textAlignment = .right
    
        self.scrollView.addSubview(self.companiesLabel)
        self.companiesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.companiesLabel.topAnchor.constraint(equalTo: self.countLabel.bottomAnchor, constant: 0).isActive = true
        self.companiesLabel.leftAnchor.constraint(equalTo: self.countLabel.leftAnchor, constant: 0).isActive = true
        self.companiesLabel.rightAnchor.constraint(equalTo: self.countLabel.rightAnchor, constant: 0).isActive = true
        self.companiesLabel.font = UIFont(name: Constants.appFont.bold.rawValue, size: Constants.fontSize.small.rawValue)
        self.companiesLabel.textAlignment = .right
    
        self.scrollView.addSubview(self.pageDescLabel)
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
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let companyClickedArr = self.store.companies.filter({$0.ticker == self.companiesTickers[Int(entry.x)]})
        if let companyClicked = companyClickedArr.first {
            self.delegate?.openCompanyDetail(company: companyClicked)
        }
    }
    
    // create array for view, same function in own and buy views
    func updateCompanyData(selectedTab: Constants.EquityTabValue) {
        self.companiesExpectedROI.removeAll()
        self.companiesNames.removeAll()
        self.companiesTickers.removeAll()
        
        let companies = self.store.companies.filter({$0.tab == selectedTab})
        
        for company in companies {
            if let expected_roi = company.expected_roi, let previous_roi = company.previous_roi {
                self.companiesExpectedROI.append(Double(expected_roi))
                self.companiesPreviousROI.append(Double(previous_roi))
                if companies.count == 1 {
                    self.companiesExpectedROI.append(Double(expected_roi))
                    self.companiesPreviousROI.append(Double(previous_roi))
                }
            } else {
                self.companiesExpectedROI.append(0.0)
                self.companiesPreviousROI.append(0.0)
                if companies.count == 1 {
                    self.companiesExpectedROI.append(0.0)
                    self.companiesPreviousROI.append(0.0)
                }
            }
            
            // truncate the name if needed, so it fits on the left side of the bar
            var nameForChart: String = ""
            let maxSize = 18
            if(company.name.count <= maxSize) {
                nameForChart = company.name
            } else {
                nameForChart = self.truncateName(fullName: company.name, maxSize: maxSize)
            }
            self.companiesNames.append(nameForChart)
            self.companiesTickers.append(company.ticker)
            
            // there is a bug in the chart engine where if there is only one company
            // the chart breaks, so if there is one company add it to the array twice
            if companies.count == 1 {
                self.companiesNames.append(nameForChart)
                self.companiesTickers.append(company.ticker)
            }
        }
        self.companiesExpectedROI.reverse()
        self.companiesPreviousROI.reverse()
        self.companiesNames.reverse()
        self.companiesTickers.reverse()
        
        // set the chart height
        let chartHeight = CGFloat(companies.count * 70)
        self.addChartView(chartHeight: chartHeight)
        
        // reset the scrollview height
        let scrollViewHeight = CGFloat(chartHeight + 130)
        self.scrollView.contentSize = CGSize(width: self.bounds.width, height: scrollViewHeight)
          
        self.updateChartWithData()
    }
    
    func truncateName(fullName: String, maxSize: Int) -> String {
        // reduce the company name to the maxSize or less, but truncate on a space in the name so it looks right
        var currentSize: Int = 0
        var truncatedName: String = ""
        let subNameArr = fullName.components(separatedBy: " ")
        
        for subName in subNameArr {
            if currentSize + subName.count <= maxSize {
                currentSize = currentSize + subName.count
                if truncatedName.count == 0 {
                    truncatedName = subName
                } else {
                    truncatedName = truncatedName + " " + subName
                }
            }
        }
        return truncatedName
    }
    
    func addChartView(chartHeight: CGFloat) {
        // need to to remove and add the chart view to reset the height for the number of bars
        self.barChartView.removeFromSuperview()
        // barChartView
        self.scrollView.addSubview(self.barChartView)
        self.barChartView.translatesAutoresizingMaskIntoConstraints = false
        self.barChartView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 130).isActive = true
        self.barChartView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 5).isActive = true
        self.barChartView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -40).isActive = true
        self.barChartView.heightAnchor.constraint(equalToConstant: chartHeight).isActive = true
    }
    
    // create array for view, same function in own and buy views
    func updateChartWithData() {
           
        let stringFormatter = ChartStringFormatter()        // allow labels to be shown for bars
        let percentFormatter = PercentValueFormatter()      // allow labels to be shown for bars
       
        // data and names of the bars
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []

        for (index, expectedROI) in self.companiesExpectedROI.enumerated() {

            let dataEntry = BarChartDataEntry(x: Double(index) , y: expectedROI)
            dataEntries.append(dataEntry)

            let dataEntry1 = BarChartDataEntry(x: Double(index) , y: self.companiesPreviousROI[index])
            dataEntries1.append(dataEntry1)
        }
        stringFormatter.nameValues = self.companiesNames    // labels for the y axis
           
        // formatting, the horizontal bar chart is rotated so the axis labels are odd
        barChartView.xAxis.avoidFirstLastClippingEnabled = true
        barChartView.xAxis.valueFormatter = stringFormatter // allow labels to be shown for bars
        barChartView.xAxis.drawGridLinesEnabled = false     // hide horizontal grid lines
        barChartView.xAxis.drawAxisLineEnabled = false      // hide right axis
        barChartView.xAxis.labelFont = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)!
        barChartView.xAxis.setLabelCount(stringFormatter.nameValues.count, force: false)
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

        // format bars
        let chartDataSetExpectedRIO = BarChartDataSet(values: dataEntries, label: "")
        chartDataSetExpectedRIO.valueFormatter = percentFormatter      // formats the values into a %
        chartDataSetExpectedRIO.colors = [UIColor(red: 61/255, green: 182/255, blue: 111/255, alpha: 0.6)]
        // rgb values from status green with alpha value changed
        chartDataSetExpectedRIO.valueTextColor = UIColor.white
        chartDataSetExpectedRIO.valueFont = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)!
       
        let chartDataSetPreviousROI = BarChartDataSet(values: dataEntries1, label: "")
        chartDataSetPreviousROI.valueFormatter = percentFormatter      // formats the values into a %
        chartDataSetPreviousROI.colors = [UIColor(named: .statusGreen)]
        chartDataSetPreviousROI.valueTextColor = UIColor.white
        chartDataSetPreviousROI.valueFont = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)!

        let dataSets: [BarChartDataSet] = [chartDataSetExpectedRIO,chartDataSetPreviousROI]
        let chartData = BarChartData(dataSets: dataSets)
           
        let groupCount = self.companiesExpectedROI.count
        let barGroupLabelPaddingTop = 0.45
        barChartView.xAxis.axisMinimum = Double(barGroupLabelPaddingTop)
       
        let groupSpace = 0.14
        let barSpace = 0.05
        let barWidth = 0.33
        // (groupSpace + barSpace) * 2 + barWidth = 0.71 -> interval per "bar group"

        chartData.barWidth = barWidth;
        let groupWidth = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        //print("groupWidth: \(groupWidth)") // must equal 0.71
        barChartView.xAxis.axisMaximum = Double(barGroupLabelPaddingTop) + groupWidth * Double(groupCount)

        chartData.groupBars(fromX: Double(barGroupLabelPaddingTop), groupSpace: groupSpace, barSpace: barSpace)
        barChartView.notifyDataSetChanged()

        if(stringFormatter.nameValues.count > 0){
            self.barChartView.data = chartData
        }
    }
    
    func showActivityIndicator(uiView: UIView) {
        self.activityIndicator.backgroundColor = UIColor(named: .blue)
        self.activityIndicator.layer.cornerRadius = 10
        self.activityIndicator.clipsToBounds = true
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.style = UIActivityIndicatorView.Style.large
        actInd.center = CGPoint(x: 40, y: 40)
        
        self.activityIndicator.addSubview(actInd)
        actInd.startAnimating()
    }
}

