//
//  ObjectValueList.swift
//  ECG_Project
//
//  Created by Châu Phan Thế on 6/4/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
class ObjectValueList{
    public var sizeMax:Int = 0
    private var head:Int = -1
    private var num:Int = 0
    private var tail:Int = 0
    public var values: [AnyObject] = []  //Object
    
    private func inits(cacheSize:Int) {
        if (cacheSize <= 0) {
            self.sizeMax = 1024
        } else {
            self.sizeMax = cacheSize
        }
    }
    
    init(_ cacheSize:Int) {
        inits(cacheSize: cacheSize)
        self.values = [Int](repeating: 0, count: self.sizeMax) as [AnyObject]
    }
    
    public func  next() ->AnyObject{//Object
        self.head += 1
        if (self.head == self.sizeMax) {
            self.head = 0
        }
        if (self.num < self.sizeMax) {
            self.num += 1
        }else {
            self.tail += 1
            if (self.tail == self.sizeMax) {
                self.tail = 0
            }
        }
        return self.values[self.head]
    }
    public func getPastValue(_ idxPast:Int)->AnyObject/*Object*/ { return get(self.head - idxPast)!  }
    
    public func get(_ rIdx:Int)->AnyObject? {//Object
        if (self.num == 0) {
            return nil
        }
        if (rIdx < -self.num) {
            return self.values[(self.num << 1) + rIdx]
        }
        if (rIdx < 0) {
            return self.values[self.num + rIdx]
        }
        if (rIdx >= self.num) {
            return self.values[rIdx - self.num]
        }
        return self.values[rIdx]
    }
}
 
