//
//  DiaryViewController.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 17.05.21.
//

import Foundation
import UIKit
import Charts
import CoreData

class DiaryViewController: UIViewController, ChartViewDelegate {
    
    var eyesOpenResults = [ChartDataEntry(x: 0, y: 50)]
    
    var eyesClosedResults = [ChartDataEntry(x: 0, y: 40)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundPrimary")
        
        // Do any additional setup after loading the view.
        loadResults()
        fillInChartData()
    
        view.addSubview(navBarExtensionView)
        view.addSubview(bottomTitleLabel)
        view.addSubview(lineChart)
        
        let guide = self.view.safeAreaLayoutGuide
        
        lineChart.frame = CGRect(x: 0, y: 150, width: guide.layoutFrame.width, height: guide.layoutFrame.height - 170)
        
        let constraints = [
            navBarExtensionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            navBarExtensionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            navBarExtensionView.topAnchor.constraint(equalTo: guide.topAnchor),
            navBarExtensionView.heightAnchor.constraint(equalToConstant: 60),
            
            bottomTitleLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            bottomTitleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            bottomTitleLabel.topAnchor.constraint(equalTo: guide.topAnchor),
            bottomTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            lineChart.leftAnchor.constraint(equalTo: guide.leftAnchor),
            lineChart.rightAnchor.constraint(equalTo: guide.rightAnchor),
            lineChart.topAnchor.constraint(equalTo: guide.topAnchor),
            lineChart.heightAnchor.constraint(equalToConstant: 300)
        ]
        NSLayoutConstraint.activate(constraints)
        
        self.navigationItem.titleView = topTitleLabel
    }
    
    //MARK: UI-Elements
    
    var topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Balance                  "
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(named: "FontColor")
        label.textAlignment = .left
        return label
    }()

    var bottomTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test Results"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = UIColor(named: "FontColor")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var navBarExtensionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BackgroundSecondary")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var lineChart: LineChartView = {
        let chartView = LineChartView()
        chartView.animate(xAxisDuration: 3)
        
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        let l = chartView.legend
        l.form = .line
        l.font = .systemFont(ofSize: 20)
        l.textColor = .black
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = true
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = UIColor(named: "FontColor")!
        leftAxis.axisMaximum = 65
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        return chartView
    }()
    
    func fillInChartData() {
        let set1 = LineChartDataSet(entries: eyesOpenResults, label: "eyes open")
        set1.axisDependency = .left
        set1.setColor(.red)
        set1.setCircleColor(.black)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 65/255
        set1.fillColor = .red
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        
        let set2 = LineChartDataSet(entries: eyesClosedResults, label: "eyes closed")
        set2.axisDependency = .left
        set2.setColor(.blue)
        set2.setCircleColor(.black)
        set2.lineWidth = 2
        set2.circleRadius = 3
        set2.fillAlpha = 65/255
        set2.fillColor = .blue
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set2.drawCircleHoleEnabled = false
        
        let data: LineChartData = [set1, set2]
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 15))
        
        lineChart.data = data
    }
    
    //MARK: CoreData
    
    private func loadResults() {
        let context = BalanceCoreData.stack.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BalanceResult")
        
        guard let dataEntry = try? context.fetch(request) as? [BalanceResult] else {
            return
        }
        
        var eyesOpenResultsNew: [ChartDataEntry] = []
        var eyesClosedResultsNew: [ChartDataEntry] = []
        
        var i = 0.0
        for result in dataEntry {
            eyesOpenResultsNew.append(ChartDataEntry(x: i, y: Double(result.eyesOpen)))
            eyesClosedResultsNew.append(ChartDataEntry(x: i, y: Double(result.eyesClosed)))
            i = i + 1
        }
        
        eyesOpenResults = eyesOpenResultsNew
        eyesClosedResults = eyesClosedResultsNew
    }
}
