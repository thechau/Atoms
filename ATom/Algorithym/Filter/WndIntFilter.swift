//
//  WndIntFilter.swift
//  ECG_Project
//
//  Created by Châu Phan Thế on 6/4/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
class WndIntFilter:LmeFilter{
    var m_int:FloatValueList!
    
    init(wndLength: Int) {
        super.init()
        a = [Double](repeating: 0, count: 1)
        a.append(Double(wndLength))
        b = [Double](repeating: 0, count: 1)
        // create x & y arrays
        y = [Double](repeating: 0, count: a.count)
        x = [Double](repeating: 0, count: b.count)
        m_int = FloatValueList(wndLength, false, true)
    }
    
    override func next(_ xnow: Double) -> Double{
        m_int.add(Float(xnow))
        y[0] = Double(m_int.getMean());
        return y[0];
    }
}
