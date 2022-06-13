//
//  GridView.swift
//  ECG_Project
//
//  Created by Phung Duc Chinh on 5/23/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
import UIKit

var ppi: CGFloat = 0

class GridView: UIView
{
    private var path = UIBezierPath()
    public var widthMin: CGFloat = 2.5
    public var sizeCell : CGFloat = 32.0
    public var color : UIColor = .purple
    
    fileprivate var gridWidth: CGFloat
    {
        return widthMin//bounds.width/CGFloat(gridWidthMultiple)
    }
    
    fileprivate func drawGrid(size: CGFloat)
    {
        path = UIBezierPath()
        path.lineWidth = gridWidth
        let viewWidth:CGFloat = self.bounds.width
        
        let viewHight:CGFloat = self.bounds.height
        
        let x1:CGFloat = 0
        let x2:CGFloat = viewWidth
        
        let y1:CGFloat = 0
        let y2:CGFloat = viewHight
        let cellLength: CGFloat = CGFloat(size)//min(viewHight, viewWidth) / numberOfCell
        
        var i: CGFloat = -cellLength
        while (i < viewHight) {
            let start = CGPoint(x: x1, y: cellLength + i)
            let end = CGPoint(x: x2, y: cellLength + i)
            path.move(to: start)
            path.addLine(to: end)
            i = i + cellLength
        }
        
        var j: CGFloat = -cellLength
        while (j < viewWidth) {
            let start = CGPoint(x: cellLength + j, y: y1)
            let end = CGPoint(x: cellLength + j,y: y2)
            path.move(to: start)
            path.addLine(to: end)
            j = j + cellLength
        }
        path.close()
        
    }
    
    override func draw(_ rect: CGRect) {
        drawGrid(size: mmToPoints(sizeCell))
        color.setStroke()
        path.stroke()
    }
}

func mmToPoints(_ value: CGFloat) -> CGFloat{
    return ppi * value / 122
}
