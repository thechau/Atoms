
//
//  ChartECGViewModel.swift
//  ECG_Project
//
//  Created by Châu Phan Thế on 5/27/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
import SwiftChart
import RxSwift

struct Point_Coordinate{
    var x : Int
    var y : Int
    
    mutating func setValueCoordinateNext(value: Int){
        x += value
        y += value
    }
    
    mutating func resetValue(){
        x = 0
        y = 0
    }
}

struct Point_Coordinate_Double{
    var x : Double = 0
    var y : Double = 0
    
    init(_ value: Double) {
        x = value
        y = x
    }
    
    mutating func setValueCoordinateNext(value: Double){
        x += value
        y += value
    }
    
    mutating func resetValue(){
        x = 0
        y = 0
    }
}



class ChartECGViewModel {
    var series : Variable<[ChartSeries]> =  Variable([])
    
    var arrSeries : [ChartSeries] = []
    var nbOfYValue = 1500
    
    var valueLine1 = Point_Coordinate(x: 0, y: 0)
    var valueLine2 = Point_Coordinate(x: 0, y: 0)
    
    var arrStepNil = [(x: -1.0, y: -1.0)]
    
    var step : Int = 5
    var arrText : [String] = []
    
    var arr : Variable<[(x: Double, y: Double)]> = Variable([(x: -1.0, y: -1.0), (x: -1.0, y: -1.0)])
    var arrNil = [(x: -1.0, y: -1.0)]
    var arr2 = [(x: 0.0, y: 0.0), (x: 1.0, y: 1.0)]
    
    var nbTemp : Variable<Int> = Variable(0)
    
//    var gameTimer1: Timer?
//    var gameTimer2: Timer?
//    var gameTimer3: Timer?
    
    var arrInt : [Int] = []
    
    //Variable<[User]> = Variable([])
    init(value: Int) {
        nbOfYValue = value
        getData()
        step = nbOfYValue == 1500 ? 10 : 20
        
    }
    
    init() {
        print("init data with 1500 value")
    }
    
    func nextStepLine1(){
        valueLine1.setValueCoordinateNext(value: step)
    }
    
    func nextStepLine2() {
        valueLine2.setValueCoordinateNext(value: step)
    }
    
    func getData(){
        
        let path = Bundle.main.path(forResource: "ecg_miBEAT", ofType: "txt")
        do
        {
            let contents = try String(contentsOfFile: path!)
            arrText = contents.components(separatedBy: "\n")
            setData()
        }
        catch
            
        {
            print("can not load file")
        }
    }
    
    func setData(){
        self.arr.value.removeAll()
        nbTemp.value = nbOfYValue/step
        self.arrNil = [(x: Double, y: Double)](repeating: (x: 0.0, y: 0.0), count: nbOfYValue)
        series.value = [ChartSeries](repeating: ChartSeries(data: arrNil), count: nbTemp.value)
        //drawFirstChart()
    }
    
    func drawFirstChart(){
        self.arr2.removeAll()
        valueLine2.resetValue()
//        gameTimer1 = Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(drawGraph1), userInfo: nil, repeats: true)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
//            self?.gameTimer1?.invalidate()
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
//            self?.gameTimer2?.invalidate()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 6.08) { [weak self] in
//            self?.gameTimer3?.invalidate()
//        }
    }
    
    @objc func drawGraph1(){
        if valueLine1.x == nbOfYValue {
            return
        }
        arr.value.removeAll()
       // randumData()
        appendData2(valueLine2.x)
    }
    
    
    func appendData2(_ i: Int){
        var value : [(x: Double, y: Double)] = []
        for z in 0...step{
            if i < arrText.count{
                value.append((x: Double(self.valueLine2.y) + Double(z), y: Double(arrText[i + z])!/128)) // 0 -- 10 // 5 - 15 // -- 10 -20
            }
        }
        arr.value = value
    }
    
    func randumData(){
        arrInt.removeAll()
        for _ in 0...10{
            let randum = Int.random(in: 60...100)
            arrInt.append(randum)
        }
    }
    
    func setNextStepLine2(){
        valueLine2.setValueCoordinateNext(value: step)
    }
}
