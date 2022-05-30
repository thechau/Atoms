//
//  PanTompkins.swift
//  ECG_Project
//
//  Created by Châu Phan Thế on 6/3/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
public class PanTompkins:LmeFilter{
    public static var TOTAL_DELAY:Int = 24
    final var qrsDetection:QrsDetection!
    /** LOW-PASS filter */
    private let lp_a:[Double] = [1, 2, -1]
    private let lp_b:[Double] = [0.03125, 0, 0, 0, 0, 0, -0.0625, 0, 0, 0, 0, 0, 0.03125]
    private var lowpass:LmeFilter!// = LmeFilter(lp_b, lb_a)
    
    /** HIGH-PASS filter */
    private let hp_a:[Double] = [1,1]
    private let hp_b:[Double] = [-0.03125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.03125]
    private var highpass:LmeFilter! //= LmeFilter(hp_b, hp_a)
    
    /** DIFF filter */
    private let diff_a:[Double] = [8.0]
    private let diff_b:[Double] = [2,1,0,-1,-2]
    private var diff:LmeFilter!// = LmeFilter(diff_b, diff_a)
    
    private var wndInt:WndIntFilter!
    private var wndMean:MeanFilter!
    /** sampling time in ms */
    private var samplingTime:Float!
    /** amount of samples to copy pre R */
    private var preSegment:Int!
    /** samples to copy post R */
    private var postSegment:Int!
    private var rPassNum:Int = 0
    
    init(qrsDetection: QrsDetection){
        super.init()
        do{
            lowpass = try LmeFilter(lp_b, lp_a)
            highpass = try LmeFilter(hp_b, hp_a)
            diff = try LmeFilter(diff_b, diff_a)
        }catch{
            print("what's happend????")
        }
        QRS.resetStaticVariables()  // clean slate
        self.qrsDetection = qrsDetection
        samplingTime = Float(1000 / QrsDetection.QRS_SAMPLING_RATE)
        /* length of the integrator window */
        let wndLength = (Int) (150 * QrsDetection.QRS_SAMPLING_RATE / 1000)
        
        preSegment = (Int) (120 * QrsDetection.QRS_SAMPLING_RATE / 1000)
        postSegment = (Int) (280 * QrsDetection.QRS_SAMPLING_RATE / 1000)
        
        // buffer for historic values, MUST be > wndLength + filterDelay
        /* relative time counter since creation of self instance */
        var maxQrsSize = preSegment + postSegment
        if (maxQrsSize < wndLength + PanTompkins.TOTAL_DELAY + 2){
            maxQrsSize = wndLength + PanTompkins.TOTAL_DELAY + 2
        }
        
        // window integrator width proposed by Pan&Tompkins, 150ms, that is 30 samples @ 200 Hz
        wndInt = WndIntFilter(wndLength: wndLength)
        
        // mean of the wnd integrator output over 150 ms
        wndMean = MeanFilter(maxQrsSize)
        
        bandOut =  StepHistory(size: maxQrsSize)
        intOut =  StepHistory(size: maxQrsSize)
        
        // init qrs history
        for i in 0...qrsHistory.sizeMax - 1
        {
            qrsHistory.values[ i ] = QRS(size: maxQrsSize)
        }
        
        QRS.template1 =  QRS(size: maxQrsSize)
        QRS.template2 =  QRS(size: maxQrsSize)
        
        QRS.qrsCurrent = qrsHistory.next() as? PanTompkins.QRS
        QRS.qrsCurrent!.reset()
        
        QRS.qrsPrevious = nil
        
        // start processing after 2 seconds
        startProcessing = QrsDetection.QRS_SAMPLING_RATE << 1
        
        // x =   double[ 16 ]
        //MARK: ???
        y = [Double](repeating: 0, count: 12)
        
        beatCounter = 0
    }
    
    final class QRS{
        /** Segmentation state of self QRS */
        public var segState = SegmentationStatus.INVALID
        /** Timestamp of the R-deflection in milliseconds */
        var rTimestamp:Double = -1
        var qAmplitude:Double!
        var qIdx:Int = -1
        var rAmplitude:Double!
        var rIdx:Int = -1
        var sAmplitude:Double!
        var sIdx:Int = -1
        /** mean value of all values */
        var mean:Double = 0
        /** QRS width in milliseconds */
        var feat_width:Double!
        /** R-R interval to last QRS in milliseconds */
        var feat_rr:Double = 0
        /** QRA amplitude, currently not used */
        var feat_qra,feat_rsa:Double!
        /** area total */
        var feat_qrsta:Double!
        /** CC normalized to templates */
        var feat_cct1, feat_cct2: Double!
        /** ArDiff to templates */
        var feat_arT1diff, feat_arT2diff :Double!
        
        var classification:QrsClass = QrsClass.INVALID
        var arrhythmia:QrsArrhythmia = QrsArrhythmia.NORMAL_RHYTHM
        /** qrs from filtered signal */
        var values:FloatValueList!
        /** Static reference to the template slot 1 */
        static var template1:QRS? = nil
        /** Static reference to the template slot 2 */
        static var template2:QRS? = nil
        /** Static reference to the current QRS */
        static var qrsCurrent:QRS? = nil
        /** Static reference to the previous QRS */
        static var qrsPrevious:QRS? = nil
        
        static func resetStaticVariables(){
            PanTompkins.QRS.template1 = nil
            PanTompkins.QRS.template2 = nil
            PanTompkins.QRS.qrsCurrent = nil
            PanTompkins.QRS.qrsPrevious = nil
        }
        
        init() {
            
        }
        
        init(size:Int){
            values = FloatValueList(size, true, true)
        }
        
        func copy(source:QRS){
            segState = source.segState
            rTimestamp = source.rTimestamp
            qAmplitude = source.qAmplitude
            qIdx = source.qIdx
            rAmplitude = source.rAmplitude
            rIdx = source.rIdx
            sAmplitude = source.sAmplitude
            sIdx = source.sIdx
            mean = source.mean
            feat_width = source.feat_width
            feat_qra = source.feat_qra
            feat_rsa = source.feat_rsa
            feat_qrsta = source.feat_qrsta
            feat_cct1 = source.feat_cct1
            feat_cct2 = source.feat_cct2
            feat_rr = source.feat_rr
            classification = source.classification
            arrhythmia = source.arrhythmia
            values.copy(sourceList: source.values)
        }
        
        func reset(){
            values.clear()
            rTimestamp = -1
            qIdx = -1
            rIdx = -1
            sIdx = -1
            mean = 0
            feat_cct1 = 0
            feat_cct2 = 0
            feat_qra = 0
            feat_qrsta = 0
            feat_rsa = 0
            feat_width = 0
            feat_rr = 0
            segState = SegmentationStatus.INVALID
            //System.out.println("1"+segState)
            classification = QrsClass.INVALID
            arrhythmia = QrsArrhythmia.NORMAL_RHYTHM
        }
        
        /**
         * Estimates the timestamps of a missed/virtual beat
         */
        func estimateMissedTimestamps(){
            if (feat_rr < 1 || feat_rr > 6000){
                return
            }
            feat_rr /= 2
            rTimestamp -= feat_rr
        }
        
        
        //MARK: DO SOMETHING
        private var     _i:Int!
        private var     _x, _y, _sumx, _sumy:Double!
        
        func classify()->QrsClass{
            if rIdx == -1{
                classification = QrsClass.INVALID
            }else{
                feat_rr = rTimestamp - PanTompkins.QRS.qrsPrevious!.rTimestamp
                feat_qra = rAmplitude - qAmplitude
                feat_rsa = rAmplitude - sAmplitude
                mean = Double(values.getMean())
                
                // CC feature variables
                feat_qrsta = 0
                _sumx = 0
                _sumy = 0
                
                for i in 0...values.num - 1{
                    let v = values.values[i]
                    if values.values[i] > 0{
                        feat_qrsta += Double(v)//values.values[i]
                        
                    }else{
                        feat_qrsta -= Double(v)//values.values[i]
                    }
                }
                // check for templates
                if (PanTompkins.QRS.template1!.classification == QrsClass.INVALID || PanTompkins.QRS.template2!.classification == QrsClass.INVALID)
                {
                    // no templates yet, unknown and return
                    classification = QrsClass.UNKNOWN
                    return classification
                }
                // calculate correlation to templates
                feat_cct1 = maxCorr( other: PanTompkins.QRS.template1! )
                feat_cct2 = maxCorr( other: PanTompkins.QRS.template2! )
                
                feat_arT1diff = arDiff( other: PanTompkins.QRS.template1! )
                feat_arT2diff = arDiff( other: PanTompkins.QRS.template2! )
                
                // normal QRS duration is 60-120 ms
                if (feat_width > 130){
                    // possibly bundle branch block
                    classification = QrsClass.BB_BLOCK
                }else if (feat_width < 45){
                    classification = QrsClass.PVC
                }else{
                    classification = QrsClass.NORMAL
                }
                
                // template matchings
                
                // template CC tests
                if (feat_cct1 < 0.2 || feat_cct2 < 0.2){
                    arrhythmia = QrsArrhythmia.ARTIFACT
                }
                
                if (feat_cct1 < 0.3 || feat_cct2 < 0.3){
                    classification = QrsClass.ABERRANT
                }else if (feat_cct1 < 0.6 || feat_cct2 < 0.6){
                    classification = QrsClass.PVC_ABERRANT
                }else if (feat_cct1 < 0.9 && feat_cct2 < 0.9){
                    classification = QrsClass.PVC
                }else if (feat_cct1 < 0.98 && feat_cct2 < 0.98){
                    if (feat_arT1diff > 0.7 || feat_arT2diff > 0.7){
                        classification = QrsClass.ABERRANT
                    }else if (feat_arT1diff > 0.5 || feat_arT2diff > 0.5){
                        classification = QrsClass.PVC_ABERRANT
                    }else if (feat_arT1diff > 0.2 && feat_arT2diff > 0.2){
                        classification = QrsClass.PVC
                    }
                }
                // RR tests
                
                // -|----|-----------|--
                if ( (feat_rr >= (PanTompkins.QRS.qrsPrevious?.feat_rr)! * 1.5 && feat_rr > 800) || feat_rr > 1700){
                    arrhythmia = QrsArrhythmia.AV_BLOCK
                    
                    // escape beat
                    if (classification == QrsClass.NORMAL){
                        classification = QrsClass.APC
                    }
                }// -|-|--
                else if (feat_rr > 1 && feat_rr < 460){
                    // premature & fusion types
                    
                    if (feat_rr > PanTompkins.QRS.qrsPrevious!.feat_rr * 0.92){
                        // could be "normal" heart rate change
                        if (classification == QrsClass.NORMAL && (feat_cct1 < 0.96 || feat_cct2 < 0.96)){
                            classification = QrsClass.APC
                        }
                    }else{
                        arrhythmia = QrsArrhythmia.FUSION
                    }
                    
                    if (feat_rr < 400){
                        if (feat_cct1 < 0.6 || feat_cct2 < 0.6){
                            classification = QrsClass.APC_ABERRANT
                        }
                        else{
                            classification = QrsClass.APC
                        }
                    }
                }else if (PanTompkins.QRS.qrsPrevious!.feat_rr > 800 && feat_rr < PanTompkins.QRS.qrsPrevious!.feat_rr * 0.6){
                    classification = QrsClass.ESCAPE
                }else if (classification == QrsClass.NORMAL && feat_width > 10 && feat_width < PanTompkins.QRS.qrsPrevious!.feat_width * 0.6
                    && (feat_arT1diff > 0.1 || feat_arT2diff > 0.1)){
                    classification = QrsClass.PREMATURE
                }
            }
            return classification
        }
        
        private var     _maxcc:Double = 0
        private var     _cc:Double = 0
        //        private transient int        _n
        
        func maxCorr(other: QRS)->Double{
            _maxcc = 0
            //                for (_i = 0  _i < values.num  ++_i)
            for _n in -8...7{//(_n = -8; _n < 8; ++_n){
                for i in 0...values.num - 1{
                    let v = Double(values.values[i])
                    _x = (v - mean)
                    let n = Double(other.values.getIndirect( _n + i))
                    _y = (n - other.mean)
                    _cc += _x * _y
                    
                    _sumx += _x * _x
                    _sumy += _y * _y
                }
                if _cc != 0{
                    _cc = _cc / (sqrt( _sumx * _sumy ))
                    if (_cc > _maxcc){
                        _maxcc = _cc
                    }
                }
            }
            return _maxcc
        }
        
        func arDiff(other:QRS)->Double{
            if (other.feat_qrsta == 0){
                return 0
            }
            
            if (feat_qrsta > other.feat_qrsta){
                return (feat_qrsta - other.feat_qrsta) / other.feat_qrsta
            }
            
            return (other.feat_qrsta - feat_qrsta) / other.feat_qrsta
        }
    }
    
    /** the last 8 qrs complexes */
    var qrsHistory:ObjectValueList = ObjectValueList(8)
    public class StepHistory{
        var history:FloatValueList!
        var peakOverall:Double = 0
        var min:Double = Double(Float.greatestFiniteMagnitude)
        var max:Double = Double(Float.leastNormalMagnitude)
        var range:Double = 0
        
        init(size:Int){
            history = FloatValueList(size)
        }
        
        func add(value:Double){
            // check for max/min
            if (value > max){
                max = value
                peakOverall = max
                range = abs( max ) - abs( min )
            }else if (value < min){
                min = value
                range = abs( max ) - abs( min )
            }
            
            history.add( Float(value) )
        }
    }
    
    
    private var bandOut:StepHistory!
    private var intOut:StepHistory!
    // public boolean invalidQrs = false
    private var heartRateStats = StatFilter( 3)
    private var qrstaStats = StatFilter(3)
    private var rrMeanLong = MeanFilter(16)
    private var rrStats = StatFilter(8)
    
    private var risingPeak =  PeakDetectionFilter( minRange: 3, minDiff: 0 )
    private var rPeak =  PeakDetectionFilter( minRange: 1, minDiff: 0 )
    private var                    lastBandPeak:Int        = 0
    private var                    lastCrossing:Int        = 0
    
    private var    qPeak                =  MinDetectionFilter( minRange: 1, minDiff: 0 )
    // public PeakDetectionFilter sbRPeak =   PeakDetectionFilter( 1, 0 )
    private var    sPeak                =  MinDetectionFilter( minRange: 1, minDiff: 0 )
    private var                    startProcessing = 100
    
    private var                    beatCounter:Int!
    
    
    
    
    public func next( val:Double,  timestamp: Double)->Int{
        y[1] = val
        
        // LOW PASS (5 samples delay)
        y[2] = lowpass.next( y[1]  )
        
        // HIGH PASS (16 samples delay)
        y[3] = highpass.next( y [2] )
        
        // save original ecg after bandpass filtering
        bandOut.add( value: y[3] )
        
        // DIFFERENTIATOR (2 samples delay)
        y[4] = diff.next( y [3] )
        
        // SQUARING
        y[5] = y[4] * y[4]
        
        // hard limit to 255
        // if (y[ 5 ] > 1024)
        // y[ 5 ] = 1024
        
        // WND INTEGRATOR
        y[6] = wndInt.next( y[5] )
        
        // save value in history
        intOut.add( value: y[6] )
        
        // wndOut-mean
        y[7] = wndMean.next( y[6] )
        
        // all further processing is only done after an initial timeout, is only used to handle display issues with the
        // plot views
        if (startProcessing <= 0)
        {
            let qrsThreshold = y[7]
//
//            // is intOut or bandOut above threshold?
        
            if (y[3] > qrsThreshold || y[6] > qrsThreshold || QRS.qrsCurrent!.segState == SegmentationStatus.R_FOUND)
            {
                lastCrossing += 1
                
                if (QRS.qrsCurrent!.segState == SegmentationStatus.INVALID)
                {
                    // initialize R peak detector
                    rPeak.reset()
                    rPeak.next(Double(bandOut.history.getPastValue(2)))
                    rPeak.next(Double(bandOut.history.getPastValue(1)))
                    rPeak.next(y[3])
                    
                    lastCrossing = 0
                    
                    QRS.qrsCurrent!.segState = SegmentationStatus.THESHOLD_CROSSED
                    //System.out.println("3"+QRS.qrsCurrent.segState)
                }
                
                if (QRS.qrsCurrent!.segState == SegmentationStatus.THESHOLD_CROSSED)
                {
                    if (lastCrossing > preSegment && QRS.template2!.classification == QrsClass.NORMAL)
                    {
                        // if lastCrossing is larger than preSegment samples but no R peak was found it probably was an
                        // aberrant beat
                        // it is only considered if we already have two template beats
                        // Log.d( "lme.pants", "abb beat " + lastCrossing )
                        QRS.qrsCurrent!.rIdx = 0
                        QRS.qrsCurrent!.rTimestamp = timestamp
                        QRS.qrsCurrent!.rAmplitude = y[3]
                        QRS.qrsCurrent!.classification = QrsClass.ABERRANT
                        QRS.qrsCurrent!.arrhythmia = QrsArrhythmia.ARTIFACT
                        QRS.qrsCurrent!.feat_width = Double(lastCrossing)
                        QRS.qrsCurrent!.segState = SegmentationStatus.FINISHED
                        //System.out.println("4"+QRS.qrsCurrent.segState)
                        // qrsCurrent.feat_rr = 1
                    }
                }
            }
            else
            {
                // below all thresholds
                if (lastCrossing > 0){
                    lastCrossing -= 1
                }
                
                
                if (QRS.qrsCurrent!.segState == SegmentationStatus.PROCESSED)
                {
                    // QRS was processed, reset
                    QRS.qrsCurrent = qrsHistory.next() as? PanTompkins.QRS
                    QRS.qrsCurrent!.reset()
                }
            }
            // check for mean crossing
            if (QRS.qrsCurrent!.segState == SegmentationStatus.THESHOLD_CROSSED)
            {
                // R peak detector
                rPeak.next(y[3])
                
                // rising peak detector
                risingPeak.reset()
                risingPeak.next(y[6])
                
                qPeak.reset()
                sPeak.reset()
                
                
                // find peak in bandOut
                if (rPeak.peakIdx != -1)
                {
                    // R peak found, check if intOut is above threshold
                    if (y [6] < qrsThreshold)
                    {
                        if (lastCrossing > 0)
                        {
                            rPeak.reset()
                            QRS.qrsCurrent!.segState = SegmentationStatus.THESHOLD_CROSSED
                            //System.out.println("5"+QRS.qrsCurrent.segState)
                            lastCrossing = Int(-1000 * samplingTime)
                            return 0
                        }
                    }
                    
                    
                    // reverse copy all qrs values
                    for i in 0...preSegment//(int i = 0  i <= preSegment  ++i)
                    {
                        // from bandfiltered signal
                        y[ 8 ] = Double(bandOut.history.getPastValue( preSegment - i ))
                        
                        // to current qrs object
                        QRS.qrsCurrent!.values.add( Float(y[8]) )
                        
                        // find Q only if it hasn't been found yet
                        if (QRS.qrsCurrent!.qIdx == -1)
                        {
                            // find q-min
                            qPeak.next( Double(bandOut.history.getPastValue( i )) )
                            if (qPeak.peakIdx != -1)
                            {
                                QRS.qrsCurrent!.qAmplitude = qPeak.peakValue
                                QRS.qrsCurrent!.qIdx = preSegment - i
                            }
                        }
                    }
                    
                    // if no Q has been found, we use the first sample
                    if (QRS.qrsCurrent!.qIdx == -1)
                    {
                        QRS.qrsCurrent!.qAmplitude = Double(QRS.qrsCurrent!.values.values[ 0 ])
                        QRS.qrsCurrent!.qIdx = 0
                    }
                    
                    
                    // r peak in filtered signal
                    QRS.qrsCurrent!.rIdx = QRS.qrsCurrent!.values.head - rPeak.peakIdx
                    QRS.qrsCurrent!.rAmplitude = rPeak.peakValue
                    QRS.qrsCurrent!.rTimestamp = (timestamp - Double(rPeak.peakIdx) * Double(samplingTime))
                    rPassNum = 1
                    
                    // Log.d( "pants", "rtime " + qrsCurrent.rTimestamp )
                    
                    
                    // check if the amplitudes are valid
                    if (QRS.qrsCurrent!.rAmplitude - QRS.qrsCurrent!.qAmplitude < bandOut.range * 0.1)
                    {
                        //                    Log.d( "lme.pants", "Amplitude validation error "
                        //                            + (QRS.qrsCurrent.rAmplitude - QRS.qrsCurrent.qAmplitude) )
                        // probably misdetected
                        QRS.qrsCurrent!.reset()
                    }
                    else
                    {
                        // wait for S min
                        lastBandPeak = 0
                        QRS.qrsCurrent!.segState = SegmentationStatus.R_FOUND
                        
                        qrsDetection.peakFound()
                        
                        // pre-initialize sPeak detector
                        sPeak.next(y[3])
                        let va = qrsDetection.getAvgHR()
                        if va > 0{
                            print(val)
                        }
                        return qrsDetection.getAvgHR()
                    }
                }
            }
                
                
                // ==============================================
                // == R peak found... looking for S min
                // ====>
            else if (QRS.qrsCurrent!.segState == SegmentationStatus.R_FOUND)
            {
                // R has been found, we wait for S min
                QRS.qrsCurrent!.values.add(Float(y[3]))
                
                // continue looking for rising peak
                let wndIntCompensation = 0.85
                if (rPassNum > 0)
                {
                    rPassNum += 1
                    risingPeak.next( y[6] )
                    if (risingPeak.peakIdx != -1)
                    {
                        // rising peak of integration window found
                        // the length of the ridge equals the width of the QRS complex
                        QRS.qrsCurrent!.feat_width = Double(rPassNum) * Double(wndIntCompensation) * Double(samplingTime)
                        rPassNum = 0
                    }
                }
                
                lastBandPeak += 1
                
                // find S
                if (QRS.qrsCurrent!.sIdx == -1)
                {
                    // find S as min
                    sPeak.next( y[3] )
                    if (sPeak.peakIdx != -1)
                    {
                        
                        QRS.qrsCurrent!.sAmplitude = sPeak.peakValue
                        QRS.qrsCurrent!.sIdx = QRS.qrsCurrent!.values.head - sPeak.peakIdx
                    }
                }
                
                // check for max range
                if (lastBandPeak >= postSegment)
                {
                    // ==============================================
                    // == segmentation finished
                    // ====>
                    QRS.qrsCurrent!.segState = SegmentationStatus.FINISHED
                    //System.out.println("7"+QRS.qrsCurrent.segState)
                    
                    // if no S has been found, we use the last sample
                    if (QRS.qrsCurrent!.sIdx == -1)
                    {
                        QRS.qrsCurrent!.sAmplitude = y[ 3 ]
                        QRS.qrsCurrent!.sIdx = QRS.qrsCurrent!.values.head
                    }
                    
                    QRS.qrsPrevious =  qrsHistory.getPastValue( 1 ) as? PanTompkins.QRS
                    
                    
                    // make sure that we have a width
                    if (QRS.qrsCurrent!.feat_width < 1)
                    {
                        // substitute width estimation
                        QRS.qrsCurrent!.feat_width = Double(QRS.qrsCurrent!.sIdx - QRS.qrsCurrent!.qIdx) * (wndIntCompensation) * Double(samplingTime)
                    }
                    
                    
                    // find a template
                    if (QRS.template1!.classification == QrsClass.INVALID || QRS.template2!.classification == QrsClass.INVALID)
                    {
                        // no templates, wait for six beats
                        beatCounter += 1
                        if (QRS.qrsCurrent!.classify() == QrsClass.INVALID)
                        {
                            beatCounter -= 1
                        }
                        if (beatCounter == 6)
                        {
                            //                            ArrayList< Integer > sortList =   ArrayList<>(6)
                            var sortList : [Int] = []
                            
                            // 6 beats encountered, choose the templates
                            var avg:Double = 0
                            var  qrsRefTemp:QRS
                            for i in 0...5//(int i = 0  i < 6  ++i)
                            {
                                qrsRefTemp = qrsHistory.getPastValue(i) as! PanTompkins.QRS
                                avg += qrsRefTemp.feat_qrsta
                            }
                            avg /= 6
                            
                            sortList.append(0)
                            
                            // sort the indices in ascending order
                            var qrsRefTemp2:QRS
                            for i in 0...5//(int i = 0  i < 6  ++i)
                            {
                                qrsRefTemp = qrsHistory.getPastValue( i ) as! PanTompkins.QRS
                                for n in 0...sortList.count - 1//(int n = 0  n < sortList.size()  ++n)
                                {
                                    qrsRefTemp2 = qrsHistory.getPastValue( sortList[n] ) as! PanTompkins.QRS
                                    if (qrsRefTemp.feat_qrsta < avg && qrsRefTemp2.feat_qrsta < avg
                                        && qrsRefTemp2.feat_qrsta > qrsRefTemp.feat_qrsta)
                                    {
                                        sortList.insert(n, at: i)//.add( n, i )
                                        break
                                    }else if (n == sortList.count - 1){
                                        sortList.append(i)
                                        break
                                    }
                                }
                            }
                            
                            // select
                            for i in 0...2//(int i = 0  i < 3  ++i)
                            {
                                qrsRefTemp = qrsHistory.getPastValue( sortList[i]) as! PanTompkins.QRS
                                qrsRefTemp2 = qrsHistory.getPastValue( sortList[i + 1] ) as! PanTompkins.QRS
                                if (qrsRefTemp.maxCorr(other: qrsRefTemp2) > 0.9){
                                    // take those two as templates
                                    QRS.template1!.copy(source: qrsRefTemp)
                                    QRS.template2!.copy(source: qrsRefTemp2)
                                    QRS.template1!.classification = QrsClass.NORMAL
                                    QRS.template2!.classification = QrsClass.NORMAL
                                }
                            }
                            
                            // see if we have two templates
                            if (QRS.template2!.classification != QrsClass.NORMAL){
                                // no, only one template, so take the two smallest
                                QRS.template1!.copy(source: qrsHistory.getPastValue( sortList[0] ) as! PanTompkins.QRS )
                                QRS.template2!.copy(source: qrsHistory.getPastValue( sortList[1] ) as! PanTompkins.QRS )
                                QRS.template1!.classification = QrsClass.NORMAL
                                QRS.template2!.classification = QrsClass.NORMAL
                            }
                            
                            // end learning time
                        }
                    }else{
                        // classify current QRS and only proceed if beat is not invalid
                        if (QRS.qrsCurrent!.classify() != QrsClass.INVALID){
                            // missed beat?
                            if (QRS.qrsCurrent!.classification == QrsClass.ESCAPE){
                                // insert copy of current beat between current and last beat
                                QRS.qrsPrevious = QRS.qrsCurrent
                                QRS.qrsCurrent = qrsHistory.next() as? PanTompkins.QRS
                                QRS.qrsCurrent!.copy( source: QRS.qrsPrevious! )
                                
                                QRS.qrsPrevious!.classification = QrsClass.VIRTUAL
                                
                                // estimate the timestamps of the inserted (missed/virtual) beat
                                QRS.qrsPrevious!.estimateMissedTimestamps()
                                
                                // reclassify the beat
                                QRS.qrsCurrent!.classify()
                                // make sure it is not classified normal, since it certainly is the escape beat
                                if (QRS.qrsCurrent!.classification == QrsClass.NORMAL){
                                    QRS.qrsCurrent!.classification = QrsClass.ESCAPE
                                }
                            }else if (QRS.qrsCurrent!.classification == QrsClass.NORMAL){
                                if (QRS.qrsCurrent!.feat_cct1 > QRS.qrsCurrent!.feat_cct2){
                                    // replace template 1
                                    QRS.template1!.copy( source: QRS.qrsCurrent!)
                                }else{
                                    // replace template 2
                                    QRS.template2!.copy( source: QRS.qrsCurrent!)
                                }
                            }
                            
                            // calculate averages
                            rrMeanLong.next( QRS.qrsCurrent!.feat_rr )
                            //print("QRS.qrsCurrent!.feat_rr \(QRS.qrsCurrent!.feat_rr)" )
                            if (QRS.qrsCurrent!.feat_rr > 180 && QRS.qrsCurrent!.feat_rr < 4000){
                                rrStats.next( QRS.qrsCurrent!.feat_rr )
                                // calculate heart rate
                                qrsDetection.heartRate(val: Int(round(heartRateStats.next(60000 / rrStats.value))))
                                
                                qrstaStats.next(QRS.qrsCurrent!.feat_qrsta)
                            }
                        }
                    }
                    
                    // <====
                    // ==============================================
                }
            }
            // <====
            // ==============================================
            
        }
        else
        {
            startProcessing -= 1
        }
        return 0
    }
}
