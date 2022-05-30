//
//  LmeFilter.swift
//  ECG_Project
//
//  Created by Châu Phan Thế on 6/3/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
public class LmeFilter{
    var a:[Double]!
    var b:[Double]!
    
    var y:[Double]!
    var x:[Double]!
    
    init() {
        
    }
    
    init(_ b_taps:[Double], _ a_taps:[Double])throws{
        if b_taps.isEmpty || b_taps.count < 1
            || (b_taps.count == 1 && b_taps[0] == 0)
            || (!a_taps.isEmpty && a_taps[0] == 0) {
            throw ErrorException.InvalidParameterException
        }
        if a_taps.isEmpty{
            a = [Double](repeating: 0, count:1)
            a[0] = 1
        }else{
            
            a = [Double](repeating: 0, count:1)
            a.removeAll()
            
            for i in a_taps{
                self.a.append(i)
            }
        }
        
        b = [Double](repeating: 0, count:1)
        b.removeAll()
        for i in b_taps{
            self.b.append(i)
        }
        
        if !a_taps.isEmpty{
            y = [Double](repeating: 0, count: a_taps.count)
        }
        
        x = [Double](repeating: 0, count: b_taps.count)
    }
    
    public func next(_ xnow:Double)->Double{
        if b.count > 1{
            x.removeLast()
        }
        x.insert(xnow, at: 0)
        // shift y
        
        if a.count > 1{
            y.removeLast()
//            for i in 0...a.count - 2{
//                y[i + 1] = y[i]
//            }
        }
        
        y.insert(0, at: 0)
        // sum( b[n] * x[N-n] )
        
        for i in 0...b.count - 1{
            y[0] += b[i] * x[i]
        }
        // sum( a[n] * y[N-n] )
        if a.count > 1{
            for i in 1...a.count - 1{
                y[0] += a[i] * y[i]
            }
            
        }
        if (a[0] != 1) {
            y[0] /= a[0]
        }
        return y[0]
    }
}




