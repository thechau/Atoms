
//create by Kha Đỗ

import UIKit
import Darwin


class QrsDetection{
    private static let TAG:String = "QRS Detection"
    public static let INDEX:Int = 0
    public static let HR_VALUE:Int = 1
    private static let DOWNSAMPLE_FACTOR:Int = 2
    
    public static let QRS_SAMPLING_RATE:Int = DataUtils.SAMPLING_RATE/DOWNSAMPLE_FACTOR
    
    private let SAMPLING_INTERVAL:Float = Float(1000/QRS_SAMPLING_RATE)
    private var timestamp:Double = 0.0
    private var count:Int = 0
    private var HR:[Int] = []
    public  var HRcount, lastHR, HRindex :Int!
    //MARK: private Handler handler
    private var handler:Handle!
    private var panTom:PanTompkins!
    init() {
        
    }
    
    public class QrsStats{
        var peaks:SparseIntArray!
        var hrVals:[Int]!
        
        init(){
            peaks = SparseIntArray()
            hrVals = [Int]()
        }
        
        func addHeartRate(_ offset:Int){
            var index:Int = DataUtils.hrData![DataUtils.hrIndex][QrsDetection.INDEX] - offset
            if index < 0{
                index += DataUtils.MAX_BUFFER
            }
            let val:Int = DataUtils.hrData![DataUtils.hrIndex][QrsDetection.HR_VALUE]
            peaks.append(index, val)
            hrVals.append(val)
        }
        
        func getAvgHeartRate()->Int{
            var sum:Int = 0
            for i in hrVals{
                sum += i
            }
            return (hrVals.count > 0) ? Int(round(Double(sum / hrVals.count))) : 0
        }
        
        func getHeartRateMin()->Int{
            return hrVals.min()!
        }
        
        func getHeartRateMax()->Int{
            return hrVals.max()!
        }
        
        func getPeaks()->SparseIntArray{
            return peaks
        }
    }
    
    init(handler:Handle){
        initQrsVariables()
        panTom = PanTompkins(qrsDetection: self)
//        DataUtils.initDataBuffers()
//        self.handler = handler
    }
    
    private func initQrsVariables(){
        lastHR = 0
        //        HR =   int[5]
        HR = [Int](repeating: 0, count: 5)
        HRindex = 0
        HRcount = 0
        timestamp = 0
        count = 0
    }
    
    func heartRate(val:Int){
        lastHR = val
        HR[HRindex] = val
        HRindex = (HRindex + 1) % 5
        HRcount += 1
    }
    
    func prinfHRIndex(){
        //print(QrsDetection.HRindex)
    }
    
    func getAvgHR()->Int{
        var sum:Float = 0
        for i in 0...4{
            sum = sum + Float(HR[i])
        }
        if sum == 0 {
            return 0
        }
        
        return HRcount! > 5 ? Int(round(sum/5)) : Int(round(sum / Float(HRcount)))
    }
    
    func getQrsStats(startIndex: Int)->QrsStats{
        let qrsStats = QrsStats()
        var counter:Int = DataUtils.MAX_HR_BUFFER
        //MARK: UNDEFINTE FUNC
        DataUtils.decrementHrIndex()
        
        // Include peaks for values less than startIndex, if any
        // self case is possible when startIndex > leastIndex
        while(DataUtils.hrData![DataUtils.hrIndex][QrsDetection.INDEX] < startIndex && counter > 0){
            addHrToStats(qrsStats, startIndex)
            DataUtils.decrementHrIndex()
            counter -= 1
        }
        // Finally, include all peaks until we reach startIndex
        while DataUtils.hrData![DataUtils.hrIndex][QrsDetection.INDEX] > startIndex && counter > 0 {
            addHrToStats(qrsStats, startIndex)
            DataUtils.decrementHrIndex()
            counter -= 1
        }
        return qrsStats
    }
    
    private func addHrToStats(_ qrsStats: QrsStats, _ offset:Int){
        //MARK: LOG
        qrsStats.addHeartRate(offset)
    }
    
    public func runPanTompkins(_ val:Double) ->Int{
        count += 1
        if (count % QrsDetection.DOWNSAMPLE_FACTOR == 0){
            return 0
        }//skipping alt points for down-sampling
        
        timestamp += Double(SAMPLING_INTERVAL)
        // processing pipeline
        let  hr:Int = panTom!.next(val: val, timestamp: timestamp)
        if (PanTompkins.QRS.qrsCurrent!.segState == SegmentationStatus.FINISHED) {
            PanTompkins.QRS.qrsCurrent!.segState = SegmentationStatus.PROCESSED
        }
        return hr
    }
    
    func peakFound(){
        if handler != nil{
            //MARK: handler.obtainMessage(MESSAGE_PEAK).sendToTarget()
            handler.updateData()
        }
        if lastHR > 0{
            DataUtils.hrData![DataUtils.hrIndex][QrsDetection.HR_VALUE] = lastHR
            DataUtils.incrementHrIndex()
        }
        DataUtils.hrData![DataUtils.hrIndex][QrsDetection.INDEX] = DataUtils.plotIndex
    }
}
