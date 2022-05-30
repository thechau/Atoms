//
//  StatFilter.swift
//  ECG_Project
//
//  Created by Châu Phan Thế on 6/4/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
class StatFilter:LmeFilter{
    var meanFilter:MeanFilter!
    var mean:Double = 0
    var min = Double.leastNormalMagnitude
    var max = Double.greatestFiniteMagnitude
    var range:Double = 0
    public var value:Double = 0
    /**
     * Stop increasing the num counter at maxNum values.
     *
     */
    
    init(_ maxNum:Int) {
        super.init()
        meanFilter = MeanFilter(maxNum)
        
    }
    
    public override func next(_ xnow: Double) -> Double {
        mean = meanFilter.next(xnow)
        value = xnow
        if xnow > max{
            max = xnow
            range = max - min
        }
        
        if xnow < min {
            min = xnow
            range = max - min
        }
        return value
    }
}
