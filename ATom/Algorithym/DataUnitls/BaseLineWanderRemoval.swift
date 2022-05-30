//
//  BaseLineWanderRemoval.swift
//  ECG_Project
//
//  Created by phan.the.chau on 7/8/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation

/**
 * Baseline Wander Removal algorithm for pdf report
 */
class BaseLineWanderRemoval {
    private static var TAG = "BaseLineRemoval";
    
    // Daubechies 4 Constant
    private var c0 = (1.0 + sqrt(3.0))/(4.0*sqrt(2.0));
    private var c1 = (3.0 + sqrt(3.0))/(4.0*sqrt(2.0));
    private var c2 = (3.0 - sqrt(3.0))/(4.0*sqrt(2.0));
    private var c3 = (1.0 - sqrt(3.0))/(4.0*sqrt(2.0));
    
    public class BwrResult {
        public var base :  [Double] = []
        public var ecg_out :  [Double] = []
        public var num_dec = 0
        
        init(base: [Double], ecg_out: [Double], num_dec: Int) {
            self.base = base;
            self.ecg_out = ecg_out;
            self.num_dec = num_dec;
        }
    }
    
    private func conv(x: [Double], h: [Double]) -> [Double]{
        //""" Perform the convolution operation between two input signals. The output signal length
        //is the sum of the lenght of both input signal minus 1."""
        let length = x.count + h.count - 1;
        var y = [Double].init(repeating: 0, count: length)//[0]*length;
        
        for i in 0 ..< y.count{
            for j in 0 ..< h.count{
                if i - j >= 0 && i - j < x.count{
                    y[i] += h[j] * x[i - j]
                }
            }
        }
        return y
    }
    
    private func db4_dec(x: [Double], level: Int) -> [[Double]] {
        // """ Perform the wavelet decomposition to signal x with Daubechies order 4 basis function as many as specified level"""
        
        //# Decomposition coefficient for low pass and high pass
        let lpk = [c0, c1, c2, c3]
        let hpk = [c3, -c2, c1, -c0]
        let levels = level + 1
        let arr = [Double].init(repeating: 0, count: levels)
        let counter = x.count
        var result = [[Double]].init(repeating: arr, count: counter)//new double[level+1][x.length];//[[]]*(level + 1)
        var x_temp = x
        var lp_ds : [Double] = [];
        var hp_ds : [Double] = [];
        for _ in 0 ..< level{
            var lp = conv(x: x_temp, h: lpk)
            var hp = conv(x: x_temp, h: hpk)
            
            lp_ds = [Double].init(repeating: 0, count: lp.count/2)
            hp_ds = [Double].init(repeating: 0, count: hp.count/2)
            
            for j in 0 ..< lp.count{
                lp_ds[j] = lp[2 * j + 1]
                hp_ds[j] = hp[2 * j + 1]
            }
            result[level - 1] = hp_ds
            x_temp = lp_ds
        }
        if lp_ds.count != 0{
            result[0] = lp_ds
        }
        return result
    }
    
    private func db4_rec(signals: [[Double]], level: Int) -> [Double]{
        // ""
        //" Perform reconstruction from a set of decomposed low pass and high pass signals as deep as specified level"
        //""
        
        //#Reconstruction coefficient
        let lpk = [c0, c1, c2, c3]
        let hpk = [c3, -c2, c1, -c0]
        
        var cp_sig = signals
        for i in 0 ..< level {
            var lp = cp_sig[0];
            var hp = cp_sig[1];
            
            
            //Verify new length
            var length = 0;
            if (lp.count > hp.count){
                
                length = 2 * hp.count;
            }
            else{
                length = 2 * lp.count;
            }
            
            //Upsampling by 2
            var lpu = [Double].init(repeating: 0, count: length + 1)
            var hpu = [Double].init(repeating: 0, count: length + 1)
            
            var index = 0;
            for j in  0...length{
                if (j % 2 != 0) {
                    lpu[j] = lp[index];
                    hpu[j] = hp[index];
                    index += 1;
                }
            }
            
            //##Convolve with reconstruction coefficient
            var lpc = conv(x: lpu, h: lpk);
            var hpc = conv(x: hpu, h: hpk);
            
            //#Truncate the convolved output by the length of filter kernel minus 1 at both end of
            //the signal
            
            guard let lpt = copyOfRange(arr: lpc, from: 3, to: lpc.count - 3), let hpt = copyOfRange(arr: hpc, from: 3, to: lpc.count - 3) else {
                return []
            }
            
            //#Add both signals
            var org = [Double].init(repeating: 0, count: lpt.count)//new double[lpt.length];//[0]*len(lpt)
            for j in 0..<org.count {
                org[j] = lpt[j] + hpt[j];
            }
            
            if (cp_sig.count > 2) {
                var new_cp_sig = [[Double]].init(repeating: [Double].init(repeating: 0, count: 1), count: 2)
                new_cp_sig[0] = org;
//                guard let arr = copyOfRange(arr: cp_sig, from: 2, to: cp_sig.count) else {
//                    return []
//                }
                var arr = [[Double]]()
                for i in 2..<cp_sig.count{
                    arr.append(cp_sig[i])
                }
                for k in 0..<arr.count {
                    new_cp_sig[k+1 ] = arr[k];
                }
                cp_sig = new_cp_sig;
            }
            else {
                var new_cp_sig = [[Double]].init(repeating: [Double].init(repeating: 0, count: 1), count: 2)//new double[2][];
                new_cp_sig[0] = org;
                cp_sig = new_cp_sig;
            }
        }
        
        return cp_sig[0];
    }
    
    func copyOfRange<T>(arr: [T], from: Int, to: Int) -> [T]? where T: ExpressibleByIntegerLiteral {
        guard from >= 0 && from <= arr.count && from <= to else { return nil }
        
        var to = to
        var padding = 0
        
        if to > arr.count {
            padding = to - arr.count
            to = arr.count
        }
        
        return Array(arr[from..<to]) + [T](repeating: 0, count: padding)
    }
    
    private func  calcEnergy(x: [Double]) -> Double{
        // """ Calculate the energy of a signal which is the sum of square of each points in the signal."""
        var total = 0.0;
        for i in 0..<x.count {
            total += x[i] * x[i];
        }
        return total;
    }
    
    public func bwr(raw: [Double]) -> BwrResult{
        // ""
        //" Perform the baseline wander removal process against signal raw. The output of this method is signal with correct baseline
        //and its x: baselinlevel: e "" "
        
        // Log.d(TAG, "Baseline wander removal called:");
        var en0 = 0.0;
        var en1 = 0.0;
        var en2 = 0.0;
        var n = 0.0;
        
        var curlp = raw
        var num_dec = 0;
        var last_lp = [Double].init(repeating: 0, count: raw.count)
        while (true) {
            //#Decompose 1 level
            var sig=db4_dec(x: curlp, level: 1);
            var lp = sig[0];
            var hp = sig[1];
            
            //#Shift and calculate the energy of detail / high pass coefficient
            en0 = en1;
            en1 = en2;
            en2 = calcEnergy(x: hp);
            
            if (num_dec == 9) { // decompose till level 9
                last_lp = curlp;
                break;
            }
            curlp = lp
            num_dec = num_dec + 1;
        }
        //   System.out.prsignals: intln("nlevel: um_dec: "+num_dec);
        
        //#Reconstruct the baseline from this level low pass signal up to the original length
        var base = last_lp;
        for i in 0..<num_dec {
            var rec_sig = [[Double]].init(repeating: [Double].init(repeating: 0, count: raw.count), count: 2)//new double[2][raw.length];
            var zeroes = [Double].init(repeating: 0, count: raw.count)
            
            rec_sig[0] =  base;
            rec_sig[1] = zeroes;
            base = db4_rec(signals: rec_sig,level: 1);
        }
        
        //#Correct the original signal by subtract it with its baseline
        var ecg_out = [Double].init(repeating: 0, count: raw.count)
        
        for i in 0..<raw.count {
            ecg_out[i] = raw[i] - base[i];
        }
        
        var bwrResult = BwrResult(base: base, ecg_out: ecg_out, num_dec: num_dec);
        
        //        double[][] ret = new double[2][raw.length];
        //        ret[0] = base;
        //        ret[1] = ecg_out;
        return bwrResult;
    }
    
}

