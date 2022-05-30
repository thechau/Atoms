//
//  FloatValueList.swift
//  ECG_Project
//
//  Created by Châu Phan Thế on 6/4/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
class FloatValueList{
    public var values:[Float] = []
    private var sizeMax:Int = 0
    public var head: Int  = -1
    public var num:Int  = 0
    private var maintainMinMax: Bool  = false
    private var maintainSum: Bool  = false
    private var tail: Int  = 0
    private var minIdx:Int  = -1
    private var maxIdx:Int  = -1
    
    private var minValue:Float  = Float.greatestFiniteMagnitude
    private var maxValue: Float  = Float.leastNormalMagnitude
    private var sum :Double  = 0.0
    private var tIter:Int  = 0
    
    private func inits(_ cacheSize:Int, _ maintainMinMax:Bool, _ maintainSum:Bool) {
        if (cacheSize <= 0) {
            self.sizeMax = 1024
        } else {
            self.sizeMax = cacheSize
        }
        self.maintainMinMax = maintainMinMax
        self.maintainSum = maintainSum
    }
    
    init(_ cacheSize:Int, _ maintainMinMax:Bool, _ maintainSum:Bool) {
        inits(cacheSize, maintainMinMax, maintainSum)
        self.values = [Float](repeating: 0, count: self.sizeMax)
    }
    
    init(_ cacheSize:Int) {
        inits(cacheSize, false, false)
        self.values = [Float](repeating: 0, count: self.sizeMax)
    }
    
    public func add(_ newValue:Float)->Int {
        self.head += 1
        if (self.head == self.sizeMax) {
            self.head = 0
        }
        if (self.maintainSum){
            self.sum = self.sum - Double(self.values[self.head]) + Double(newValue)
        }
        
        self.values[self.head] = newValue
        
        if (self.num < self.sizeMax) {
            self.num += 1
        }else {
            self.tail += 1
            if (self.tail == self.sizeMax) {
                self.tail = 0
            }
        }
        
        if (self.maintainMinMax){
            if (newValue <= self.minValue) {
                self.minValue = newValue
                self.minIdx = self.head
            } else if (newValue >= self.maxValue) {
                self.maxValue = newValue
                self.maxIdx = self.head
            }else if (self.head == self.minIdx) {
                findMin()
            } else if (self.head == self.maxIdx) {
                findMax()
            }
        }
        return self.head
    }
    
    public func clear() {
        self.head = -1
        self.tail = 0
        self.num = 0
        self.minIdx = -1
        self.maxIdx = -1
        self.minValue = Float.greatestFiniteMagnitude
        self.maxValue = Float.leastNormalMagnitude
        self.sum = 0.0
        for i in 0...self.values.count - 1{//        Arrays.fill(self.values, 0.0)
            self.values[i] = 0.0
        }
    }
    
    public func size() ->Int{ return self.num }
    
    public func copy(sourceList: FloatValueList ) {
        self.num = sourceList.size()
        
        //        assert.assertTrue((self.num <= self.sizeMax))
        
        self.head = -1
        
        for i in 0...sourceList.num - 1{
            self.head += 1
            self.values[self.head] = sourceList.values[i]
            self.sum += Double(sourceList.values[i])
        }
        
        self.tail = 0
        
        if (self.maintainMinMax){
            findMinMax()
        }
    }
    
    private func findMax() {
        self.maxValue = self.minValue
        for i in 0...self.num - 1{//(self.tIter = 0  self.tIter < self.num  self.tIter++) {
            self.tIter = i
            if (self.values[self.tIter] > self.maxValue) {
                
                self.maxValue = self.values[self.tIter]
                self.maxIdx = self.tIter
            }
        }
    }
    
    private func findMin() {
        self.minValue = self.maxValue
        for i in 0...self.num - 1{//(self.tIter = 0  self.tIter < self.num  self.tIter++) {
            self.tIter = i
            if (self.values[self.tIter] < self.minValue) {
                self.minValue = self.values[self.tIter]
                self.minIdx = self.tIter
            }
        }
    }
    
    private func findMinMax() {
        self.minValue = Float.greatestFiniteMagnitude
        self.minIdx = -1
        self.maxValue = Float.leastNormalMagnitude
        self.maxIdx = -1
        for i in 0...self.num - 1{//(self.tIter = 0  self.tIter < self.num  self.tIter++) {
            self.tIter = i
            if (self.values[self.tIter] > self.maxValue) {
                self.maxValue = self.values[self.tIter]
                self.maxIdx = self.tIter
            }
            else if (self.values[self.tIter] < self.minValue) {
                
                self.minValue = self.values[self.tIter]
                self.minIdx = self.tIter
            }
        }
    }
    
    public func getMean()->Float {
        if self.num > 0{
            return Float(self.sum / Double(self.num))
        }
        return 0.0
    }
    
    public func getPastValue(_ idxPast:Int)->Float { return getIndirect(self.head - idxPast) }
    
    public func getIndirect(_ rIdx:Int) ->Float{
        if (self.num == 0) {
            return -1.0
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
