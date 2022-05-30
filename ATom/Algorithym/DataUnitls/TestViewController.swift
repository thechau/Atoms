//
//  TestViewController.swift
//  ECG_Project
//
//  Created by phan.the.chau on 7/22/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    let view1 =  Page1()
    let view2 = Page2()
    
    var pdfFilePath1 = ""
    var pdfFilePath2 = ""
    var startIndex = 0
    var qr = QrsDetection.init()
    var scalepdf : CGFloat = 0.9439104
    var scaleIOS : CGFloat = 0.5
    var corrh : CGFloat = 0.5
    var corrv : CGFloat = 0.5
    var scalesite : CGFloat = 1
    var offseth : CGFloat = -10
    let offsetv : CGFloat = 20;
    private var fg: CGFloat = 30// / 1.4 ;
    private var x_scale : CGFloat = (150) / (250);
    override func viewDidLoad() {
        super.viewDidLoad()
        //myCentralManager = CBCentralManager(delegate: self, queue: nil);
        DataUtils.resetStaticVariables()
        DataUtils.initDataBuffers()
        qr = QrsDetection.init(handler: self)
        getData()
    }
    
    fileprivate func getData(){
        
        let path = Bundle.main.path(forResource: "ecg_miBEAT", ofType: "txt")
        do
        {
            let contents = try String(contentsOfFile: path!)
            let listDataFromFileSample = contents.components(separatedBy: "\n")
            for i in 0...listDataFromFileSample.count - 2{
                if let val = Double(listDataFromFileSample[i]){
                    _ = qr.runPanTompkins(val)
                }
            }
            DataUtils.main()
            startIndex = PdfUtils.getStartIndex()
            let qrsStats = qr.getQrsStats(startIndex: startIndex)
            
            let pdfPageFrame = CGRect(x: 0, y: 0, width: 297 * 3, height: 210 * 3)
            let renderer = UIGraphicsPDFRenderer(bounds: pdfPageFrame)
            let leadata = PdfUtils.getLeadDatInCms()
            let pdf = renderer.pdfData { (cb) in
                cb.beginPage()
                self.setupPage(pageNumber: 1, cb: cb)
                self.writeReportPage1(cb, qrsStats)
                self.standardReport(cb,leadata)
                self.writeLeadLableStandardReport(cb)
                cb.beginPage()
                self.setupPage(pageNumber: 2, cb: cb)
                self.rhythmReport(cb, leadata)
                self.writeReportRhythm(cb, qrsStats)
                writeLeadLabelRhythm(cb)
                cb.beginPage()
                self.setupPage3(cb, leadata)
                writeReportPage3(cb, qrsStats)
                
            }
            let path = saveViewPdf(data: pdf)
            print(path)
        }
        catch
            
        {
            print("can not load file")
        }
    }
    

    func drawText(cb: UIGraphicsPDFRendererContext, point: CGPoint, font: UIFont, tilte: String){
        let pageNumberAttributes = [
            NSAttributedString.Key.font : font
        ]
        
        let nextPage = tilte as NSString
        let nextPageRect = point
        nextPage.draw(at: nextPageRect, withAttributes: pageNumberAttributes)
    }
    
    func writeLeadLableStandardReport(_ context: UIGraphicsPDFRendererContext) {
        var x : CGFloat = 0
        var y : CGFloat = 0
        var leadIndex = 0
        while leadIndex < 12 {
            switch DataUtils.ALL_LEADS[leadIndex] {
            case 1:
                x = 88
                y = 125
            case 2:
                x = 88
                y = 239
            case 3:
                x = 88
                y = 353 + 40
            case 4:
                x = 265
                y = 125
            case 5:
                x = 265
                y = 239
            case 6:
                x = 265
                y = 393
            case 7:
                x = 455
                y = 125
            case 8:
                x = 455
                y = 239
            case 9:
                x = 455
                y = 393
            case 10:
                x = 640
                y = 125
            case 11:
                x = 640
                y = 239
            case 12:
                x = 640
                y = 393
            default:
                x = 0
                y = 0
            }
            leadIndex += 1
            drawText(cb: context, point: CGPoint(x: x, y: y), font: UIFont.systemFont(ofSize: 15), tilte:"\(DataUtils.getLeadText(lead: leadIndex))")
            drawText(cb: context, point: CGPoint(x: 640, y: 393), font: UIFont.systemFont(ofSize: 14), tilte:"V6")
            drawText(cb: context, point: CGPoint(x: 88, y: 548), font: UIFont.systemFont(ofSize: 14), tilte:"II")


        }
    }
    
    func drawEcgLineStandard(_ cb : UIGraphicsPDFRendererContext,line: Int, x: CGFloat, val1: Double, val2: Double, standard: Bool, lead: Int) {
        // let lineOffset = Double(getLineOffset(standard: standard) + line * getLineSpacing(standard: standard));
        // var lineOffset = getLineOffset(standard) + line * getLineSpacing(standard);
        cb.cgContext.setLineWidth(1)
        let yScale : Double = standard ? 60 : 30;
        
        var y1 = (val1 * yScale) * 2.3;
        var y2 = (val2 * yScale) * 2.3;
        var y : Double = 0

        
//        var line2 = 0
        
//        var xtemp : CGFloat = CGFloat(625 * x_scale * CGFloat(line2))
//        switch lead {
//        case 1,2,8:
//            xtemp = 0
//            line2 = 0//y = 940 + 60 * 4// 844 + 200
//        case 9,10,11:
//            xtemp = 1
//            line2 = 1//y = 280 + 60
//        case 7,3,4:
//            xtemp = 140
//            line2 = 2//= 460 + 60 * 2
//        case 5,6,0:
//            xtemp = 300
//            line2 = 3// y = 700 + 60 * 3
//        default:
//            line2 = 0
//        }
//
        
        switch lead {
        case 1,9,7, 5:
            y = 280 + 60
        case 2,10,3,6:
            y = 460 + 60 * 2
        case 8,11,4,0:
            y = 700 + 60 * 3
        default:
            y += 940 + 60 * 4
        }
        
        
        y1 = y - y1
        y2 = y - y2
        let x1 = x * x_scale * 0.5 + 180;
        let x2 = (x + 1) * x_scale * 0.5 + 180;
        
        cb.cgContext.move(to: CGPoint(x: transh(x: x1) , y: transv(y: CGFloat(y1))))
        
        cb.cgContext.addLine(to: CGPoint(x:transh(x: x2), y: transv(y: CGFloat(y2))))
        cb.cgContext.strokePath()
    }
    var isdraw = false
    func drawPeak(_ cb : UIGraphicsPDFRendererContext,line: Int, x: CGFloat, value: String) {
        let y = 940 + 60 * 3 - 20
        let x1 = x * x_scale + 180;
        if !isdraw{
            isdraw = true
            drawText(cb: cb, point:  CGPoint(x: transh(x: x1) , y: transv(y: CGFloat(y))), font: UIFont.systemFont(ofSize: 8), tilte: value)
        }
    }
    
    func drawEcgLine(_ cb : UIGraphicsPDFRendererContext,line: Int, x: CGFloat, val1: Double, val2: Double, standard: Bool) {
        cb.cgContext.setStrokeColor(cyan: 0, magenta: 0, yellow: 0, black: 1, alpha: 1)
        cb.cgContext.setLineWidth(1)
        let yScale : Double = standard ? 60 : 30;
        var y1 = (val1 * yScale);
        var y2 = (val2 * yScale);
        let y : Double = Double(90 * (line + 1)) + 110
        let x1 = x * x_scale * 0.5 + 180;
        let x2 = (x + 1) * x_scale * 0.5 + 180;
        
        y1 = y - y1
        y2 = y - y2
        
        cb.cgContext.move(to: CGPoint(x: transh(x: x1) , y: transv(y: CGFloat(y1))))
        
        cb.cgContext.addLine(to: CGPoint(x:transh(x: x2), y: transv(y: CGFloat(y2))))
        cb.cgContext.strokePath()
    }
    
    func drawSlope(_ cb : UIGraphicsPDFRendererContext, x1: Double, y1: Double, radius: Double, angle: Double) {
        let radians = angle.degreesToRadians
        
        
        let A : (x: Double, y: Double) = (x1, y1)
        let B : (x: Double, y: Double) = (x1 + 135 + radius, y1)
        
        let x : Double = (B.x - A.x)*cos(radians) - (B.y - A.y)*sin(radians) + A.x
        let y : Double = ((B.x - A.x)*sin(radians) - (B.y - A.y)*cos(radians)) + B.y
        drawLine(cb, from: CGPoint(x: x1, y: y1), to: CGPoint(x: x, y: y))
    }
    
    var standardReport : Bool = true
    var rhythmReport : Bool = false
    var vectorCardiogram : Bool = false
    
    func drawLine(_ cb : UIGraphicsPDFRendererContext, from: CGPoint, to: CGPoint ){
        cb.cgContext.move(to: to)
        cb.cgContext.addLine(to: from)
        cb.cgContext.strokePath()
    }
    
    private func transh(x: CGFloat) -> CGFloat {
        if x == 0 {
            return 0
        }
        return x * scaleIOS
    }
    
    // transv-method for correcting the vertical values
    private func transv(y: CGFloat) -> CGFloat {
        if y == 0 {
            return 0
        }
        return y * scaleIOS
    }
    
    // tyansh-method for correcting the scaling values
    private func transr(x: CGFloat) -> CGFloat {
        return x //* scalepdf * scalesite * 0.5 * (corrh + corrv);
    }
    
    private func getLineOffset( standard: Bool) -> Int{
        return standard ? 10 : 5;
    }
    
    private func getLineSpacing( standard: Bool) -> Int{
        return standard ? 10 : 3;
    }
}

extension TestViewController{
    private func setupPage(pageNumber: Int, cb: UIGraphicsPDFRendererContext) {
        // Drawing the grid
        // Set color to magenta
        cb.cgContext.setLineWidth(0.5)
        cb.cgContext.setStrokeColor(cyan: 0, magenta: 175, yellow: 0, black: 0, alpha: 0.5)
        let x_start : CGFloat = 90, x_end : CGFloat = 1710;
        let y_start : CGFloat = pageNumber == 1 ? 160 : 140
        let y_end : CGFloat = pageNumber == 1 ? 1215 : 1215
        // vertical grid-lines
        var i : CGFloat = x_start
        while i <= x_end {
            cb.cgContext.move(to: CGPoint(x: transh(x: i), y: transv(y: y_end)))
            cb.cgContext.addLine(to: CGPoint(x: transh(x: i ), y: transv(y: y_start)))
            cb.cgContext.strokePath()
            i += fg
        }
        //        // horizontal grid-lines
        //
        var y = y_start
        while y <= y_end{
            cb.cgContext.move(to: CGPoint(x: transh(x: x_start), y: transv(y: y)))
            cb.cgContext.addLine(to: CGPoint(x: transh(x: x_end), y: transv(y: y)))
            cb.cgContext.strokePath()
            y += fg
        }
        
        // Set line width for subsequent gridlines or curves
        
        cb.cgContext.setLineWidth(1)
        // vertical grid-lines
        var ii = x_start
        while ii <= x_end {
            cb.cgContext.move(to: CGPoint(x: transh(x: ii), y: transv(y: y_end)))
            cb.cgContext.addLine(to: CGPoint(x: transh(x: ii), y: transv(y: y_start)))
            cb.cgContext.strokePath()
            ii += fg * 2
        }
        
        // horizontal grid-lines
        
        var yy = y_start
        while yy <= y_end{
            cb.cgContext.move(to: CGPoint(x: transh(x: x_start), y: transv(y: yy)))
            cb.cgContext.addLine(to: CGPoint(x: transh(x: x_end), y: transv(y: yy)))
            cb.cgContext.strokePath()
            yy += fg * 2
        }
        
        
        // draw thin gridlines for 1 mm marks
        cb.cgContext.setLineWidth(0.1)
        
        // vertical grid-lines
        var iii = x_start
        while iii <= x_end {
            cb.cgContext.move(to: CGPoint(x: transh(x: iii), y: transv(y: y_end)))
            cb.cgContext.addLine(to: CGPoint(x: transh(x: iii), y: transv(y: y_start)))
            cb.cgContext.strokePath()
            iii += fg * 0.2
        }
        
        // horizontal grid-lines
        var yyy = y_start
        while yyy <= y_end{
            cb.cgContext.move(to: CGPoint(x: transh(x: x_start), y: transv(y: yyy)))
            cb.cgContext.addLine(to: CGPoint(x: transh(x: x_end), y: transv(y: yyy)))
            cb.cgContext.strokePath()
            yyy += fg * 0.2
        }
        
    }
    
    func writeLegend( cb : UIGraphicsPDFRendererContext) {
        let ftLabel = UIFont.systemFont(ofSize: 15, weight: .bold)// new Font(calibrib, 15);
        let ftVal = UIFont.systemFont(ofSize: 15, weight: .regular)//new Font(calibri, 15);
        let line = 1, offset = 600, spacing = 60;
        cb.cgContext.setStrokeColor(cyan: 0, magenta: 175, yellow: 0, black: 0, alpha: 0.5)
    }
    
    func drawCircle( cb: UIGraphicsPDFRendererContext, x: CGFloat, y: CGFloat, r: CGFloat) {
        cb.cgContext.addEllipse(in: CGRect(x: x, y: y, width: 30 * 3 * r, height: 30 * 3 * r))
        cb.cgContext.setLineDash(phase: 1, lengths: [2,2])
        cb.cgContext.strokePath()
    }
}

//MARK: page 1

extension TestViewController{
    func writeReportPage1(_ cb : UIGraphicsPDFRendererContext, _ qrsStats: QrsDetection.QrsStats){
        let xOfPatientInformation : CGFloat = 90
        let xOfLifestyle : CGFloat = xOfPatientInformation + 400
        let xOfRecordingDetails : CGFloat = xOfLifestyle + 200
        let xOfHospitalReference : CGFloat = xOfRecordingDetails + 220
        
        let generalY : CGFloat = 12
        let ftMainHeading = UIFont.boldSystemFont(ofSize: 17)//new Font(calibrib, 20);
        let ftLabel = UIFont.boldSystemFont(ofSize: 8)
        let ftLabel2 = UIFont.boldSystemFont(ofSize: 10)
        let ftArgsLabel = UIFont.systemFont(ofSize: 8)
        let headerText = standardReport || rhythmReport ? "ATOM ECG Report" : "ATOM Vector Cardiogram"
        let patientInformation = "Patient Information"
        let name = "Name"
        let sex = "Sex"
        let age = "Age"
        let height = "Height(cm)"
        let weight = "Weight(kg)"
        let bp = "BP : "
        
        
        let argsName = "Mohanlal"
        let argsSex = "M"
        let argsAge = "22 yrs"
        let argsHeight = "168"
        let argsWeight = "72"
        let argsBp = "130/90"
        
        let lifestyle = "Lifestyle"
        let activity = "Activity"
        let smoking = "Smoking"
        let drinking = "Drinking"
        
        let argsActivity = "Activity"
        let argsSmoking = "Smoking"
        let argsDrinking = "Drinking"
        
        let recordingDetails = "Recording Details"
        let date = "Date"
        let time = "Time"
        let location = "Location"
        
        let argsDate = "10.12.2018"
        let argsTime = "12:03:54 PM"
        let argsLocation = "Phc Barod"
        
        let hospitalReference = "Hospital Reference"
        let patientID = "Patient ID"
        let referredBy = "Referred By"
        let argsPatientID = "23311"
        let argsReferredBy = "Dr. PC Khandelwal"
        
        let comment = "Comment"
        let pageOf = "Page 1 of 3"
        let heartRate = "Heart Rate"
        let argsHeartRate = qrsStats.getAvgHeartRate()
        let rightBottomTitle = "Generated by ATOM © 2018 (Cardea Labs)"
        let freq = DataUtils.filterValue == 0 ? "None" : PdfUtils.FILTERS[DataUtils.filterValue];
        let notchVal = !DataUtils.notch ? "" : ", ~ 50 Hz";
        let filterText = "Filters: " + freq + notchVal;
        let leftBottomTitle = "Report # 23    Speed: 25 mm/sec    Amplitude: 10 mm/mV    \(filterText)    Baseline Suppression: Wavelets (dB4)"
        
        //Patient Information
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: generalY), font: ftMainHeading, tilte: headerText)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: 36), font: ftLabel2, tilte: patientInformation)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: 49), font: ftLabel, tilte: name)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: 58.5), font: ftLabel, tilte: sex)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: 68), font: ftLabel, tilte: age)
        
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 26.5 + 28), y: 49), font: ftLabel, tilte: ":")
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 26.5 + 28), y: 58), font: ftLabel, tilte: ":")
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 26.5 + 28), y: 67.5), font: ftLabel, tilte: ":")
        
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 31.5 + 30), y: 49), font: ftArgsLabel, tilte: argsName)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 31.5 + 30), y: 58.5), font: ftArgsLabel, tilte: argsSex)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 31.5 + 30), y: 68), font: ftArgsLabel, tilte: argsAge)
        
        
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 62 + 60), y: 58.5), font: ftLabel, tilte: height)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 62 + 60), y: 68), font: ftLabel, tilte: weight)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 113.5 + 107), y: 58), font: ftLabel, tilte: ":")
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 113.5 + 107), y: 67.5), font: ftLabel, tilte: ":")
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 118.5 + 111), y: 58.5), font: ftArgsLabel, tilte: argsHeight)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 118.5 + 111), y: 68), font: ftArgsLabel, tilte: argsWeight)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 140 + 140), y: 58.5), font: ftLabel, tilte: bp)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 158 + 160), y: 58.5), font: ftArgsLabel, tilte: argsBp)
        
        
        //Lifestyle
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfLifestyle), y: 36), font: ftLabel2, tilte: lifestyle)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfLifestyle), y: 49), font: ftLabel, tilte: activity)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfLifestyle), y: 58.5), font: ftLabel, tilte: smoking)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfLifestyle), y: 68), font: ftLabel, tilte: drinking)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfLifestyle + 75), y: 49), font: ftLabel, tilte: ":")
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfLifestyle + 75), y: 58), font: ftLabel, tilte: ":")
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfLifestyle + 75), y: 67.5), font: ftLabel, tilte: ":")
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfLifestyle + 85), y: 49), font: ftArgsLabel, tilte: argsActivity)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfLifestyle + 85), y: 58.5), font: ftArgsLabel, tilte: argsSmoking)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfLifestyle + 85), y: 68), font: ftArgsLabel, tilte: argsDrinking)
        
        //Recording Details
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfRecordingDetails), y: 36), font: ftLabel2, tilte: recordingDetails)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfRecordingDetails), y: 49), font: ftLabel, tilte: date)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfRecordingDetails), y: 58.5), font: ftLabel, tilte: time)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfRecordingDetails), y: 68), font: ftLabel, tilte: location)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfRecordingDetails + 40 + 35), y: 49), font: ftLabel, tilte: ":")
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfRecordingDetails + 40 + 35), y: 58), font: ftLabel, tilte: ":")
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfRecordingDetails + 40 + 35), y: 67.5), font: ftLabel, tilte: ":")
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfRecordingDetails + 44 + 40), y: 49), font: ftArgsLabel, tilte: argsDate)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfRecordingDetails + 44 + 40), y: 58.5), font: ftArgsLabel, tilte: argsTime)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfRecordingDetails + 44 + 40), y: 68), font: ftArgsLabel, tilte: argsLocation)
        
        //Hospital Reference
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfHospitalReference), y: 36), font: ftLabel2, tilte: hospitalReference)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfHospitalReference), y: 49), font: ftLabel, tilte: patientID)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfHospitalReference), y: 58.5), font: ftLabel, tilte: referredBy)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfHospitalReference + 54 + 50), y: 49), font: ftLabel, tilte: ":")
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfHospitalReference + 54 + 50), y: 58), font: ftLabel, tilte: ":")
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfHospitalReference + 58 + 55), y: 49), font: ftArgsLabel, tilte: argsPatientID)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfHospitalReference + 58 + 55), y: 58.5), font: ftArgsLabel, tilte: argsReferredBy)
        
        drawText(cb: cb, point: CGPoint(x: transh(x: 660 + 530), y: 35), font: ftLabel2, tilte: comment)
        drawText(cb: cb, point: CGPoint(x: transh(x: 878 + 730), y: 20), font: ftLabel2, tilte: pageOf)
        drawText(cb: cb, point: CGPoint(x: transh(x: 878 + 730), y: 35), font: ftLabel2, tilte: heartRate)
        drawText(cb: cb, point: CGPoint(x: transh(x: 878 + 730), y: 50), font: UIFont.boldSystemFont(ofSize: 20), tilte: "\(argsHeartRate)")
        
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: 615), font: UIFont.boldSystemFont(ofSize: 8), tilte: rightBottomTitle)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 610), y: 615), font: UIFont.boldSystemFont(ofSize: 8), tilte: leftBottomTitle)
    }
}

// MARK: Page 2

extension TestViewController{
    
    fileprivate func drawCommentBox(_ cb: UIGraphicsPDFRendererContext) {
        drawLine(cb, from: CGPoint(x: 630 - 35, y: 50), to: CGPoint(x: 800 - 35, y: 50))
        drawLine(cb, from: CGPoint(x: 630 - 35, y: 75), to: CGPoint(x: 800 - 35, y: 75))
        drawLine(cb, from: CGPoint(x: 630 - 35, y: 50), to: CGPoint(x: 630 - 35, y: 75))
        drawLine(cb, from: CGPoint(x: 800 - 35, y: 50), to: CGPoint(x: 800 - 35, y: 75))
    }
    func standardReport(_ cb : UIGraphicsPDFRendererContext,_ leadData: [[Double]]){
        drawCommentBox(cb)
        
        let dataLength  : Int = Int(Double(DataUtils.SAMPLING_RATE) * 2.5) - 22
        self.view1.chartView.drawPulsePage1(cb)
        for k in 0...3{
            self.view1.chartView.drawPulse(cb, line: Double(k), standard: true)
        }
        cb.cgContext.setStrokeColor(cyan: 0, magenta: 0, yellow: 0, black: 1, alpha: 1)
       // for line in 0..<DataUtils.STD_REPORT_LEADS.count{
        for line in 0..<3{
            var x = 0
            for leadindex in 0..<DataUtils.STD_REPORT_LEADS[line].count{
                let lead = DataUtils.STD_REPORT_LEADS[line][leadindex]
                for i in 0..<dataLength{
                    let val1 = leadData[lead][i]
                    let val2 = leadData[lead][i + 1]
                    drawEcgLineStandard(cb,line: Int(line), x: CGFloat(x), val1: val1, val2: val2, standard: false, lead: lead)
                    x += 1
                }
                x += 24
            }
        }
        let line2 = 3; // 4th row of ecg in the std report
        var x : Double = 0;
        // writeLeadLabel(cb, II, x, line, true);
        let dataLength2 : Double = Double(DataUtils.SAMPLING_RATE * 10 - 22); // -22 for spacing between end marker

        // draw lead II ecg with peak values
        let peak = qr.getQrsStats(startIndex: startIndex).getPeaks();

        var ii = 0
        while x < dataLength2 {
            let val1 = leadData[DataUtils.II][ii];
            let val2 = leadData[DataUtils.II][ii + 1];
            drawEcgLineStandard(cb,line: Int(line2), x: CGFloat(x), val1: val1, val2: val2, standard: false, lead: 13)
            if(peak.get(ii) != 0){
                drawPeak(cb, line: line2, x: CGFloat(x), value: "\(peak.get(ii))")
            }
            ii += 1
            x += 1
        }
        
//        let dataLength  : Double = Double(DataUtils.SAMPLING_RATE) * 2.5 - 22
//        var line : Double = 0
//        var leadIndex = 0
//        var lead = 0
//        self.view1.chartView.drawPulsePage1(cb)
//        cb.cgContext.setStrokeColor(cyan: 0, magenta: 0, yellow: 0, black: 1, alpha: 1)
//        while line < 4 {
//            self.view1.chartView.drawPulse(cb, line: line, standard: true)
//            for i in 0..<4{
//                for j in 0..<Int(dataLength){
//                    switch lead {
//                    case 0:
//                        leadIndex = 2
//                    case 1:
//                        leadIndex = 1
//                    case 2:
//                        leadIndex = 8
//                    case 3:
//                        leadIndex = 9
//                    case 4:
//                        leadIndex = 10
//                    case 5:
//                        leadIndex = 11
//                    case 6:
//                        leadIndex = 3
//                    case 7:
//                        leadIndex = 7
//                    case 8:
//                        leadIndex = 4
//                    case 9:
//                        leadIndex = 5
//                    case 10:
//                        leadIndex = 6
//                    case 11:
//                        leadIndex = 0
//                    default:
//                        leadIndex = 0
//                    }
//                    let val1 = leadData[DataUtils.ALL_LEADS[leadIndex]][j]
//                    let val2 = leadData[DataUtils.ALL_LEADS[leadIndex]][j + 1]
//
//                    drawEcgLineStandard(cb,line: Int(line), x: CGFloat(j), val1: val1, val2: val2, standard: false, lead: leadIndex)
//                }
//                lead += 1
//            }
//            line += 1
//        }
//        let line2 = 3; // 4th row of ecg in the std report
//        var x : Double = 0;
//        // writeLeadLabel(cb, II, x, line, true);
//        let dataLength2 : Double = Double(DataUtils.SAMPLING_RATE * 10 - 22); // -22 for spacing between end marker
//
//        // draw lead II ecg with peak values
//        let peak = qr.getQrsStats(startIndex: startIndex).getPeaks();
//        leadIndex = 13
//        var ii = 0
//        while x < dataLength2 {
//            let val1 = leadData[DataUtils.II][ii];
//            let val2 = leadData[DataUtils.II][ii + 1];
//            drawEcgLineStandard(cb,line: Int(line2), x: CGFloat(x), val1: val1, val2: val2, standard: false, lead: leadIndex)
//            if(peak.get(ii) != 0){
//                drawPeak(cb, line: line2, x: CGFloat(x), value: "\(peak.get(ii))")
//            }
//            ii += 1
//            x += 1
//        }
    }
    
    func writeLeadLabelRhythm(_ context: UIGraphicsPDFRendererContext) {
        var x : CGFloat = 0
        var y : CGFloat = 0
        var leadIndex = 0
        while leadIndex < 12 {
            switch DataUtils.ALL_LEADS[leadIndex] {
//            case 0:
//                x = 87
//                y = 532
            case 1:
                x = 87
                y = 72
            case 2:
                x = 87
                y = 114
            case 3:
                x = 87
                y = 160
            case 4:
                x = 87
                y = 205
            case 5:
                x = 87
                y = 250
            case 6:
                x = 87
                y = 295
            case 7:
                x = 87
                y = 340
            case 8:
                x = 87
                y = 386
            case 9:
                x = 87
                y = 430
            case 10:
                x = 87
                y = 476
            case 11:
                x = 87
                y = 522
 
            default:
                x = 87
                y = 560
            }
            leadIndex += 1
            drawText(cb: context, point: CGPoint(x: x, y: y), font: UIFont.systemFont(ofSize: 14), tilte:"\(DataUtils.getLeadText(lead: leadIndex))")
            drawText(cb: context, point: CGPoint(x: 87, y: 565), font: UIFont.systemFont(ofSize: 13), tilte:"V6")

        }
    }
    
    func writeReportRhythm(_ cb : UIGraphicsPDFRendererContext, _ qrsStats: QrsDetection.QrsStats){
        //        var lineSpacing : CGFloat = 20;
        //        var topLinePos : CGFloat = 0;
        let xOfPatientInformation : CGFloat = 90
        let generalY : CGFloat = 12
        var ftMainHeading = UIFont.boldSystemFont(ofSize: 17)//new Font(calibrib, 20);
        let ftLabel = UIFont.boldSystemFont(ofSize: 8)
        let ftLabel2 = UIFont.boldSystemFont(ofSize: 10)
        let ftArgsLabel = UIFont.systemFont(ofSize: 8)
        var headerTextPage2 = "Rhythm Report"
        let pageOf = "Page 2 of 3"
        let rightBottomTitle = "Generated by ATOM © 2018 (Cardea Labs)"
        let speed = "Speed :"
        let amplitude = "Amplitude :"
        let baselineSuppression = "Baseline Suppression :"
        
        let argsSpeed = "25 mm/sec"
        let argsAmplitude = "5 mm/mV"
        let argsBaselineSuppression = "Wavelets (dB4)"
        
        //PAGE 2
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: generalY), font: ftMainHeading, tilte: headerTextPage2)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: 36), font: ftLabel, tilte: speed)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: 45.5), font: ftLabel, tilte: amplitude)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: 55), font: ftLabel, tilte: baselineSuppression)
        
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 200), y: 36), font: ftArgsLabel, tilte: argsSpeed)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 200), y: 45.5), font: ftArgsLabel, tilte: argsAmplitude)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation + 200), y: 55), font: ftArgsLabel, tilte: argsBaselineSuppression)
        
        drawText(cb: cb, point: CGPoint(x: transh(x: 878 + 730), y: 20), font: ftLabel2, tilte: pageOf)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: 615), font: UIFont.boldSystemFont(ofSize: 8), tilte: rightBottomTitle)
        
        
    }
    
    func rhythmReport(_ cb : UIGraphicsPDFRendererContext, _ leadData: [[Double]]){
        let dataLength = DataUtils.SAMPLING_RATE * 10 - 22
        var line : Double = 0
        var leadIndex = 0
        while leadIndex < DataUtils.NUM_LEADS {
            var i = 0
            var x = 0
            while i < DataUtils.SAMPLING_RATE * 10 && x < dataLength{
                view2.chartView.drawPulse2(cb, line: line, standard: false)

                let val1 = leadData[DataUtils.ALL_LEADS[leadIndex]][i]
                let val2 = leadData[DataUtils.ALL_LEADS[leadIndex]][i + 1]
                drawEcgLine(cb,line: Int(line), x: CGFloat(x), val1: val1, val2: val2, standard: false)
                i += 1
                x += 1
            }
            x += 12
            line += 1
            leadIndex += 1
        }
    }
}

//Mark: Page 3
extension TestViewController{
    fileprivate func setupPage3(_ cb: UIGraphicsPDFRendererContext, _ leadData: [[Double]]) {
        var radius = 1.5
        self.drawLine(cb, from: CGPoint(x: 36, y: 100), to: CGPoint(x: 860, y: 100))
        self.drawLine(cb, from: CGPoint(x: 860, y: 600), to: CGPoint(x: 860, y: 100))
        self.drawLine(cb, from: CGPoint(x: 36, y: 600), to: CGPoint(x: 36, y: 100))
        self.drawLine(cb, from: CGPoint(x: 860, y: 600), to: CGPoint(x: 36, y: 600))
        self.drawCircle(cb: cb, x: 200, y: 300, r: 1) // 90 * r
        self.drawCircle(cb: cb, x: 200 - 45, y: 300 - 45, r: 2) // 90 * r
        self.drawCircle(cb: cb, x: 200 - 90, y: 300 - 90, r: 3)
        radius = 0
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: 3, angle: 0)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: 3, angle: 90)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: 3, angle: 30)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: 60)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: 120)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: 150)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: 180)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: -90)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: -150)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: -120)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: -60)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: -30)
        cb.cgContext.setLineDash(phase: 0, lengths: [100,0])
        radius += 20
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: -30)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: 90)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: 180)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: -90)
        self.drawSlope(cb, x1: 200 + 45, y1: 300 + 45, radius: radius, angle: -150)
        
        let dataLength = DataUtils.SAMPLING_RATE * 10 - 22;
        cb.cgContext.setLineWidth(0.5)
        for i in 0..<dataLength{
            let x1 = leadData[DataUtils.I][i] * 60 * 3.5 * Double(scalepdf)
            let x2 = leadData[DataUtils.I][i + 1] * 60 * 3.5 * Double(scalepdf)
            let y1 = leadData[DataUtils.aVF][i] * 60 * 3.5 * Double(scalepdf)
            let y2 = leadData[DataUtils.aVF][i + 1] * 60 * 3.5 * Double(scalepdf)
            //
            self.drawLine(cb,
                          from: CGPoint(x: transh(x: CGFloat(x1)) + 245,
                                        y: transv(y: CGFloat(y1)) + 345) ,
                          to: CGPoint(x: transh(x: CGFloat(x2)) + 245,
                                      y: transv(y: CGFloat(y2)) + 345))
        }
    }
    
    func writeReportPage3(_ cb : UIGraphicsPDFRendererContext, _ qrsStats: QrsDetection.QrsStats){
        //        var lineSpacing : CGFloat = 20;
        //        var topLinePos : CGFloat = 0;
        let xOfPatientInformation : CGFloat = 90
        let generalY : CGFloat = 12
        var ftMainHeading = UIFont.boldSystemFont(ofSize: 17)//new Font(calibrib, 20);
        let ftLabel = UIFont.boldSystemFont(ofSize: 14)
        let ftLabel2 = UIFont.boldSystemFont(ofSize: 10)
        
        let ftArgsLabel = UIFont.systemFont(ofSize: 14)
        let rightBottomTitle = "Generated by ATOM © 2018 (Cardea Labs)"

        let normalAxis = "Normal Axis"
        let leftAxisDeviation = "Left Axis Deviation"
        let rightAxisDeviation = "Right Axis Deviation"
        let extremeAxisDeviation = "Extreme Axis Deviation"
        var headerTextPage3 = "Vector Cardiogram"
        let pageOf = "Page 3 of 3"
        
        let text1 = "QRS axis between -30° and +90°"
        let text2 = "QRS axis less than -30°"
        let text3 = "QRS axis greater than +90°"
        let text4 = "QRS axis between -90° and 180°"
        
        let corner = "-90°"
        let corner90 = "+90°"
        let corner30 = "-30°"
        let corner0 = "0°"
        let corner150 = "-150°"
        let corner180 = "180°"
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: generalY + 25), font: ftMainHeading, tilte: headerTextPage3)
        
        drawText(cb: cb, point: CGPoint(x: transh(x: 1010), y: 310), font: ftLabel, tilte: normalAxis)
        drawText(cb: cb, point: CGPoint(x: transh(x: 920), y: 330), font: ftLabel, tilte: leftAxisDeviation)
        drawText(cb: cb, point: CGPoint(x: transh(x: 902), y: 350), font: ftLabel, tilte: rightAxisDeviation)
        drawText(cb: cb, point: CGPoint(x: transh(x: 861), y: 370), font: ftLabel, tilte: extremeAxisDeviation)
        
        drawText(cb: cb, point: CGPoint(x: transh(x: 1000 + 200), y: 310), font: ftLabel, tilte: "=")
        drawText(cb: cb, point: CGPoint(x: transh(x: 1000 + 200), y: 330), font: ftLabel, tilte: "=")
        drawText(cb: cb, point: CGPoint(x: transh(x: 1000 + 200), y: 350), font: ftLabel, tilte: "=")
        drawText(cb: cb, point: CGPoint(x: transh(x: 1000 + 200), y: 370), font: ftLabel, tilte: "=")
        
        drawText(cb: cb, point: CGPoint(x: transh(x: 1230), y: 310), font: ftArgsLabel, tilte: text1)
        drawText(cb: cb, point: CGPoint(x: transh(x: 1230), y: 330), font: ftArgsLabel, tilte: text2)
        drawText(cb: cb, point: CGPoint(x: transh(x: 1230), y: 350), font: ftArgsLabel, tilte: text3)
        drawText(cb: cb, point: CGPoint(x: transh(x: 1230), y: 370), font: ftArgsLabel, tilte: text4)
        
        drawText(cb: cb, point: CGPoint(x: transh(x: 878 + 700), y: 20), font: ftLabel2, tilte: pageOf)
        
        drawText(cb: cb, point: CGPoint(x: transh(x: 460), y: 170), font: ftLabel, tilte: corner)
        drawText(cb: cb, point: CGPoint(x: transh(x: 460), y: 500), font: ftLabel, tilte: corner90)
        drawText(cb: cb, point: CGPoint(x: transh(x: 100), y: 335), font: ftLabel, tilte: corner180)
        drawText(cb: cb, point: CGPoint(x: transh(x: 140), y: 245), font: ftLabel, tilte: corner150)
        drawText(cb: cb, point: CGPoint(x: transh(x: 780), y: 245), font: ftLabel, tilte: corner30)
        drawText(cb: cb, point: CGPoint(x: transh(x: 800), y: 335), font: ftLabel, tilte: corner0)
        drawText(cb: cb, point: CGPoint(x: transh(x: xOfPatientInformation), y: 615), font: UIFont.boldSystemFont(ofSize: 8), tilte: rightBottomTitle)


    }
}

extension TestViewController: Handle{
    func updateData() {
        // print("asfhiosdhfoho")
    }
}
