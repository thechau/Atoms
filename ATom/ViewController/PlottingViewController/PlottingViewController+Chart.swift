//
//  PlottingViewController+Chart.swift
//  ATOM
//
//  Created by Phan The Chau on 12/04/2022.
//

import Foundation
import UIKit
import SwiftChart
import RxSwift


extension PlottingViewController {
    func getData() {
        
        let path = Bundle.main.path(forResource: "ecg_miBEAT", ofType: "txt")
        do
        {
            let contents = try String(contentsOfFile: path!)
            self.plottingChartViewI.listDataFromFileSample = contents.components(separatedBy: "\n")
            self.plottingChartViewI.handelData(contents)
            self.plottingChartViewII.listDataFromFileSample = contents.components(separatedBy: "\n")
            self.plottingChartViewII.handelData(contents)
            self.plottingChartViewIII.listDataFromFileSample = contents.components(separatedBy: "\n")
            self.plottingChartViewIII.handelData(contents)
            
            self.plottingChartViewaVL.listDataFromFileSample = contents.components(separatedBy: "\n")
            self.plottingChartViewaVL.handelData(contents)
            
            self.plottingChartViewaVR.listDataFromFileSample = contents.components(separatedBy: "\n")
            self.plottingChartViewaVR.handelData(contents)
            self.plottingChartViewaVF.listDataFromFileSample = contents.components(separatedBy: "\n")
            self.plottingChartViewaVF.handelData(contents)
            
            self.plottingChartViewaV1.listDataFromFileSample = contents.components(separatedBy: "\n")
            self.plottingChartViewaV1.handelData(contents)
            self.plottingChartViewaV2.listDataFromFileSample = contents.components(separatedBy: "\n")
            self.plottingChartViewaV2.handelData(contents)
            self.plottingChartViewaV3.listDataFromFileSample = contents.components(separatedBy: "\n")
            self.plottingChartViewaV3.handelData(contents)
            
            self.plottingChartViewaV4.listDataFromFileSample = contents.components(separatedBy: "\n")
            self.plottingChartViewaV4.handelData(contents)
            self.plottingChartViewaV5.listDataFromFileSample = contents.components(separatedBy: "\n")
            self.plottingChartViewaV5.handelData(contents)
            self.plottingChartViewaV6.listDataFromFileSample = contents.components(separatedBy: "\n")
            self.plottingChartViewaV6.handelData(contents)
            view.layoutIfNeeded()
        }
        catch
            
        {
            print("can not load file")
        }
    }
    
    @objc func drawForAMonment() {
        getListChart().forEach { viewList in
            viewList.forEach { chart in
                chart.drawForAMonment()
            }
        }
    }
    
    func drawGridBoard() {
        removeSubViewInGridBorad()
        drawGrid(vwGridBoard.bounds, 0.3, smallColor, size: 10)
        drawGrid(vwGridBoard.bounds, 0.7, smallColor, size: 50)
        drawGrid(vwGridBoard.bounds, 1.5, smallColor, size: 100)
        view.layoutIfNeeded()
    }
    
    private func removeSubViewInGridBorad() {
        vwGridBoard.subviews.forEach { view in
            if !(view is UIStackView) {
                view.removeFromSuperview()
            }
        }
    }
    
    func drawSampleGridView() {
        removeSubViewInGridBorad()
        drawGrid(vwGridBoard.bounds,
                 0.7,
                 smallColor,
                 size: 50)
        view.layoutIfNeeded()
    }
    
    fileprivate func drawGrid(_ frame: CGRect,
                              _ widthLine: CGFloat,
                              _ colorLine: UIColor,
                              size: CGFloat) {
        let vwGrid = GridView()
        vwGrid.frame = frame
        vwGrid.sizeCell = size
        vwGrid.widthMin = widthLine
        vwGrid.color = UIColor.lightGray.withAlphaComponent(0.8)
        vwGrid.draw(CGRect(x: 0, y: 0, width: 0, height: 0))
        vwGrid.backgroundColor = .clear
        vwGridBoard.addSubview(vwGrid)
    }
}

extension PlottingViewController: ChartDelegate {
    // Chart delegate
    
    func didFinishTouchingChart(_ chart: Chart) {}
    
    func didEndTouchingChart(_ chart: Chart) {}
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                print("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
            }
        }
    }
}
