//
//  PdfUtils.swift
//  ECG_Project
//
//  Created by phan.the.chau on 7/13/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
public class PdfUtils {
    private static var  TAG = "PdfUtils";
    
    // Arrays to store sum and mean values
    private static var chSum = [Int].init(repeating: 0, count: DataUtils.NUM_LEADS)
    private static var chMean = [Int].init(repeating: 0, count: DataUtils.NUM_LEADS)
    
    // start index of data used in pdf report
    private static var startIndex = 0;
    
    // Variables for report generation
    private static var PDF_DURATION = 10;  // Actual duration of report data in seconds
    private static var BASELINE_THROW_DURATION = 3; // Duration of additional trailing data required for baseline wander algo
    private static var LEARNING_DURATION = 10; // Duration of pan tompkins learning algo
    
    private static var REPORT_PROCESSING_DURATION = PDF_DURATION + BASELINE_THROW_DURATION;
    private static var REPORT_ENABLE_DURATION = REPORT_PROCESSING_DURATION + LEARNING_DURATION;
    
    static var REPORT_PROCESSING_COUNT = DataUtils.SAMPLING_RATE * REPORT_PROCESSING_DURATION;
    public static var REPORT_ENABLE_COUNT = DataUtils.SAMPLING_RATE * REPORT_ENABLE_DURATION;
    
    
    // Signals for ATOM hardware
    public static var START = "H";
    public static var STOP = "K";
    public static var START_TEST = "P";
    public static var ACK = "w";
    public static var NACK = "v";
    
    // Hardware Gain signals
    public static var GAIN_1 = "B";
    public static var GAIN_2 = "C";
    public static var GAIN_3 = "D";
    public static var GAIN_4 = "E";
    public static var GAIN_6 = "F"; //default
    public static var GAIN_8 = "G";
    public static var GAIN_12 = "T";
    
    // ATOM hardware data packet types
    public static var packet_A = 0xAA;
    public static var packet_B = 0xBB;
    public static var packet_END = 0x0A;
    
    // Software Gain variables
    static var GAIN_DEFAULT = 0;
    public static var GAIN = [1, 2, 0.5];
    
    // Filters
    public static var FILTERS = ["OFF", "0-25 Hz", "0-40 Hz", "0-150 Hz"];
    public static var FILTER_DEFAULT = 2; // 0-40Hz
    public static var BASELINE_DEFAULT = true; // enable/disable baseline filter
    public static var NOTCH_DEFAULT = true; // enable/disable notch filter
    
    
    // Message types for Handler
    public static var MESSAGE_STATE_CHANGE = 1;
    public static var MESSAGE_DEVICE_NAME = 2;
    public static var MESSAGE_TOAST = 3;
    public static var MESSAGE_REPORT_ENABLE = 4;
    public static var MESSAGE_PEAK = 5;
    public static var MESSAGE_BATTERY = 6;
    public static var MESSAGE_RECALIBRATE = 7;
    public static var MESSAGE_REPORT_GENERATED = 8;
    
    // Key names received from the BluetoothSetupService Handler
    public static var DEVICE_NAME = "device_name";
    public static var TOAST = "toast";
    
    // Constants that indicate the current connection state
    public static var STATE_NONE = 0;       // we're doing nothing
    public static var STATE_LISTEN = 1;     // now listening for incoming connections
    public static var STATE_CONNECTING = 2; // now initiating an outgoing connection
    public static var STATE_CONNECTED = 3;  // now connected to a remote device
    public static var STATE_FAILED = 4; // connection failed
    
    // Constants required for file handling
    public static var REPORTS_FOLDER = "ATOM Reports"; // Folder name for ATOM reports on phone storage
    
    // Display parameters
    static var HARDWARE_SCALE : Double = 27*6; //27 for hw gain=1 corresponds to 1mV
    public static var SATURATED = -10000; // Indicator for triggering re-calibration
    
    // useful data for pdf generation. it includes the 10 sec data displayed in report and the
    // 3 sec extra trailing data. it excludes any data used for pan tompkins learning
    private static var pdfUsefulCount = REPORT_PROCESSING_COUNT; // This will give 13 sec data
    
    
    // calculates start index and also returns it
    static func getStartIndex() -> Int {
        startIndex = DataUtils.lastPlotIndex - pdfUsefulCount ;
        if (startIndex < 0) {
            startIndex += DataUtils.MAX_BUFFER;
        }
        return startIndex;
    }
    
    init() {
        PdfUtils.chSum = [Int].init(repeating: 0, count: DataUtils.NUM_LEADS)
        PdfUtils.chMean = [Int].init(repeating: 0, count: DataUtils.NUM_LEADS)
    }
    
    // calculates mean values for all leads for pdf report data
    private static func calcMeanVals() {
        for i in 0..<DataUtils.NUM_LEADS {
            chSum[i] = 0;
            var index = startIndex;
            for _ in 0..<pdfUsefulCount{
                let sample = DataUtils.rawData[i][index];
                chSum[i] += sample;
                index += 1
                if (index == DataUtils.MAX_BUFFER) {
                    index = 0;
                }
            }
            chMean[i] = chSum[i] / pdfUsefulCount;
        }
    }
    
    
    // calculates ecg amplitudes in centimetres for all leads for pdf report data
    private static func calculateYInCms(leadData: [[Double]]) -> [[Double]]{
        var yInCms = [[Double]].init(repeating: [Double].init(repeating: 0, count: pdfUsefulCount), count: DataUtils.NUM_LEADS)//ew double[NUM_LEADS][pdfUsefulCount];
        for i in 0..<DataUtils.NUM_LEADS {
            for j in 0..<pdfUsefulCount {
                let y = leadData[i][j];
                yInCms[i][j] = Double(y / HARDWARE_SCALE);
            }
        }
        return yInCms;
    }
    
    
    // removes averages from ecg data for report to center values around zero
    private static func getAbsLeadData () -> [[Double]] {
        var leadData = [[Double]].init(repeating: [Double].init(repeating: 0, count: pdfUsefulCount), count: DataUtils.NUM_LEADS)//new int[NUM_LEADS][pdfUsefulCount];
        for i in 0..<DataUtils.NUM_LEADS {
            var index = startIndex;
            for j in 0..<pdfUsefulCount {
                leadData[i][j] = Double(DataUtils.rawData[i][index] - chMean[i]);
                index += 1
                if (index == DataUtils.MAX_BUFFER){
                    index = 0;
                }
            }
        }
        return leadData;
    }
    
    
    // populates ecg data for all leads in centimetres for use in pdf report
    public static func getLeadDatInCms() -> [[Double]]{
        calcMeanVals();
        let leadData = getAbsLeadData();
        return calculateYInCms(leadData: leadData);
    }
}
