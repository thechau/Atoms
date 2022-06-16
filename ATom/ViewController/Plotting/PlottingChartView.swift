//
//  PlottingChartView.swift
//  ATOM
//
//  Created by Phan The Chau on 12/04/2022.
//

import UIKit
import RxSwift
import SwiftChart

class PlottingChartView: UIView {
    
    @IBOutlet weak var chartView: Chart!
    @IBOutlet weak var heightChartView: NSLayoutConstraint!
    @IBOutlet weak var namePlotLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    let nbOfYValue = 1500
    var step = 5 //Space// 10 : 3000 5: 1500
    
    var listPointTemp = [(x: -1.0, y: -1.0), (x: -1.0, y: -1.0)]
    //  var listPointPrevous = [(x: -1.0, y: -1.0)]
    
    var listPoint = [(x: 0.0, y: 0.0), (x: 1.0, y: 1.0)]
    var coordinate_Line = Point_Coordinate(x: 0, y: 0)
    
    var listDataFromFileSample : [String] = []
    var arrSeries : [ChartSeries] = []
    
    var countSeries = 0
    var arrInt : [Int] = []
    var startRemoveLayer = false
    //    var duration = 0.025
    var drawingHeight: CGFloat = 150
    var drwaingRatio: Double = 2
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupChart(viewController: PlottingViewController, name: String, timer: Timer?) {
        chartView.delegate = viewController
        chartView.lineWidth = 1.5
        chartView.showXLabelsAndGrid = false
        chartView.showYLabelsAndGrid = false
        chartView.yLabels = [0, 1.3]
        chartView.xLabels = [5, Double(1500)]
        namePlotLabel.text = name
        chartView.gridColor = .clear
        chartView.backgroundColor = .clear
        chartView.axesColor = .clear
        setLayoutChart()
        // layoutIfNeeded()
    }
    
    func setLayoutChart() {
        arrInt = []
        countSeries = 0
        startRemoveLayer = false
        step = 5
        chartView.lineWidth = 1.5
        chartView.showXLabelsAndGrid = false
        chartView.showYLabelsAndGrid = false
        chartView.yLabels = [-0.5, 1.3]
        chartView.xLabels = [0.0, Double(1500)]
        chartView.gridColor = .clear
        chartView.backgroundColor = .clear
        chartView.axesColor = .clear
        seriesChart.removeAll()
        coordinate_Line = Point_Coordinate(x: 0, y: 0)
        listDataFromFileSample = []
        arrSeries = []
        listPointTemp = [(x: -1.0, y: -1.0), (x: -1.0, y: -1.0)]
        chartView.removeAllSeries()
        chartView.removeSubView()
        heightChartView.constant = drawingHeight
        chartView.drawingHeight = drawingHeight//bounds.height
        chartView.drawingWidth = bounds.width
        chartView.getMinMaxs()
    }
    
    class func instanceFromNib() -> PlottingChartView {
        guard let view = UINib(nibName: "PlottingChartView", bundle: nil)
                .instantiate(withOwner: nil, options: nil)[0] as? PlottingChartView else {
                    return PlottingChartView()
                }
        return view
    }
    
    var seriesChart: [ChartSeries] {
        get {
            return chartView.series
        }
        set {
            chartView.series = newValue
        }
    }
    
    func handelData(_ contents: String) {
        caculateNumberSeries()
        drawChart()
    }
    
    private func caculateNumberSeries() {
        let nbTemp = (nbOfYValue / Int(drwaingRatio) )/step
        chartView.layerStore = [CAShapeLayer](repeating: CAShapeLayer(), count: nbTemp)
        seriesChart = [ChartSeries](repeating: ChartSeries(data: listPointTemp), count: nbTemp)
        //listPointPrevous = [(x: Double, y: Double)](repeating: (x: 0.0, y: 0.0), count: nbOfYValue)
    }
    
    fileprivate func drawChart() {
        self.listPoint.removeAll()
        coordinate_Line.resetValue()
    }
    
    @objc func drawForAMonment(){
        if coordinate_Line.x % (nbOfYValue / Int(drwaingRatio)) == 0 && coordinate_Line.x != 0 {
            coordinate_Line.y = 0
            countSeries = 0
            startRemoveLayer = true
        }
        if coordinate_Line.x == 7500 {
            return
        }
        listPoint.removeAll()
        addListPoint(coordinate_Line.x)
        setPrevouseStep()
        if listPoint.count > 0,
           !seriesChart.isEmpty {
            drawChartBySeries()
        }
        coordinate_Line.setValueCoordinateNext(value: step)
    //print(coordinate_Line.x)
    }
    
    private func setPrevouseStep() {
        if countSeries < nbOfYValue/step - 3 {
            let char1 = ChartSeries(data: listPoint)
            char1.area = false
            if startRemoveLayer {
                chartView.removeLayer(index: countSeries + 1)
                chartView.removeLayer(index: countSeries + 2)
            }
        }
        countSeries += 1
    }
    
    private func addListPoint(_ i: Int) {
        for z in 0...step {
            if i + z < listDataFromFileSample.count - 1 {
                listPoint.append((x: (Double(coordinate_Line.y) + Double(z)) * drwaingRatio,
                                  y: Double(listDataFromFileSample[i + z])!/256))
                // 0 -- 10 // 5 - 15 // -- 10 -20
            }
        }
    }
    
    private func drawChartBySeries() {
        let series = ChartSeries(data: listPoint)
        series.color = UIColor.black
        series.area = false
       // print(listPoint)
        if countSeries <  seriesChart.count - 1 {
            seriesChart[countSeries] = series
            chartView.drawlineWithSeries(series, countSeries, colors: .black)
        }
    }
    
    func setDrawingRatio(isHighSpeed: Bool) {
        drwaingRatio = isHighSpeed ? 2 : 1
        chartView.drwaingRatio = isHighSpeed ? 2 : 1
    }
}
