//
//  MeanFilter.swift
//  ECG_Project
//
//  Created by Châu Phan Thế on 6/4/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
class MeanFilter:LmeFilter{
    var num:Int = 0
    var maxNum:Int!
    
    override init(){
        super.init()
    }
    
    init(_ maxNum: Int) {
        super.init()
        
        a = [Double](repeating: 0, count: 2)
        a[0] = 0.0
        
        //b =   double[2]
        b = [Double](repeating: 0, count: 2)
        
        x = [Double](repeating: 0, count: a.count)
        y = [Double](repeating: 0, count: b.count)
        //            y =   double[a.length]
        //            x =   double[b.length]
        self.maxNum = maxNum
    }
    
    public override func next(_ xnow: Double) -> Double {
        y[1] = y[0]
        y[0] = (y[1] * Double(num) + xnow) / Double((num + 1))
        if (maxNum == 0 || num < maxNum){
            num += 1
        }
        return y[0]
    }
}

