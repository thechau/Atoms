////
////  DataUnitls.swift
////  Test
////
////  Created by phan.the.chau on 6/17/19.
////  Copyright © 2019 phan.the.chau. All rights reserved.
////
//import UIKit
//import Foundation
//
//class DataUtilsIOS {
//    static var PACKET_A = 0xAA
//    static var PACKET_B = 0xBB
//    static var PACKET_END = 0x0A
//    static var ACK = "a"
//    static var NACK = "n"
//
//    static var SAMPLING_RATEs : Int = 500
//    static var MAX_BUFFER : Int = SAMPLING_RATEs * 40  // 40 sec data
//    static var INIT_WINDOW = SAMPLING_RATEs * 4  // 4 seconds data
//    //
//    static var NUM_HW_LEADS = 8
//    static var NUM_LEADS = 12
//    //
//    // Indices of different LEADS
//    static var V6 = 0
//    static var I = 1
//    static var II = 2
//    static var V2 = 3
//    static var V3 = 4
//    static var V4 = 5
//    static var V5 = 6
//    static var V1 = 7
//    static var III = 8
//    static var aVR = 9
//    static var aVL = 10
//    static var aVF = 11
//
//    //    //Arrays holding order of leads in selected number of leads
//    public static var ALL_LEADS : [Int] = [I, II, III, aVR, aVL, aVF, V1, V2, V3, V4, V5, V6]
//
//    static var initDone : Bool = false //
//    static var rawData : [[Int]] = [[]]
//    static var initData : [[Int]] = [[]]
//    static var sumVals : [Int] = []
//    static var avgVals : [Int] = []
//    //
//    static var initIndex = 0
//    static var dataIndex = 0
//    static var totalDataCount = 0
//    static var sumCount = 0
//    //
//    //    // Battery level variables
//    static var battLevels : [Int] = [0,0,0]
//    static var battIndex : Int = 0
//    static var battCount = 0
//    private static var batteryLevel : Int = 0
//    //
//
//    static func initDataBuffers() {
//        rawData = [[Int]].init(repeating: [Int].init(repeating: 0, count: MAX_BUFFER), count: NUM_LEADS)
//        initData = [[Int]].init(repeating: [Int].init(repeating: 0, count: INIT_WINDOW), count: NUM_LEADS)//    rawData = new short[NUM_LEADS][MAX_BUFFER]
//        //    initData = new short[NUM_LEADS][INIT_WINDOW]
//        sumVals = [Int].init(repeating: 0, count: NUM_LEADS)
//        avgVals = [Int].init(repeating: 0, count: NUM_LEADS)
//        //    sumVals = new int[NUM_LEADS]
//        //    avgVals = new int[NUM_LEADS]
//        resetIndices()
//    }
//    //
//    static func clearDataBuffers(){
//        rawData.removeAll()
//        initData.removeAll()
//        sumVals.removeAll()
//        avgVals.removeAll()
//        resetIndices()
//    }
//    //
//    private static func resetIndices() {
//        initIndex = 0
//        dataIndex = 0
//        totalDataCount = 0
//        sumCount = 0
//    }
//    //
//    static func updateBatteryStatus(battInfoByte : CShort ) {
//        let val = (battInfoByte & 0x0F) * 7
//        battLevels[battIndex] = Int(val > 90 ? 95 : val)
//        print(val)
//        if (battCount < 2) {
//            switch (battCount) {
//            case 0:
//                batteryLevel = battLevels[0]
//            case 1:
//                batteryLevel = (battLevels[0] + battLevels[1]) / 2
//            default:
//                break
//            }
//        } else {
//            batteryLevel = (battLevels[0] + battLevels[1] + battLevels[2]) / 3
//        }
//
//        battIndex += 1
//        battCount += 1
//
//        if (battIndex == 3){
//            battIndex = 0
//        }
//
//    }
//    //
//    static func getBatteryLevel() -> Int{
//        return  batteryLevel
//    }
//    //
//    //
//    static func writeRaw(received: [Int] ) {
//        if (!initDone) {
//            for i in 0 ... NUM_HW_LEADS - 1{
//                initData[i][initIndex] = received[i]
//            }
//            //            for (int i = 0  i < NUM_HW_LEADS  i++) {
//            //                initData[i][initIndex] = received[i]
//            //            }
//        } else {
//            for i in 0 ... NUM_HW_LEADS - 1{
//                rawData[i][dataIndex] = received[i]
//            }
//            //            for (int i = 0  i < NUM_HW_LEADS  i++) {
//            //                rawData[i][dataIndex] = received[i]
//            //            }
//        }
//    }
//    //
//    //
//    static func populateOtherLeads() {
//        let index = initDone ? dataIndex : initIndex
//
//        if (!initDone) {
//            initData[III][index] = (Int) (initData[II][index] - initData[I][index])
//            initData[aVR][index] = (Int) ((-1) * (initData[I][index] + initData[II][index]) / 2)
//            initData[aVL][index] = (Int) (initData[I][index] - (initData[II][index] / 2))
//            initData[aVF][index] = (Int) (initData[II][index] - (initData[I][index] / 2))
//        }
//        else {
//            rawData[III][index] = (Int) (rawData[II][index] - rawData[I][index])
//            rawData[aVR][index] = (Int) ((-1) * (rawData[I][index] + rawData[II][index]) / 2)
//            rawData[aVL][index] = (Int) (rawData[I][index] - (rawData[II][index] / 2))
//            rawData[aVF][index] = (Int) (rawData[II][index] - (rawData[I][index] / 2))
//        }
//    }
//    //
//    //    }
//    //
//    //
//    static func updateSumVals() {
//        if (totalDataCount <= SAMPLING_RATEs){
//            return
//        } //ignore first sec data
//
//        let index = initDone ? dataIndex : initIndex
//        var buffer = initDone ? rawData : initData
//
//        for i in 0 ... NUM_LEADS - 1{
//
//            sumVals[i] += buffer[i][index]
//        }
//        //        for (int i = 0  i < NUM_LEADS  i++) {
//        //        }
//        sumCount += 1
//    }
//    //
//    //
//    static func  getLeadText(lead: Int) -> String {
//        var str = ""
//        switch(lead) {
//        case I   : str = "I" ;   break
//        case II  : str = "II" ;  break
//        case III : str = "III" ; break
//        case aVR : str = "aVR"  ;break
//        case aVL : str = "aVL";  break
//        case aVF : str = "aVF";  break
//        case V1  : str = "V1" ;  break
//        case V2  : str = "V2" ;  break
//        case V3  : str = "V3" ;  break
//        case V4  : str = "V4" ;  break
//        case V5  : str = "V5" ;  break
//        case V6  : str = "V6" ;  break
//        default:
//            break
//        }
//        return str
//    }
//
//
//    static func updateDCValues() {
//        if (sumCount == 0){
//            return
//        }
//        var str = "avg: "
//        for i in 0 ... NUM_LEADS - 1{
//
//            avgVals[i] = sumVals[i] / sumCount
//            sumVals[i] = 0
//            str += getLeadText(lead: i) + ": "
//            str += "\(avgVals[i])"
//            str += ", "
//            // str.append(getLeadText(i)).append(": ")
//            //            str.append(avgVals[i])
//            //            str.append(", ")
//        }
//        //    for (int i = 0  i < NUM_LEADS  i++) {
//        //    }
//        //    System.out.println(str)
//        print(str)
//        sumCount = 0
//    }
//    //
//    //
//    static func removeDCfromInitData() {
//        updateDCValues()
//        for i in 0 ... NUM_LEADS - 1{
//            for j in 0 ... INIT_WINDOW - 1{
//
//                initData[i][j] -= avgVals[i]
//            }
//        }
//    }
//    // remove DC from initData
//    //        for (int i = 0  i < NUM_LEADS  i++) {
//    //        for (int j = 0  j < INIT_WINDOW  j++)
//    //        }
//    //        }
//    //
//    //
//    static func updateIndices() {
//        totalDataCount += 1
//        // totalDataCount++
//        if (initDone) {
//            dataIndex += 1
//            if (dataIndex == MAX_BUFFER){
//                dataIndex = 0
//            }
//        } else {
//            initIndex += 1
//            print("initIndex", initIndex)
//            if (initIndex == INIT_WINDOW) {
//                initIndex = 0
//                removeDCfromInitData()
//                initDone = true
//            }
//        }
//    }
//}
//
//
//
//
//
//
//final class test{
//    static func write(buffer : [Int]) {
//        /* Dummy fn to write value to output stream connected to BT device */
//    }
//
//
//    public static func main() {
//        var val, msb, lsb : CShort!
//        //short val, msb, lsb
//        var received = [Int].init(repeating: 0, count: DataUtilsIOS.NUM_HW_LEADS)
//        //short [] received = new short[NUM_HW_LEADS]
//        var count = 0, countA = 0, countB = 0, countN = 0
//        //int count = 0, countA = 0, countB = 0, countN = 0
//
//        // read input file
//        //File file = new File("input/ATOM_RAW_20190610_1952")
//
//        // Initialize all data variables
//        DataUtils.clearDataBuffers()
//        DataUtils.initDataBuffers()
//
//
//
//
//        //        try {
//
//        //read a file raw.csv and then write it to disk with named centered.cs->no need!
//        var datas : [UInt8] = []
//
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//        let url = NSURL(fileURLWithPath: path)
//        if let pathComponent = url.appendingPathComponent("ATOM_RAW_20190610_1952") {
//            let filePath = pathComponent.path
//            var dataOriganal = NSData(contentsOfFile: filePath)! as Data
//            datas = dataOriganal.withUnsafeBytes {
//                Array(UnsafeBufferPointer<UInt8>(start: $0, count: dataOriganal.count/MemoryLayout<UInt8>.stride))
//            }
//        }
//
//        var i = -1
//        let lenght = datas.count
//
//        while true {
//            i += 1
//            if i >= lenght{
//                break
//            }
//            val = CShort(datas[i])
//            if val == -1 {
//                break
//            }
//
//            if val != DataUtils.PACKET_A && val != DataUtils.PACKET_B{
//                //        System.out.println("neither A nor B found")
//                continue
//            }
//
//            if val == DataUtils.PACKET_A{  // Start of Packet
//                // Packet_A received
//                //            countA++
//                countA += 1
//                // status bytes used for finding lead connections
//                i += 1
//                if i >= lenght{
//                    break
//                }
//                val = CShort(datas[i])
//                if(val == -1){
//                    break
//                }
////
//                i += 1
//                if i >= lenght{
//                    break
//                }
//                val = CShort(datas[i])
//                if val == -1 {
//                    break
//                }
////
////                // battery status byte
////                val = Int(inputStream!.read(UnsafeMutablePointer(bitPattern: lenghInt)!, maxLength: lenghInt))
//                i += 1
//                if i >= lenght{
//                    break
//                }
//                val = CShort(datas[i])
//                if val == -1 {
//                    break
//                }
//                DataUtils.updateBatteryStatus(battInfoByte: val)
//            }
//
//            // Packet_B received
//            if (val == DataUtils.PACKET_B) {
//                countB += 1//countB++
//            }
//
//
//            for k in 0..<DataUtils.NUM_HW_LEADS{
//
//                i += 1
//                if i >= lenght{
//                    break
//                }
//                msb = CShort(datas[i])
//                if msb == -1 {
//                    break
//                }
//                // Receieve 1st Byte...MSB
//                i += 1
//                if i >= lenght{
//                    break
//                }
//                lsb = CShort(datas[i])
//                if lsb == -1 {
//                    break
//                }
//                // Receieve 2nd Byte...LSB
//
//                received[k] = Int(((msb << 8) | lsb) << 1)     //... S/W Gain of 2
//                // received[i] = (short)(2*(256*msb + lsb))
//            }
//
//            i += 1
//            if i >= lenght{
//                break
//            }
//            val = CShort(datas[i])
//            if val == -1 {
//                break
//            }
//            if(val != DataUtils.PACKET_END) {
//                //                countN++
//                countN += 1
//                //                write(buffer: DataUtilsIOS.NACK.getBytes())         // incorrect packet received
//               continue
//            }
//
//            //            write(buffer: DataUtilsIOS.ACK.getBytes())             // correct packet received
//
//
//            // Store raw data points received in data buffers
//            DataUtils.writeRaw(received: received)
//
//            //                applyFilters()
//            //                applyBaselineFilters()
//
//            //generate four more ALL_LEADS/channels...
//            DataUtils.populateOtherLeads()
//
//            //update sum vals for DC calculation
//            DataUtils.updateSumVals()
//
//            DataUtils.updateIndices()
//            count += 1
//            //            count++
//        }
////
////        var textExportCenter = ""
////        var textExportRaw = ""
////
////        for i in 0..<DataUtilsIOS.NUM_LEADS{//(int i=0  i<NUM_LEADS  i++ ) {
////            let strraw = DataUtilsIOS.getLeadText(lead: DataUtilsIOS.ALL_LEADS[i]) + ","
////            textExportRaw += strraw
////
////
////           let strcent = DataUtilsIOS.getLeadText(lead: DataUtilsIOS.ALL_LEADS[i]) + ","
////            textExportCenter += strcent
////        }
////
////        textExportCenter += "\n"
////        textExportRaw += "\n"
////
////        // Write some 5000 samples in output files
////        for i in 0...DataUtilsIOS.MAX_BUFFER - 1{
////            for j in 0...DataUtilsIOS.NUM_LEADS - 1{
////                let strraw = String(DataUtilsIOS.rawData[DataUtilsIOS.ALL_LEADS[j]][i]) + ","
////                textExportRaw += strraw
////                let strcen = String(DataUtilsIOS.rawData[DataUtilsIOS.ALL_LEADS[j]][i] - DataUtilsIOS.avgVals[DataUtilsIOS.ALL_LEADS[j]]) + ","
////                textExportCenter += strcen
////            }
////
////            textExportCenter += "\n"
////            textExportRaw += "\n"
////        }
////        creatCSVsCenter(text: textExportCenter)
////        creatCSVsRaw(text: textExportRaw)
//    }
//}
////
//
//func creatCSVsCenter(text: String) -> Void {
//    let fileName = "IOS_Centered.csv"
//    let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
//    let csvText = text
//
//
//    do {
//        try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
//    } catch {
//        print("Failed to create file")
//        print("\(error)")
//    }
//    print(path ?? "not found")
//}
//
//func creatCSVsRaw(text: String) -> Void {
//    let fileName = "IOS_Raw.csv"
//    let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
//    let csvText = text
//
//
//    do {
//        try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
//    } catch {
//        print("Failed to create file")
//        print("\(error)")
//    }
//    print(path ?? "not found")
//}
//
//
//
//
