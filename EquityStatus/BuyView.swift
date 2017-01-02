//
//  BuyView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import UIKit
import Charts

protocol BuyViewDelegate: class {
    func openEquityDetail(_: Equity)
}

class BuyView: UIView, ChartViewDelegate {
    
    weak var delegate: BuyViewDelegate?
    let barChartView = HorizontalBarChartView()
    let subTitle: UILabel = UILabel()
    var equitiesForBuyExpectedROI: [Double] = []
    var equitiesForBuyTicker: [String] = []
    let store = DataStore.sharedInstance
    let activityIndicator: UIView = UIView()
    var chartHeight: CGFloat = CGFloat()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.barChartView.delegate = self

        // get the data
        if equitiesForBuyTicker.count == 0 {
            pageLayoutNoData()
            self.subTitle.text = "Loading equities..."
            self.showActivityIndicator(uiView: self)
            self.barChartView.isHidden = true
            
            APIClient.getEquitiesFromDB(mode: "pass,passOrNoData"){
                self.createEquitiesForBuy()
                OperationQueue.main.addOperation {
                    self.subTitle.text = "Approved equites and expected returns."
                    self.updateChartWithData()
                    self.activityIndicator.isHidden = true
                    self.barChartView.isHidden = false
                    self.pageLayoutWithData()
                }
            }
        } else {
            self.createEquitiesForBuy()
            self.updateChartWithData()
            self.pageLayoutWithData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageLayoutNoData() {
        // layout
        self.addSubview(self.subTitle)
        self.subTitle.translatesAutoresizingMaskIntoConstraints = false
        self.subTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
        self.subTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.subTitle.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
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
        self.barChartView.topAnchor.constraint(equalTo: self.subTitle.bottomAnchor, constant: 6).isActive = true
        self.barChartView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.barChartView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.barChartView.heightAnchor.constraint(equalToConstant: self.chartHeight).isActive = true
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let equityClicked = store.getEquityByTickerFromStore(ticker: self.equitiesForBuyTicker[Int(entry.x)]) {
            self.delegate?.openEquityDetail(equityClicked)
        }
    }
    
    // create array for buy view
    func createEquitiesForBuy() {
        self.equitiesForBuyExpectedROI.removeAll()
        self.equitiesForBuyTicker.removeAll()
        
        for equity in self.store.equities {
            if equity.tab == .buy {
                self.equitiesForBuyExpectedROI.append(equity.expectedROIResult)
                self.equitiesForBuyTicker.append(equity.ticker)
            }
        }
        self.equitiesForBuyExpectedROI.reverse()
        self.equitiesForBuyTicker.reverse()
        
        self.chartHeight = CGFloat(self.equitiesForBuyTicker.count * 80)
        let maxChartHeight: CGFloat = UIScreen.main.bounds.height - 150 // subtract for heading and tabs at bottom
        
        if self.chartHeight > maxChartHeight {
            self.chartHeight = maxChartHeight
        }
    }
    
    func updateChartWithData() {
        
        let stringFormatter = ChartStringFormatter()        // allow labels to be shown for bars
        let percentFormatter = PercentValueFormatter()      // allow labels to be shown for bars
        var dataEntries: [BarChartDataEntry] = []
        
        // data and names of the bars
        let dataPoints: [Double] = self.equitiesForBuyExpectedROI   // values for the bars
        stringFormatter.nameValues = self.equitiesForBuyTicker      // labels for the y axis
        
        // formatting, the horizontal bar chart is rotated so the axis labels are odd
        barChartView.xAxis.valueFormatter = stringFormatter // allow labels to be shown for bars
        barChartView.xAxis.drawGridLinesEnabled = false     // hide horizontal grid lines
        barChartView.xAxis.drawAxisLineEnabled = false      // hide right axis
        barChartView.xAxis.labelFont = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)!
        barChartView.xAxis.setLabelCount(stringFormatter.nameValues.count, force: false)
        
        barChartView.rightAxis.enabled = false              // hide values on bottom axis
        barChartView.leftAxis.enabled = false               // hide values on top axis
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 0.6)
        barChartView.legend.enabled = false
        barChartView.chartDescription?.enabled = false

        barChartView.leftAxis.axisMinimum = 0.0             // required to show values on the horz bars, its a bug
        if let maxBarValue = self.equitiesForBuyExpectedROI.max() {
            barChartView.leftAxis.axisMaximum = maxBarValue + 2
        }
        
        for (index, dataPoint) in dataPoints.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: dataPoint)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = [UIColor(named: UIColor.ColorName.blue)]
        chartDataSet.valueFont = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)!
        chartDataSet.valueTextColor = UIColor(named: UIColor.ColorName.white)
        chartDataSet.valueFormatter = percentFormatter      // formats the values into a %
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.drawValueAboveBarEnabled = false       // places values inside the bars

        self.barChartView.data = chartData
    }
    
    func showActivityIndicator(uiView: UIView) {
        self.activityIndicator.backgroundColor = UIColor(named: UIColor.ColorName.blue)
        self.activityIndicator.layer.cornerRadius = 10
        self.activityIndicator.clipsToBounds = true
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: 40, y: 40)
        
        self.activityIndicator.addSubview(actInd)
        actInd.startAnimating()
    }
}
