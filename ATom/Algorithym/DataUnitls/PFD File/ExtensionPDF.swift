//
//  Exxtension.swift
//  TestPDFConvert
//
//  Created by Edmund on 7/16/19.
//  Copyright © 2019 Edmund. All rights reserved.
//

import Foundation
import UIKit
var i = 0
class pdfView:  UIView {
    
    var scalepdf : CGFloat = 0.9439104
    var corrh : CGFloat = 0.9481925
    var corrv : CGFloat = 0.5
    var scalesite : CGFloat = 1
    var offseth : CGFloat = 10
    let offsetv : CGFloat = 20;
    private var fg: Int = 30 ;
    
    private var x_scale : CGFloat = 150 / 250;
    
    // Export pdf from Save pdf in drectory and return pdf file path
    func exportAsPdfFromView() -> String {
        let pdfPageFrame = CGRect(x: 0, y: 0, width: 841.8, height: 595.2)
        let renderer = UIGraphicsPDFRenderer(bounds: pdfPageFrame)
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        return self.saveViewPdf(data: pdfData)
        
    }
    
    // Save pdf file in document directory
    func saveViewPdf(data: NSMutableData) -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("viewPdf\(i).pdf")
        i += 1
        do{
            try? data.write(to: pdfPath)
            return pdfPath.path
        }catch{
            return ""
        }
    }
    
    func drawCircle(r: CGFloat) {
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: transh(x: self.center.x) ,y: transv(x: self.center.y)), radius: transr(x: CGFloat(r * 60 * 3)), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 1.0
        shapeLayer.lineDashPattern = [2,2]
        self.layer.addSublayer(shapeLayer)
    }
    
    func drawSlope(radius: Double, angle: Double) {
        let radians = angle.degreesToRadians
        let x = (radius * cos(radians));
        let y =  (radius * sin(radians));
        drawLine(x1: 0, y1: 0, x2: x, y2: y);
    }
    
    func drawSlope2(radius: Double, angle: Double) {
        let radians =  angle.degreesToRadians
        let x = (radius * cos(radians));
        let y =  (radius * sin(radians));
        drawLine2(x1: 0, y1: 0, x2: x, y2: y);
    }
    
    func drawLine2(x1: Double, y1: Double, x2: Double, y2: Double){
        let aPath = UIBezierPath()
        let xOffset : Double = Double(self.center.x);
        let yOffset : Double = Double(self.center.y);
        
        let y11 : CGFloat = CGFloat((y1 * 60 * 3) + yOffset);
        let y22 : CGFloat  = CGFloat((y2 * 60 * 3) + yOffset);
        
        let x11 : CGFloat  = CGFloat((x1 * 60 * 3) + xOffset);
        let x22 : CGFloat  = CGFloat((x2 * 60 * 3) + xOffset);
        
        aPath.move(to: CGPoint(x: transh(x: x11) , y: transv(x: y11)))
        
        aPath.addLine(to: CGPoint(x:transh(x: x22), y: transv(x: y22)))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = aPath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 0.5
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func drawLine(x1: Double, y1: Double, x2: Double, y2: Double){
        let aPath = UIBezierPath()
        let xOffset : Double = Double(self.center.x);
        let yOffset : Double = Double(self.center.y);
        
        let y11 : CGFloat = CGFloat((y1 * 60 * 3) + yOffset);
        let y22 : CGFloat  = CGFloat((y2 * 60 * 3) + yOffset);
        
        let x11 : CGFloat  = CGFloat((x1 * 60 * 3) + xOffset);
        let x22 : CGFloat  = CGFloat((x2 * 60 * 3) + xOffset);
        
        aPath.move(to: CGPoint(x: transh(x: x11) , y: transv(x: y11)))
        
        aPath.addLine(to: CGPoint(x:transh(x: x22), y: transv(x: y22)))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = aPath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 1.0
        shapeLayer.lineDashPattern = [1,2]
        
        self.layer.addSublayer(shapeLayer)
    }
    
    // writes label for slope angle degree
    func writeDegree(radius: Double, angle: Double, text: String) {
        let xOffset : Double = Double(self.center.x);
        let yOffset : Double = Double(self.center.y);
        
        let radians = angle.degreesToRadians
        let x = (radius * cos(radians)) * 180 + xOffset;
        let y = (radius * sin(radians)) * 180 + yOffset;
        
        let label = UILabel(frame: CGRect(x: transh(x: CGFloat(x)) , y: transv(x: CGFloat(y)) , width: 60, height: 40))
        self.addSubview(label)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = text
    }
    
    func writeLeadLabelRhythm( lead: Int, x: CGFloat, line: Int, standard: Bool) {
        let lineOffset = Double(getLineOffset(standard: standard) + line * getLineSpacing(standard: standard));
        
        // lead label will be written slightly above the ecg signal base
        var linePosition : CGFloat = CGFloat(lineOffset - (standard ? 200 : 100));
        
        // horizontal position for label
        var x_position = x * x_scale + (standard ? 40 : 40);
        switch lead {
        case 1:
            linePosition = 615
        case 2:
            linePosition = 615 - 90
        case 8:
            linePosition = 615 - 90 * 2
        case 9:
            linePosition = 615 - 90 * 3
        case 10:
            linePosition = 615 - 90 * 4
        case 11:
            linePosition = 615 - 90 * 5
        case 7:
            linePosition = 615 - 90 * 6
        case 3:
            linePosition = 615 - 90 * 7
        case 4:
            linePosition = 615 - 90 * 8
        case 5:
            linePosition = 615 - 90 * 9
        case 6:
            linePosition = 615 - 90 * 10
        case 0:
            linePosition = 615 - 90 * 11
        default:
            linePosition = 42
        }
        
        switch lead {
        case 2, 1 , 8 , 9 , 10, 11 , 7, 3, 4, 5, 6, 0:
            x_position = 45
        default:
            x_position = 0
        }
        
        let label = UILabel(frame: CGRect(x: transh(x: CGFloat(x_position)) , y: transv(x: CGFloat(linePosition)) , width: 60, height: 40))
        self.addSubview(label)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = DataUtils.getLeadText(lead: lead)
    }
    
    func drawPulseRhythm( line: Double, standard: Bool) {
        let lineOffset : Double = 3//Double(getLineOffset(standard: standard) + line * getLineSpacing(standard: standard));
        var y : Double = 530
        switch line {
        case 0:
            y = 532
        case 1:
            y = 530 - 88
        case 2:
            y = 530 - 90 * 2
        case 3:
            y = 530 - 90 * 3
        case 4:
            y = 530 - 90 * 4
        case 5:
            y = 530 - 90 * 5
        case 6:
            y = 530 - 90.5 * 6
        case 7:
            y = 530 - 90.5 * 7
        case 8:
            y = 530 - 90.5 * 8
        case 9:
            y = 530 - 90.5 * 9
        case 10:
            y = 530 - 90.5 * 10
        case 11:
            y = 530 - 90.5 * 11
        case 12:
            y = 530 - 90.5 * 12
        case 13:
            y = 530 - 90.5 * 13
        default:
            y = 530 - 90 * 14
        }
        let pulseHeight : Double = standard ? 2 : 1;
        
        var y2 : Double = Double(y) + 30 / pulseHeight
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: transh(x: 0) , y: transv(x: CGFloat(y))))
        aPath.addLine(to: CGPoint(x:transh(x: 10), y: transv(x: CGFloat(y))))
        aPath.stroke()
        aPath.move(to: CGPoint(x: transh(x: 10) , y: transv(x: CGFloat(y))))
        aPath.addLine(to: CGPoint(x:transh(x: 10), y: transv(x: CGFloat(y2))))
        aPath.stroke()
        aPath.move(to: CGPoint(x: transh(x: 10) , y: transv(x: CGFloat(y2))))
        aPath.addLine(to: CGPoint(x:transh(x: 25), y: transv(x: CGFloat(y2))))
        aPath.stroke()
        aPath.move(to: CGPoint(x: transh(x: 25) , y: transv(x: CGFloat(y2))))
        aPath.addLine(to: CGPoint(x:transh(x: 25), y: transv(x: CGFloat(y))))
        aPath.stroke()
        aPath.move(to: CGPoint(x: transh(x: 25) , y: transv(x: CGFloat(y))))
        aPath.addLine(to: CGPoint(x:transh(x: 35), y: transv(x: CGFloat(y))))
        aPath.stroke()
        //aPath.close()
        //If you want to fill it as well
        // aPath.fill()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = aPath.cgPath
        
        //change the fill color
        // shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 1
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func drawEcgLine(line: Int,_ lead: Int, x: CGFloat, val1: Double, val2: Double, standard: Bool) {
        let lineOffset = Double(getLineOffset(standard: standard) + line * getLineSpacing(standard: standard));
        let yScale : Double  = standard ? 60 : 3
        var y : Double = 0
        var xbonus : CGFloat = 51
        switch line {
        case 4:
            y = 410 - 60 * 4
        case 1:
            y = 410 - 60 * 4 * 2
        case 2:
            y = 410 - 60 * 4 * 3 - 12
        case 3:
            y = 410 - 60 * 4 * 4 + 10
        default:
            y = 410
        }
        switch lead {
        case 2, 1 , 8:
            xbonus = 52
        case 9, 10 , 11:
            xbonus = 242
        case 3, 7 , 4:
            xbonus = 432
        case 5, 6 , 0:
            xbonus = 612
        default:
            xbonus = 0
        }
        
        
        let x1 = x * 0.075 + xbonus ;
        let x2 = (x1 + 0.05) ;
        
        y = y + 25
        y = (10 * val1) + y
        let y2 = (10 * val2) + y
        
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: transh(x: x1) , y: transv(x: CGFloat(y))))
        
        aPath.addLine(to: CGPoint(x:transh(x: x2), y: transv(x: CGFloat(y2))))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = aPath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 0.5
        
        self.layer.addSublayer(shapeLayer)
    }
    
    // draws the ecg tracing by joining two points
    func drawEcgLineRhythm(line: Int, x: CGFloat, val1: Double, val2: Double, standard: Bool) {
//        let lineOffset = Double(getLineOffset(standard: standard) + line * getLineSpacing(standard: standard));
//        let yScale : Double  = standard ? 60 : 30;
        
        let x1 = x * 0.3175 + 51 ;
        let x2 = (x1 + 0.0000001) ;
        var y : Double = 0
        switch line {
        case 0:
            y = 532
        case 1:
            y = 530 - 88
        case 2:
            y = 530 - 90 * 2
        case 3:
            y = 530 - 90 * 3
        case 4:
            y = 530 - 90 * 4
        case 5:
            y = 530 - 90 * 5
        case 6:
            y = 530 - 90.5 * 6
        case 7:
            y = 530 - 90.5 * 7
        case 8:
            y = 530 - 90.5 * 8
        case 9:
            y = 530 - 90.5 * 9
        case 10:
            y = 530 - 90.5 * 10
        case 11:
            y = 530 - 90.5 * 11
        case 12:
            y = 530 - 90.5 * 12
        case 13:
            y = 530 - 90.5 * 13
        default:
            y = 530 - 90 * 14
        }
        var drawMakerX : CGFloat = 0
        var drawMakerY : CGFloat = 0
        
        drawMakerY = CGFloat(y + 82)
        y = (10 * val1) + y
        let y2 = (10 * val2) + y
        
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: transh(x: x1) , y: transv(x: CGFloat(y))))
        
        aPath.addLine(to: CGPoint(x:transh(x: x2), y: transv(x: CGFloat(y2))))
        
        drawMakerX = 835
        
        aPath.move(to: CGPoint(x: transh(x: drawMakerX) , y: transv(x: CGFloat(drawMakerY - 60))))
        
        aPath.addLine(to: CGPoint(x:transh(x: drawMakerX), y: transv(x: CGFloat(drawMakerY - 80))))
        
        aPath.move(to: CGPoint(x: transh(x: drawMakerX) , y: transv(x: CGFloat(drawMakerY - 90))))
        
        aPath.addLine(to: CGPoint(x:transh(x: drawMakerX), y: transv(x: CGFloat(drawMakerY - 110))))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = aPath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 0.5
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    func drawPeakVals( lead: Int, x: CGFloat, line: Int, standard: Bool) {
        let lineOffset = Double(getLineOffset(standard: standard) + line * getLineSpacing(standard: standard));
        
        // lead label will be written slightly above the ecg signal base
        var linePosition : CGFloat = CGFloat(lineOffset - (standard ? 200 : 100));
        
        // horizontal position for label
        var x_position = x * x_scale + (standard ? 40 : 40);
        
        var drawMakerX : CGFloat = 0
        var drawMakerY : CGFloat = 0
        switch lead {
        case 1,7,5, 9:
            linePosition = 535
        case 2,10,3,6:
            linePosition = 293
        case 11,4,8,0:
            linePosition = 50
        default:
            linePosition = 42
        }
        drawMakerY = linePosition - 5
        switch lead {
        case 2, 1 , 8:
            drawMakerX = 240
            x_position = 50
        case 9, 10 , 11:
            drawMakerX = 430
            x_position = 240
        case 3, 7 , 4:
            drawMakerX = 610
            x_position = 430
        case 5, 6 , 0:
            drawMakerX = 790
            x_position = 610
        default:
            x_position = 0
        }
        let label = UILabel(frame: CGRect(x: transh(x: CGFloat(x_position)) , y: transv(x: CGFloat(linePosition)) , width: 60, height: 40))
        self.addSubview(label)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = DataUtils.getLeadText(lead: lead)
        
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: transh(x: drawMakerX) , y: transv(x: CGFloat(drawMakerY - 60))))
        
        aPath.addLine(to: CGPoint(x:transh(x: drawMakerX), y: transv(x: CGFloat(drawMakerY - 80))))
        
        aPath.move(to: CGPoint(x: transh(x: drawMakerX) , y: transv(x: CGFloat(drawMakerY - 90))))
        
        aPath.addLine(to: CGPoint(x:transh(x: drawMakerX), y: transv(x: CGFloat(drawMakerY - 110))))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = aPath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 0.5
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func writeLeadLabel( lead: Int, x: CGFloat, line: Int, standard: Bool) {
        let lineOffset = Double(getLineOffset(standard: standard) + line * getLineSpacing(standard: standard));
        
        // lead label will be written slightly above the ecg signal base
        var linePosition : CGFloat = CGFloat(lineOffset - (standard ? 200 : 100));
        
        // horizontal position for label
        var x_position = x * x_scale + (standard ? 40 : 40);
        
        var drawMakerX : CGFloat = 0
        var drawMakerY : CGFloat = 0
        switch lead {
        case 1,7,5, 9:
            linePosition = 535
        case 2,10,3,6:
            linePosition = 293
        case 11,4,8,0:
            linePosition = 50
        default:
            linePosition = 42
        }
        drawMakerY = linePosition - 5
        switch lead {
        case 2, 1 , 8:
            drawMakerX = 240
            x_position = 50
        case 9, 10 , 11:
            drawMakerX = 430
            x_position = 240
        case 3, 7 , 4:
            drawMakerX = 610
            x_position = 430
        case 5, 6 , 0:
            drawMakerX = 790
            x_position = 610
        default:
            x_position = 0
        }
        let label = UILabel(frame: CGRect(x: transh(x: CGFloat(x_position)) , y: transv(x: CGFloat(linePosition)) , width: 60, height: 40))
        self.addSubview(label)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = DataUtils.getLeadText(lead: lead)
        
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: transh(x: drawMakerX) , y: transv(x: CGFloat(drawMakerY - 60))))
        
        aPath.addLine(to: CGPoint(x:transh(x: drawMakerX), y: transv(x: CGFloat(drawMakerY - 80))))
        
        aPath.move(to: CGPoint(x: transh(x: drawMakerX) , y: transv(x: CGFloat(drawMakerY - 90))))
        
        aPath.addLine(to: CGPoint(x:transh(x: drawMakerX), y: transv(x: CGFloat(drawMakerY - 110))))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = aPath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 0.5
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func drawPulse(_ context: UIGraphicsPDFRendererContext, line: Double, standard: Bool) {
        let lineOffset : Double = 3//Double(getLineOffset(standard: standard) + line * getLineSpacing(standard: standard));
        context.cgContext.setLineWidth(1)//(0.5);
        
        var y : Double = 0
        switch line {
        case 0:
            y = 235
        case 1:
            y = 235 - 37 * 7
        case 2:
            y = 235 - 36 * 16
        case 3:
            y = 235 - 37.1 * 24
        default:
            y = 160 + (42 * 3)
        }
        let pulseHeight : Double = standard ? 2 : 1;
        var y2 : Double = Double(y) + 125 / pulseHeight
        let aPath = context.cgContext
        aPath.move(to: CGPoint(x: transh(x: 45) , y: transv(x: CGFloat(y))))
        aPath.addLine(to: CGPoint(x:transh(x: 55), y: transv(x: CGFloat(y))))
        aPath.move(to: CGPoint(x: transh(x: 55) , y: transv(x: CGFloat(y))))
        aPath.addLine(to: CGPoint(x:transh(x: 55), y: transv(x: CGFloat(y2))))
        aPath.move(to: CGPoint(x: transh(x: 42 + 14) , y: transv(x: CGFloat(y2))))
        aPath.addLine(to: CGPoint(x:transh(x: 56 + 16), y: transv(x: CGFloat(y2))))
        aPath.move(to: CGPoint(x: transh(x: 56 + 16) , y: transv(x: CGFloat(y2))))
        aPath.addLine(to: CGPoint(x:transh(x: 56 + 16), y: transv(x: CGFloat(y))))
        aPath.move(to: CGPoint(x: transh(x: 56 + 16) , y: transv(x: CGFloat(y))))
        aPath.addLine(to: CGPoint(x:transh(x: 66 + 16), y: transv(x: CGFloat(y))))
        
        aPath.move(to: CGPoint(x: transh(x: 928) , y: transv(x: CGFloat(y + 5))))
        aPath.addLine(to: CGPoint(x:transh(x: 928), y: transv(x: CGFloat(y + 30))))
        aPath.move(to: CGPoint(x: transh(x: 928) , y: transv(x: CGFloat(y - 5))))
        aPath.addLine(to: CGPoint(x:transh(x: 928), y: transv(x: CGFloat(y - 30))))
        
        
        aPath.strokePath()
    }
    
    func drawPulsePage1(_ context: UIGraphicsPDFRendererContext) {
        context.cgContext.setLineWidth(1.5)//(0.5);
        let aPath = context.cgContext
        var line = 0
        var y : CGFloat = 0
        while line < 3 {
            switch line {
            case 0:
                y = 235
            case 1:
                y = -24
            case 2:
                y = -341
            default:
                y = 0
            }
            aPath.move(to: CGPoint(x: transh(x: 713) , y: transv(x: CGFloat(y + 5))))
            aPath.addLine(to: CGPoint(x:transh(x: 713), y: transv(x: CGFloat(y + 30))))
            aPath.move(to: CGPoint(x: transh(x: 713) , y: transv(x: CGFloat(y - 5))))
            aPath.addLine(to: CGPoint(x:transh(x: 713), y: transv(x: CGFloat(y - 30))))
            
            aPath.move(to: CGPoint(x: transh(x: 505) , y: transv(x: CGFloat(y + 5))))
            aPath.addLine(to: CGPoint(x:transh(x: 505), y: transv(x: CGFloat(y + 30))))
            aPath.move(to: CGPoint(x: transh(x: 505) , y: transv(x: CGFloat(y - 5))))
            aPath.addLine(to: CGPoint(x:transh(x: 505), y: transv(x: CGFloat(y - 30))))
            
            
            aPath.move(to: CGPoint(x: transh(x: 295) , y: transv(x: CGFloat(y + 5))))
            aPath.addLine(to: CGPoint(x:transh(x: 295), y: transv(x: CGFloat(y + 30))))
            aPath.move(to: CGPoint(x: transh(x: 295) , y: transv(x: CGFloat(y - 5))))
            aPath.addLine(to: CGPoint(x:transh(x: 295), y: transv(x: CGFloat(y - 30))))
            aPath.strokePath()
            line += 1
        }
        
        
    }
    
    
    func drawPulse2(_ context: UIGraphicsPDFRendererContext, line: Double, standard: Bool) {
       // let lineOffset : Double = 3//Double(getLineOffset(standard: standard) + line * getLineSpacing(standard: standard));
        context.cgContext.setLineWidth(0.5)//(0.5);
        
        var y : Double = 410
        switch line {
        case 0:
            y = 381
        case 1:
            y = 283
        case 2:
            y = 193
        case 3:
            y = 99
        case 4:
            y = 2
        case 5:
            y = -93
        case 6:
            y = -192
        case 7:
            y = -287
        case 8:
            y = -386
        case 9:
            y = -475
        case 10:
            y = -570
        case 11:
            y = -670
            
        default:
            y = 175 + (42 * 3)
        }
        let pulseHeight : Double = standard ? 2 : 1;
        var y2 : Double = Double(y) + 63/2 / pulseHeight
        let aPath = context.cgContext
        aPath.move(to: CGPoint(x: transh(x: 45) , y: transv(x: CGFloat(y))))
        aPath.addLine(to: CGPoint(x:transh(x: 55), y: transv(x: CGFloat(y))))
        aPath.move(to: CGPoint(x: transh(x: 55) , y: transv(x: CGFloat(y))))
        aPath.addLine(to: CGPoint(x:transh(x: 55), y: transv(x: CGFloat(y2))))
        aPath.move(to: CGPoint(x: transh(x: 42 + 13) , y: transv(x: CGFloat(y2))))
        aPath.addLine(to: CGPoint(x:transh(x: 56 + 13), y: transv(x: CGFloat(y2))))
        aPath.move(to: CGPoint(x: transh(x: 56 + 13) , y: transv(x: CGFloat(y2))))
        aPath.addLine(to: CGPoint(x:transh(x: 56 + 13), y: transv(x: CGFloat(y))))
        aPath.move(to: CGPoint(x: transh(x: 56 + 13) , y: transv(x: CGFloat(y))))
        aPath.addLine(to: CGPoint(x:transh(x: 66 + 13), y: transv(x: CGFloat(y))))
        aPath.move(to: CGPoint(x: transh(x: 928) , y: transv(x: CGFloat(y + 5))))
        aPath.addLine(to: CGPoint(x:transh(x: 928), y: transv(x: CGFloat(y + 30))))
        aPath.move(to: CGPoint(x: transh(x: 928) , y: transv(x: CGFloat(y - 5))))
        aPath.addLine(to: CGPoint(x:transh(x: 928), y: transv(x: CGFloat(y - 30))))
        aPath.strokePath()
    }
    // draws outlines/border in report
    func drawOutlines() {
        // Drawing the grid
        
        // Set the width of the grid lines
        
        let aPath = UIBezierPath()
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.lineWidth = 0.5
        
        let x_start : CGFloat = 90, x_end : CGFloat  = 1725, y_start : CGFloat  = 200, y_end : CGFloat  = 1185;
        
        aPath.move(to: CGPoint(x: transh(x: CGFloat(x_start)) , y: transv(x: x_end)))
        
        aPath.addLine(to: CGPoint(x:transh(x: CGFloat(x_start)), y: transv(x: y_end)))
        
        
        // right line
        aPath.move(to: CGPoint(x: transh(x: CGFloat(x_end)) , y: transv(x: y_start)))
        
        aPath.addLine(to: CGPoint(x:transh(x: CGFloat(x_end)), y: transv(x: y_end)))
        
        // top line
        
        aPath.move(to: CGPoint(x: transh(x: CGFloat(x_start)) , y: transv(x: y_start)))
        
        aPath.addLine(to: CGPoint(x:transh(x: CGFloat(x_end)), y: transv(x: y_start)))
        //If you want to fill it as well
        // bottom line
        
        
        aPath.move(to: CGPoint(x: transh(x: CGFloat(x_start)) , y: transv(x: y_end)))
        
        aPath.addLine(to: CGPoint(x:transh(x: CGFloat(x_end)), y: transv(x: y_end)))
        aPath.stroke()
        aPath.close()
        aPath.fill()
        
        shapeLayer.path = aPath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.black.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    // transh-method for correcting the horizontal values
    private func transh(x: CGFloat) -> CGFloat {
        return x * scalepdf * scalesite * corrh + offseth;
    }
    
    // transv-method for correcting the vertical values
    private func transv(x: CGFloat) -> CGFloat {
        return 300 - (x * scalepdf * scalesite * corrv + offsetv);
    }
    
    // transh-method for correcting the scaling values
    private func transr(x: CGFloat) -> CGFloat {
        return x * scalepdf * scalesite * 0.5 * (corrh + corrv);
    }
    
    private func getLineOffset( standard: Bool) -> Int{
        return standard ? 10 : 5;
    }
    
    private func getLineSpacing( standard: Bool) -> Int{
        return standard ? 10 : 3;
    }
}

func mergePdfFiles(sourcePdfFiles:[String]) {
    
    let pdfData = NSMutableData()
    let pdfPageFrame = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
    guard let destContext = UIGraphicsGetCurrentContext() else {
        return
    }
    
    for index in 0 ..< sourcePdfFiles.count {
        let pdfFile = sourcePdfFiles[index]
        let pdfUrl = NSURL(fileURLWithPath: pdfFile)
        guard let pdfRef = CGPDFDocument(pdfUrl) else {
            continue
        }
        
        for i in 1 ... pdfRef.numberOfPages {
            if let page = pdfRef.page(at: i) {
                var mediaBox = page.getBoxRect(.mediaBox)
                destContext.beginPage(mediaBox: &mediaBox)
                destContext.drawPDFPage(page)
                destContext.endPage()
            }
        }
    }
    
    destContext.closePDF()
    UIGraphicsEndPDFContext()
    //saveViewPdf(data: pdfData)
}

// Save pdf file in document directory
func saveViewPdf(data: Data) -> String{
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docDirectoryPath = paths[0]
    let pdfPath = docDirectoryPath.appendingPathComponent("viewPdf34.pdf")
    do{
        try? data.write(to: pdfPath)
        return pdfPath.path
    }catch{
        return ""
    }
}

/* how to use
 let pdfFilePath = self.view.exportAsPdfFromView()
 print(pdfFilePath)
 */
extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(self) / 180 * .pi }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self  / 180 * .pi}
    var radiansToDegrees: Self { return self * 180 / .pi }
}
