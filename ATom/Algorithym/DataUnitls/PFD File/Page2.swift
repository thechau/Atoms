//
//  Page2.swift
//  TestPDFConvert
//
//  Created by Nguyễn Vương Thành Lộc on 7/20/19.
//  Copyright © 2019 Edmund. All rights reserved.
//

import UIKit
import SwiftChart
class Page2: pdfView {
    
    @IBOutlet weak var chartView: pdfView!
    @IBOutlet weak var baselineLabel: UILabel!
    @IBOutlet weak var amplitudeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    let smallColor = UIColor(red: 226/255, green: 113/255, blue: 160/255, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib(){
        let view:UIView? = (Bundle.main.loadNibNamed("Page2", owner: self, options: nil)?[0] as? UIView)
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        drawGridBoardPage()
        self.addSubview(view!)
        
        
    }
}
extension UIView{
    func drawGridBoard() {
        drawGrid(frame: self.frame, nbOfCell: 100, widthLine: 0.25, colorLine: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7))
        drawGrid(frame: self.frame, nbOfCell: 20, widthLine: 0.25, colorLine: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7))
        drawGrid(frame: self.frame, nbOfCell: 10, widthLine: 0.25, colorLine: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7))
    }
    
    func drawGrid( frame: CGRect, nbOfCell: CGFloat,  widthLine: CGFloat,  colorLine: UIColor){
        self.alpha = 0
        let vwGrid = GridView()
        vwGrid.frame = frame
        vwGrid.widthMin = widthLine
        vwGrid.numberOfCell = nbOfCell
        vwGrid.color = colorLine
        vwGrid.draw(CGRect(x: 0, y: 0, width: 0, height: 0))
        vwGrid.backgroundColor = .clear
        self.superview!.addSubview(vwGrid)
        
        
    }
}

extension Page2{
    internal func drawGridBoardPage() {
        drawGridPage(frame: chartView.frame, viewBase: chartView, nbOfCell: 175, widthLine: 0.5, smallColor)
        drawGridPage(frame: chartView.frame, viewBase: chartView, nbOfCell: 35, widthLine: 0.5, smallColor)
        drawGridPage(frame: chartView.frame, viewBase: chartView, nbOfCell: 17.5, widthLine: 1.25, smallColor)
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    func drawGridPage( frame: CGRect,  viewBase: UIView, nbOfCell: CGFloat,  widthLine: CGFloat, _ colorLine: UIColor){
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
