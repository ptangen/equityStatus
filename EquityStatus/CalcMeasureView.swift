//
//  CalcMeasureView.swift
//  EquityStatus
//
//  Created by Paul Tangen on 1/27/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import UIKit
import Charts

protocol MeasureDetailViewDelegate: class {
    func showAlertMessage(_: String)
}

class CalcMeasureView: UIView, ChartViewDelegate {

    weak var delegate: MeasureDetailViewDelegate?
    let store = DataStore.sharedInstance
    var measureTicker = String()
    var equity: Equity!
    var measureShortName = String()
    var measureLongNameLabel = UILabel()
    var statusLabel = UILabel()
    var statusIcon = UILabel()
    var statusValueDesc = UILabel()
    var resultsLabel = UILabel()
    var targetLabel = UILabel()
    var measureCalcDescLabel = UILabel()
    var chartLabel = UILabel()
    
    let barChartView = BarChartView()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.pageLayout()
        self.barChartView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getResultString(resultDouble: Double, percentage: Bool) -> String {
        if resultDouble == -1000 {
            return "no data"
        } else {
            if percentage == true {
                return String(resultDouble) + "%"
            } else {
                return String(resultDouble)
            }
        }
    }
    
    func getStatusDesc(_ statusDesc: String) -> String {
        if statusDesc == "noData" {
            return "no data"
        } else {
            return statusDesc;
        }
    }
    
    func fetchChartDataFromDataStore(historicalDataLabel: String) -> ([String],[Double]) {
        switch historicalDataLabel {
        case "ReturnOnEquity":
            return self.equity.ROEHistory
        case "EarningsPerShare":
            return equity.EPSHistory
        case "BookValuePerShare":
            return equity.BVHistory
        case "DebtEquity":
            return equity.DRHistory
        case "Shares":
            return equity.SOHistory
        default:
            break
            
        }
        return ([],[])
    }
    
    func fetchChartData(historicalDataLabel: String){
        // try to get the historicalData from the dataStore
        let chartDataFromStore = fetchChartDataFromDataStore(historicalDataLabel: historicalDataLabel)
        
        if chartDataFromStore.1.isEmpty {
            // here we fetch the historical data that was used to calculate the value for the measure
            let ticker = Utilities.getTickerFromLabel(fullString: self.measureTicker)
            APIClient.getMeasureValuesFromDB(ticker: ticker, measure: historicalDataLabel, completion: { chartDataFromAPI in
                if chartDataFromAPI.1.isEmpty {
                    // print("No data for this measure/company.")
                    // the chart displays a nice message when no data exists
                } else if chartDataFromAPI.0[0] == "error" {
                    print("error fetching data")
                    if let delegate = self.delegate {
                        delegate.showAlertMessage("Unable to fetch chart data. Please contact ptangen@ptangen.com about this situation.")
                    }
                } else {
                    self.drawChart(chartData: chartDataFromAPI)
                }
            }) // end apiClient.getMeasureValues
        } else {
            self.drawChart(chartData: chartDataFromStore)
        }
    }
    
    func drawChart(chartData: (annualLabels: [String], annualValues: [Double])){
        
        let stringFormatter = ChartStringFormatter()            // allow labels to be shown for bars
        //let percentFormatter = PercentValueFormatter()        // allow labels to be shown for bars
        var dataEntries: [BarChartDataEntry] = []
        
        // data and names of the bars
        let dataPoints: [Double] = chartData.annualValues       // values for the bars
        stringFormatter.nameValues = chartData.annualLabels     // labels for the x axis
        
        // formatting
        barChartView.xAxis.valueFormatter = stringFormatter     // allow labels to be shown for bars
        barChartView.xAxis.drawGridLinesEnabled = false         // hide horizontal grid lines
        barChartView.xAxis.drawAxisLineEnabled = false          // hide right axis
        barChartView.xAxis.labelFont = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)!
        barChartView.xAxis.setLabelCount(stringFormatter.nameValues.count, force: false)
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1.0
        barChartView.xAxis.labelPosition = .bottom
        
        barChartView.rightAxis.enabled = false                  // hide values
        barChartView.leftAxis.enabled = false                   // hide values
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 0.6)
        barChartView.legend.enabled = false
        if let chartDescription = barChartView.chartDescription {
            chartDescription.enabled = false
        }

        for (index, dataPoint) in dataPoints.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: dataPoint)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = [UIColor(named: .statusGreen)]
        chartDataSet.valueFont = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.xsmall.rawValue)!
        chartDataSet.valueTextColor = UIColor.black
        //chartDataSet.valueFormatter = percentFormatter      // formats the values into a %
        let chartData = BarChartData(dataSet: chartDataSet)
        
        self.barChartView.data = chartData
    }
    
    func pageLayout() {
        // measureLongNameLabel
        self.addSubview(self.measureLongNameLabel)
        self.measureLongNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.measureLongNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        self.measureLongNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.measureLongNameLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        self.measureLongNameLabel.font = UIFont(name: Constants.appFont.bold.rawValue, size: Constants.fontSize.small.rawValue)
        self.measureLongNameLabel.numberOfLines = 0
        
        // statusLabel
        self.addSubview(self.statusLabel)
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.statusLabel.topAnchor.constraint(equalTo: self.measureLongNameLabel.bottomAnchor, constant: 30).isActive = true
        self.statusLabel.leftAnchor.constraint(equalTo: self.measureLongNameLabel.leftAnchor).isActive = true
        self.statusLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // statusIcon
        self.addSubview(self.statusIcon)
        self.statusIcon.translatesAutoresizingMaskIntoConstraints = false
        self.statusIcon.topAnchor.constraint(equalTo: self.statusLabel.topAnchor, constant: 0).isActive = true
        self.statusIcon.leftAnchor.constraint(equalTo: self.statusLabel.rightAnchor, constant: 8).isActive = true
        self.statusIcon.font = UIFont(name: Constants.iconFont.fontAwesome.rawValue, size: Constants.iconSize.xsmall.rawValue)
        
        // statusValueDesc
        self.addSubview(self.statusValueDesc)
        self.statusValueDesc.translatesAutoresizingMaskIntoConstraints = false
        self.statusValueDesc.topAnchor.constraint(equalTo: self.statusIcon.topAnchor, constant: 0).isActive = true
        self.statusValueDesc.leftAnchor.constraint(equalTo: self.statusIcon.rightAnchor, constant: 8).isActive = true
        self.statusValueDesc.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // resultsLabel
        self.addSubview(self.resultsLabel)
        self.resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.resultsLabel.topAnchor.constraint(equalTo: self.statusLabel.bottomAnchor, constant: 30).isActive = true
        self.resultsLabel.leftAnchor.constraint(equalTo: self.statusLabel.leftAnchor).isActive = true
        self.resultsLabel.rightAnchor.constraint(equalTo: self.measureLongNameLabel.rightAnchor).isActive = true
        self.resultsLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // targetLabel
        self.addSubview(self.targetLabel)
        self.targetLabel.translatesAutoresizingMaskIntoConstraints = false
        self.targetLabel.topAnchor.constraint(equalTo: self.resultsLabel.bottomAnchor, constant: 30).isActive = true
        self.targetLabel.leftAnchor.constraint(equalTo: self.resultsLabel.leftAnchor).isActive = true
        self.targetLabel.rightAnchor.constraint(equalTo: self.resultsLabel.rightAnchor).isActive = true
        self.targetLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        
        // measureCalcDescLabel
        self.addSubview(self.measureCalcDescLabel)
        self.measureCalcDescLabel.translatesAutoresizingMaskIntoConstraints = false
        self.measureCalcDescLabel.topAnchor.constraint(equalTo: self.targetLabel.bottomAnchor, constant: 30).isActive = true
        self.measureCalcDescLabel.leftAnchor.constraint(equalTo: self.targetLabel.leftAnchor).isActive = true
        self.measureCalcDescLabel.rightAnchor.constraint(equalTo: self.targetLabel.rightAnchor).isActive = true
        self.measureCalcDescLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.measureCalcDescLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        self.measureCalcDescLabel.numberOfLines = 0
        
        // chartLabel
        self.addSubview(self.chartLabel)
        self.chartLabel.translatesAutoresizingMaskIntoConstraints = false
        self.chartLabel.topAnchor.constraint(equalTo: self.measureCalcDescLabel.bottomAnchor, constant: 30).isActive = true
        self.chartLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.chartLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.chartLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.chartLabel.font = UIFont(name: Constants.appFont.regular.rawValue, size: Constants.fontSize.small.rawValue)
        self.chartLabel.numberOfLines = 0
        self.chartLabel.backgroundColor = UIColor(named: .beige)
        
        // chart label
        self.addSubview(self.barChartView)
        self.barChartView.translatesAutoresizingMaskIntoConstraints = false
        self.barChartView.topAnchor.constraint(equalTo: self.chartLabel.bottomAnchor, constant: 0).isActive = true
        self.barChartView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.barChartView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.barChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        self.barChartView.backgroundColor = UIColor(named: .beige)
    }
    
    func setResultsLabelsForMeasure(fullString: String) {
        
        self.statusLabel.text = "Status:"
        self.measureShortName = Utilities.getMeasureName(fullString: fullString)

        // get the measure results and set the label text
        if self.measureShortName == "ROEa" {
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.ROEa)()
            Utilities.setStatusIcon(status: self.equity.ROEaStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.ROEaStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.ROEaResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.ROEa)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.ROEa)()
            
        } else if self.measureShortName == "EPSi" {
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.EPSi)()
            Utilities.setStatusIcon(status: self.equity.EPSiStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.EPSiStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.EPSiResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.EPSi)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.EPSi)()
            
        } else if self.measureShortName == "EPSv" {
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.EPSv)()
            Utilities.setStatusIcon(status: self.equity.EPSvStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.EPSvStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.EPSvResult, percentage: false)
            self.targetLabel.text = Constants.measureMetadata.threshold(.EPSv)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.EPSv)()
            
        } else if self.measureShortName == "BVi" {
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.BVi)()
            Utilities.setStatusIcon(status: self.equity.BViStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.BViStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.BViResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.BVi)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.BVi)()
            
        } else if self.measureShortName == "DRa" {
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.DRa)()
            Utilities.setStatusIcon(status: self.equity.DRaStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.DRaStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.DRaResult, percentage: false)
            self.targetLabel.text = Constants.measureMetadata.threshold(.DRa)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.DRa)()
            
        } else if self.measureShortName == "SOr" {
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.SOr)()
            Utilities.setStatusIcon(status: self.equity.SOrStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.SOrStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.SOrResult, percentage: false)
            self.targetLabel.text = Constants.measureMetadata.threshold(.SOr)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.SOr)()
            
        } else if self.measureShortName == "previousROI" {
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.previousROI)()
            Utilities.setStatusIcon(status: self.equity.previousROIStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.previousROIStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.previousROIResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.previousROI)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.previousROI)()
            
        } else if self.measureShortName == "expectedROI" {
            self.measureLongNameLabel.text = Constants.measureMetadata.longName(.expectedROI)()
            Utilities.setStatusIcon(status: self.equity.expectedROIStatus, uiLabel: self.statusIcon)
            self.statusValueDesc.text = "(" + getStatusDesc(self.equity.expectedROIStatus) + ")"
            self.resultsLabel.text = "Result: " + getResultString(resultDouble: self.equity.expectedROIResult, percentage: true)
            self.targetLabel.text = Constants.measureMetadata.threshold(.expectedROI)()
            self.measureCalcDescLabel.text = Constants.measureMetadata.calcDesc(.expectedROI)()
        }
    }
}
