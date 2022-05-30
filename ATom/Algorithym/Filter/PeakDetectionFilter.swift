//
//  PeakDetectionFilter.swift
//  ECG_Project
//
//  Created by Châu Phan Thế on 6/4/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
class PeakDetectionFilter:LmeFilter{
    var minRange:Int!
    var minDiff:Double!
    public var peakIdx:Int!
    public var peakValue:Double = Double.nan
    var block:Int!
    
    init(minRange:Int, minDiff:Double) {
        super.init()
        if minRange > 0{
            self.minRange = minRange
        }else{
            self.minRange = 1
        }
        self.minDiff = abs(minDiff)
        // create x & y arrays
        y = [Double](repeating: 0, count: 1)
        //x =   double[minRange << 1 + 1]
        x = [Double](repeating: 0, count: minRange << (1 + 1))
        peakIdx = minRange
        block = x.count
    }
    
    func reset(){
        block = x.count
    }
    
    override func next(_ xnow: Double) -> Double {
        x.removeLast()
        x.insert(xnow, at: 0)
        peakValue = Double.nan
        peakIdx = -1
        // block until the buffer is filled entirely
        if block > 0{
            block -= 1
            return Double.nan
        }
        for i in 1...minRange{
            // values before mid-value
            if x[minRange] - minDiff <= x[minRange + i]{
                return Double.nan
            }
            // values after mid-value
            if x[minRange] - minDiff < x[minRange - i]{
                return Double.nan
            }
        }
        // value IS part of a peak
        peakValue = x[minRange]
        peakIdx = minRange
        return peakValue
    }
}

