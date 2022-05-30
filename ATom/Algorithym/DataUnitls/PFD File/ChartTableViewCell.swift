//
//  ChartTableViewCell.swift
//  ECG_Project
//
//  Created by Edmund on 7/23/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import UIKit
import SwiftChart

class ChartTableViewCell: UITableViewCell {
    var chartDrawedView =  Chart()
    
    let smallColor = UIColor(red: 226/255, green: 113/255, blue: 160/255, alpha: 1)
    
    //For Chart
    let nbOfYValue = 1500
    var gameTimer3: Timer?
    var arr = [(x: -1.0, y: -1.0), (x: -1.0, y: -1.0)]
    var arrNil = [(x: -1.0, y: -1.0)]
    var arr2 = [(x: 0.0, y: 0.0), (x: 1.0, y: 1.0)]
    var i2 = 0
    var y2 = 80
    var arrText : [String] = []
    var arrSeries : [ChartSeries] = []
    var nbOfSeries = 0
    var Value6section = 5 // 10 : 3000 5: 1500
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chartDrawedView.frame = self.contentView.bounds
        chartDrawedView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chartDrawedView)
        // Initialization code
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getData(){
        
        Value6section = nbOfYValue == 1500 ? 10 : 20
        chartDrawedView.delegate = self
        chartDrawedView.lineWidth = 1
        chartDrawedView.showXLabelsAndGrid = false
        chartDrawedView.showYLabelsAndGrid = false
        
        let path = Bundle.main.path(forResource: "ecg_miBEAT", ofType: "txt")
        do
        {
            let contents = try String(contentsOfFile: path!)
            arrText = contents.components(separatedBy: "\n")
            print(arrText.count)
            self.arr.removeAll()
            chartDrawedView.xLabels = [0.0, Double(nbOfYValue)] //Double(arrText.count - 1)]
            chartDrawedView.yLabels = [0, 1]//chia 128
            //            nextTime()
            let nbTemp = nbOfYValue/Value6section
            self.chartDrawedView.series = [ChartSeries](repeating: ChartSeries(data: arr), count: nbTemp * 4)
            self.arrNil = [(x: Double, y: Double)](repeating: (x: 0.0, y: 0.0), count: nbOfYValue)
            //            self.arrNil
            drawAgain()
        }
        catch
            
        {
            print("can not load file")
        }
    }
    
    func drawAgain(){
        self.arr2.removeAll()
        self.i2 = 0
        self.y2 = 0
        gameTimer3 = Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(drawFinal), userInfo: nil, repeats: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            // your code here
            print("agian",self.i2)
            self.gameTimer3?.invalidate()
        }
    }
    
    
    @objc func drawFinal(){
        if i2%nbOfYValue == 0 && i2 != 0 {
            //            self.chart.removeAllSeries()
            print("nb of series", self.nbOfSeries)
            y2 = 0
            print(i2)
            self.nbOfSeries = 0
        }
        
        //        if nbOfSeries > nbOfYValue/Value6section && nbOfSeries < self.chart.series.count{
        //            self.chart.removeSeriesAt(nbOfSeries - nbOfYValue/Value6section)
        //            print(self.chart.series.count)
        //        }
        
        if i2 == 7500{
            return
        }
        
        arr2.removeAll()
        self.appendData3(i2)
        let series3 = ChartSeries(data: arr2)
        series3.color = ChartColors.blueColor()
        series3.area = false
        //        self.chart.add(series3)
        self.chartDrawedView.series[nbOfSeries] = series3
        if nbOfSeries < nbOfYValue/Value6section - 3 {
            self.chartDrawedView.series[nbOfSeries + 1] = ChartSeries(data: arrNil)
            self.chartDrawedView.series[nbOfSeries + 2] = ChartSeries(data: arrNil)
            self.chartDrawedView.series[nbOfSeries + 3] = ChartSeries(data: arrNil)
        }
        self.nbOfSeries += 1
        y2 += Value6section
        i2 += Value6section
    }
    
    func appendData3(_ i: Int){
        for z in 0...Value6section{
            if i + z < arrText.count - 1 {
                arr2.append((x: Double(self.y2) + Double(z), y: Double(arrText[i + z])!/256)) // 0 -- 10 // 5 - 15 // -- 10 -20
            }
        }
    }
}

extension ChartTableViewCell: ChartDelegate{
    // Chart delegate
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                print("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //
    //        super.viewWillTransition(to: size, with: coordinator)
    //
    //        // Redraw chart on rotation
    //        chart.setNeedsDisplay()
    //
    //    }
    
}

//MARK: Set up chart

extension ChartTableViewCell{
    internal func drawGridBoardPageCellCell() {
        drawGridPageCell(self.contentView.frame, self.contentView, 175, 0.5, smallColor)
        drawGridPageCell(self.contentView.frame, self.contentView, 35, 0.5, smallColor)
        drawGridPageCell(self.contentView.frame, self.contentView, 17.5, 1.25, smallColor)
        chartDrawedView.frame = self.contentView.bounds
        chartDrawedView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chartDrawedView)
        chartDrawedView.layoutIfNeeded()
        chartDrawedView.setNeedsLayout()
        self.layoutIfNeeded()
        self.setNeedsLayout()
        self.getData()
    }
    
    func drawGridPageCell(_ frame: CGRect, _ viewBase: UIView,_ nbOfCell: CGFloat, _ widthLine: CGFloat, _ colorLine: UIColor){
        let vwGrid = GridView()
        //        vwGrid.frame = frame
        vwGrid.widthMin = widthLine
        vwGrid.numberOfCell = nbOfCell
        vwGrid.color = colorLine
        vwGrid.draw(CGRect(x: 0, y: 0, width: 0, height: 0))
        vwGrid.backgroundColor = .clear
        vwGrid.frame = viewBase.bounds
        //        self.addSubview(vwGrid)
        self.addSubview(vwGrid)
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
}
