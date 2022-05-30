//
//  MinDetectionFilter.swift
//  ECG_Project
//
//  Created by Châu Phan Thế on 6/4/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
class MinDetectionFilter:PeakDetectionFilter{
    override init(minRange: Int, minDiff: Double) {
        super.init(minRange: minRange, minDiff: minDiff)
    }
    override func next(_ xnow: Double) -> Double {
        x.removeLast()
        x.insert(xnow, at: 0)
        peakValue = Double.nan
        peakIdx = -1
        // block until the buffer is filled entirely
        if (block > 0) {
            block -= 1
            return Double.nan
        }
        for i in 1...minRange{
            // values before mid-value
            if (x[minRange] - minDiff >= x[minRange + i]){
                return Double.nan
            }
            // values after mid-value
            if (x[minRange] - minDiff > x[minRange - i]){
                return Double.nan
            }
        }
        peakValue = x[minRange]
        peakIdx = minRange
        
        return peakValue
    }
}
