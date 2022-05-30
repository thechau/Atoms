//
//  Page1.swift
//  TestPDFConvert
//
//  Created by Nguyễn Vương Thành Lộc on 7/18/19.
//  Copyright © 2019 Edmund. All rights reserved.
//

import UIKit
import SwiftChart

class Page1: pdfView {

    @IBOutlet weak var chartView: pdfView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var bpLabel: UILabel!
    @IBOutlet weak var smokingLabel: UILabel!
    @IBOutlet weak var drinkingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var patientIdLabel: UILabel!
    @IBOutlet weak var referredByLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    
    let smallColor = UIColor(red: 226/255, green: 113/255, blue: 160/255, alpha: 1)
    
    var Value6section = 5 // 10 : 3000 5: 1500
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        loadNib()
    }
    
    func loadNib(){
        let view:UIView? = (Bundle.main.loadNibNamed("Page1", owner: self, options: nil)?[0] as? UIView)
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        drawGridBoardPage()
        self.addSubview(view!)
        
        var leadIndex = 0
        var line : Double = 0
        while leadIndex < 12 {
           // chartView.drawPulse(line: line, standard: false)
            //            var i = startIndex
            //            var x : Double = 0
            //            view1.chartView.writeLeadLabel(lead: DataUtils.ALL_LEADS[leadIndex], x: CGFloat(x), line: Int(line), standard: false)
            //            while i < Int(Double(startIndex) + dataLength){
            //                var leadDataIn = PdfUtils.getLeadDatInCms()
            //                let val1 = leadDataIn[DataUtils.ALL_LEADS[leadIndex]][i]
            //                let val2 = leadDataIn[DataUtils.ALL_LEADS[leadIndex]][i + 1]
            //                view1.chartView.drawEcgLine(line: Int(line), DataUtils.ALL_LEADS[leadIndex], x: CGFloat(x), val1: val1, val2: val2, standard: false)
            //                i += 1
            //                x += 1
            //            }
            //            x += 5
            line += 1
            leadIndex += 1
        }
    }
}

//MARK: Set up chart

extension Page1{
    internal func drawGridBoardPage() {
        drawGridPage(chartView.frame, chartView, 175, 0.5, smallColor)
        drawGridPage(chartView.frame, chartView, 35, 0.5, smallColor)
        drawGridPage(chartView.frame, chartView, 17.5, 1.25, smallColor)
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    func drawGridPage(_ frame: CGRect, _ viewBase: UIView,_ nbOfCell: CGFloat, _ widthLine: CGFloat, _ colorLine: UIColor){
        let vwGrid = GridView()
        vwGrid.widthMin = widthLine
        vwGrid.numberOfCell = nbOfCell
        vwGrid.color = colorLine
        vwGrid.draw(CGRect(x: 0, y: 0, width: 0, height: 0))
        vwGrid.backgroundColor = .clear
        vwGrid.frame = viewBase.bounds
        self.chartView.addSubview(vwGrid)
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
}
