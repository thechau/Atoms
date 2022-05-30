//
//  DataUtils.swift
//  ECG_Project
//
//  Created by Châu Phan Thế on 6/4/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation
class DataUtils {
    private static let TAG = "DataUtils"
    public static let SAMPLING_RATE:Int = 500
    public static let MAX_BUFFER:Int = SAMPLING_RATE * 40  // 40 sec data
    public static let MAX_HR_BUFFER:Int = 40
    
    //    public static volatile boolean initDone
    public static var initDone:Bool = false
    public static var fromDevice:Bool = false
    
    public static var displayData:[[Int]]!
    public static var hrData:[[Int]]!
    
    public static var dataIndex = 0
    public static var plotIndex = 0
    public static var lastPlotIndex = 0
    public static var totalDataCount = 0
    public static var totalPlotCount = 0
    public static var hrIndex = 0
    
    static var PACKET_A = 0xAA
    static var PACKET_B = 0xBB
    static var PACKET_END = 0x0A
    static var ACK = "a"
    static var NACK = "n"
    
    static var INIT_WINDOW = SAMPLING_RATE * 4  // 4 seconds data
    //
    static var NUM_HW_LEADS = 8
    static var NUM_LEADS = 12
    //
    // Indices of different LEADS
    static var V6 = 0
    static var I = 1
    static var II = 2
    static var V2 = 3
    static var V3 = 4
    static var V4 = 5
    static var V5 = 6
    static var V1 = 7
    static var III = 8
    static var aVR = 9
    static var aVL = 10
    static var aVF = 11
    static var STD_REPORT_LEADS = [
        [I, aVR, V1, V4],
        [II, aVL, V2, V5],
        [III, aVF, V3, V6]
    ];
    //    //Arrays holding order of leads in selected number of leads
    public static var ALL_LEADS : [Int] = [I, II, III, aVR, aVL, aVF, V1, V2, V3, V4, V5, V6]
    static var rawData : [[Int]] = [[]]
    static var initData : [[Int]] = [[]]
    static var sumVals : [Int] = []
    static var avgVals : [Int] = []
    //
    static var initIndex = 0
    static var sumCount = 0
    //
    //    // Battery level variables
    static var battLevels : [Int] = [0,0,0]
    static var battIndex : Int = 0
    static var battCount = 0
    private static var batteryLevel : Int = 0
    //
    
    private static var FIR500_B_150_NOTCH = [
    -3.99E-18, -9.32E-05, 6.37E-05, 5.60E-05, -0.000116107, -2.64E-05, 7.51E-05, -7.46E-05, -5.03E-05, 0.000143949, 5.52E-05, -5.73E-05, 8.79E-05, 4.51E-05, -0.000177258, -8.79E-05, 3.86E-05, -0.000104294, -4.00E-05, 0.000217311, 0.00012596,
    -1.82E-05, 0.000124161, 3.48E-05, -0.000265261, -0.000170507, -4.83E-06, -0.000147958, -2.91E-05, 0.000322057, 0.000222482, 3.09E-05, 0.000176022, 2.30E-05, -0.000388362, -0.000282432, -6.03E-05, -0.000208565, -1.64E-05, 0.000464483,
    0.000350442, 9.29E-05, 0.000245649, 9.51E-06, -0.000550306, -0.00042605, -0.000127938, -0.000287162, -2.63E-06, 0.000645239, 0.000508191, 0.000164361, 0.000332804, -3.66E-06, -0.000748178, -0.000595143, -0.000200466, -0.000382074,
    8.58E-06, 0.000857479, 0.000684504, 0.000234007, 0.000434265, -1.11E-05, -0.000970957, -0.000773189, -0.000262173, -0.00048847, 1.01E-05, 0.001085896, 0.000857449, 0.000281607, 0.000543587, -4.15E-06, -0.001199088, -0.000932915, -0.000288445,
    -0.000598346, -8.43E-06, 0.001306882, 0.000994667, 0.000278371, 0.000651324, 2.94E-05, -0.001405265, -0.001037325, -0.000246688, -0.000700989, -6.06E-05, 0.001489949, 0.001055167, 0.000188416, 0.000745734, 0.00010409, -0.001556484, -0.001042256,
    -9.84E-05, -0.000783928, -0.000161941, 0.001600382, 0.000992597, -2.86E-05, 0.000813963, 0.000236234, -0.001617255, -0.000900296, 0.000197749, -0.000834318, -0.000329022, 0.001602961, 0.00075973, -0.000414002, 0.00084361, 0.000442281, -0.001553754,
    -0.000565728, 0.000682016, -0.000840664, -0.000577863, 0.001466442, 0.000313738, -0.001005992, 0.000824569, 0.00073745, -0.00133854, 8.08E-18, 0.001389563, -0.000794745, -0.000922517, 0.001168417, -0.000378296, -0.001835697, 0.000751001,
    0.001134301, -0.000955441, 0.000822874, 0.002346609, -0.000693596, -0.001373784, 0.000700113, -0.001334246, -0.002923705, 0.000623296, 0.001641678, -0.00040419, 0.001911618, 0.003567557, -0.000541432, -0.001938437, 7.08E-05, -0.002552825,
    -0.004277909, 0.000449953, 0.002264282, 0.000295465, 0.003254291, 0.005053737, -0.000351489, -0.002619251, -0.00068842, -0.004011028, -0.005893355, 0.000249415, 0.00300328, 0.001100204, 0.004816669, 0.006794594, -0.000147931, -0.003416317,
    -0.001521147, -0.005663531, -0.007755055, 5.22E-05, 0.003858492, 0.001939598, 0.006542719, 0.008772481, 3.16E-05, -0.004330353, -0.002341687, -0.007444258, -0.009845267, -9.60E-05, 0.0048332, 0.002710946, 0.008357257, 0.010973186, 0.000131729,
    -0.005369568, -0.003027713, -0.009270099, -0.012158437, -0.000127483, 0.005943943, 0.003268144, 0.010170656, 0.013407198, 6.89E-05, -0.00656386, -0.003402571, -0.011046517, -0.014732042, 6.30E-05, 0.007241657, 0.00339267, 0.011885234, 0.01615588,
    -0.000294015, -0.007997446, -0.003186431, -0.01267457, -0.017718784, 0.000661611, 0.008864411, 0.002708758, 0.01340275, 0.019490655, -0.001223508, -0.00989902, -0.001842785, -0.014058707, -0.021596782, 0.002075904, 0.011202479, 0.000389383,
    0.014632315, 0.024275083, -0.003395507, -0.012971342, 0.002031454, -0.015114604, -0.028023437, 0.005551723, 0.015637316, -0.006264485, 0.015497951, 0.034062315, -0.009477924, -0.020356384, 0.014677758, -0.015776251, -0.046339012, 0.018435149,
    0.031593966, -0.037514534, 0.015945043, 0.088562586, -0.057413372, -0.098486722, 0.289806424, 0.584058781, 0.289806424, -0.098486722, -0.057413372, 0.088562586, 0.015945043, -0.037514534, 0.031593966, 0.018435149, -0.046339012, -0.015776251,
    0.014677758, -0.020356384, -0.009477924, 0.034062315, 0.015497951, -0.006264485, 0.015637316, 0.005551723, -0.028023437, -0.015114604, 0.002031454, -0.012971342, -0.003395507, 0.024275083, 0.014632315, 0.000389383, 0.011202479, 0.002075904,
    -0.021596782, -0.014058707, -0.001842785, -0.00989902, -0.001223508, 0.019490655, 0.01340275, 0.002708758, 0.008864411, 0.000661611, -0.017718784, -0.01267457, -0.003186431, -0.007997446, -0.000294015, 0.01615588, 0.011885234, 0.00339267,
    0.007241657, 6.30E-05, -0.014732042, -0.011046517, -0.003402571, -0.00656386, 6.89E-05, 0.013407198, 0.010170656, 0.003268144, 0.005943943, -0.000127483, -0.012158437, -0.009270099, -0.003027713, -0.005369568, 0.000131729, 0.010973186, 0.008357257,
    0.002710946, 0.0048332, -9.60E-05, -0.009845267, -0.007444258, -0.002341687, -0.004330353, 3.16E-05, 0.008772481, 0.006542719, 0.001939598, 0.003858492, 5.22E-05, -0.007755055, -0.005663531, -0.001521147, -0.003416317, -0.000147931, 0.006794594,
    0.004816669, 0.001100204, 0.00300328, 0.000249415, -0.005893355, -0.004011028, -0.00068842, -0.002619251, -0.000351489, 0.005053737, 0.003254291, 0.000295465, 0.002264282, 0.000449953, -0.004277909, -0.002552825, 7.08E-05, -0.001938437,
    -0.000541432, 0.003567557, 0.001911618, -0.00040419, 0.001641678, 0.000623296, -0.002923705, -0.001334246, 0.000700113, -0.001373784, -0.000693596, 0.002346609, 0.000822874, -0.000955441, 0.001134301, 0.000751001, -0.001835697, -0.000378296,
    0.001168417, -0.000922517, -0.000794745, 0.001389563, 8.08E-18, -0.00133854, 0.00073745, 0.000824569, -0.001005992, 0.000313738, 0.001466442, -0.000577863, -0.000840664, 0.000682016, -0.000565728, -0.001553754, 0.000442281, 0.00084361, -0.000414002,
    0.00075973, 0.001602961, -0.000329022, -0.000834318, 0.000197749, -0.000900296, -0.001617255, 0.000236234, 0.000813963, -2.86E-05, 0.000992597, 0.001600382, -0.000161941, -0.000783928, -9.84E-05, -0.001042256, -0.001556484, 0.00010409, 0.000745734,
    0.000188416, 0.001055167, 0.001489949, -6.06E-05, -0.000700989, -0.000246688, -0.001037325, -0.001405265, 2.94E-05, 0.000651324, 0.000278371, 0.000994667, 0.001306882, -8.43E-06, -0.000598346, -0.000288445, -0.000932915, -0.001199088, -4.15E-06,
    0.000543587, 0.000281607, 0.000857449, 0.001085896, 1.01E-05, -0.00048847, -0.000262173, -0.000773189, -0.000970957, -1.11E-05, 0.000434265, 0.000234007, 0.000684504, 0.000857479, 8.58E-06, -0.000382074, -0.000200466, -0.000595143, -0.000748178,
    -3.66E-06, 0.000332804, 0.000164361, 0.000508191, 0.000645239, -2.63E-06, -0.000287162, -0.000127938, -0.00042605, -0.000550306, 9.51E-06, 0.000245649, 9.29E-05, 0.000350442, 0.000464483, -1.64E-05, -0.000208565, -6.03E-05, -0.000282432,
    -0.000388362, 2.30E-05, 0.000176022, 3.09E-05, 0.000222482, 0.000322057, -2.91E-05, -0.000147958, -4.83E-06, -0.000170507, -0.000265261, 3.48E-05, 0.000124161, -1.82E-05, 0.00012596, 0.000217311, -4.00E-05, -0.000104294, 3.86E-05, -8.79E-05,
    -0.000177258, 4.51E-05, 8.79E-05, -5.73E-05, 5.52E-05, 0.000143949, -5.03E-05, -7.46E-05, 7.51E-05, -2.64E-05, -0.000116107, 5.60E-05, 6.37E-05, -9.32E-05, -3.99E-18
    
    ];      // Multiband Hanning Window (0-48-52-150) of order 500 -- basically ~50 Hz notch filter
    
    // ----------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    // Filter coefficients for low-pass (0-40 Hz) filter
    private static var FIR500_B_40 = [
    -2.26E-21, -2.25E-07, -4.06E-07, -5.02E-07, -4.82E-07, -3.36E-07, -7.74E-08, 2.48E-07, 5.69E-07, 7.98E-07, 8.52E-07, 6.78E-07, 2.72E-07, -3.01E-07, -9.17E-07, -1.41E-06, -1.60E-06, -1.38E-06, -7.27E-07, 2.72E-07, 1.40E-06, 2.36E-06, 2.84E-06, 2.62E-06,
    1.63E-06, -1.62E-20, -1.93E-06, -3.67E-06, -4.69E-06, -4.61E-06, -3.23E-06, -7.44E-07, 2.36E-06, 5.31E-06, 7.29E-06, 7.58E-06, 5.86E-06, 2.28E-06, -2.45E-06, -7.21E-06, -1.07E-05, -1.18E-05, -9.92E-06, -5.06E-06, 1.84E-06, 9.17E-06, 1.50E-05, 1.76E-05,
    1.59E-05, 9.62E-06, -8.31E-20, -1.08E-05, -2.02E-05, -2.53E-05, -2.43E-05, -1.67E-05, -3.76E-06, 1.17E-05, 2.59E-05, 3.48E-05, 3.56E-05, 2.70E-05, 1.04E-05, -1.09E-05, -3.17E-05, -4.64E-05, -5.04E-05, -4.16E-05, -2.09E-05, 7.49E-06, 3.69E-05, 5.97E-05,
    6.91E-05, 6.14E-05, 3.67E-05, -2.74E-19, -4.04E-05, -7.42E-05, -9.18E-05, -8.72E-05, -5.93E-05, -1.32E-05, 4.06E-05, 8.89E-05, 0.000118507, 0.000119891, 9.01E-05, 3.42E-05, -3.57E-05, -0.000102527, -0.000148594, -0.000160051, -0.000130885, -6.52E-05,
    2.31E-05, 0.000112929, 0.000181018, 0.000207845, 0.000182989, 0.000108626, -6.89E-19, -0.000117479, -0.000214034, -0.000262925, -0.000247662, -0.000167111, -3.70E-05, 0.000112831, 0.000245116, 0.000324251, 0.000325682, 0.000243126, 9.16E-05,
    -9.49E-05, -0.000270856, -0.00038992, -0.0004172, -0.000338942, -0.000167681, 5.91E-05, 0.00028689, 0.000457013, 0.000521531, 0.000456389, 0.000269306, -1.42E-18, -0.000287862, -0.000521449, -0.000636945, -0.000596626, -0.000400361, -8.82E-05,
    0.000267414, 0.000577872, 0.00076046, 0.0007599, 0.000564407, 0.00021155, -0.000218228, -0.000619557, -0.000887651, -0.000945291, -0.000764421, -0.00037645, 0.000132092, 0.000638358, 0.001012477, 0.001150474, 0.001002542, 0.000589137, -2.47E-18,
    -0.00062467, -0.001127131, -0.001371485, -0.001279824, -0.000855639, -0.000187749, 0.000567416, 0.001221904, 0.001602518, 0.001596016, 0.001181574, 0.000441474, -0.000454002, -0.001285052, -0.001835731, -0.001949374, -0.001572033, -0.0007721,
    0.00027022, 0.001302619, 0.002061062, 0.002336547, 0.002031577, 0.001191301, -3.73E-18, -0.001258154, -0.002266013, -0.002752518, -0.002564408, -0.00171188, -0.000375108, 0.001132205, 0.002435335, 0.003190632, 0.003174815, 0.002348589, 0.00087695,
    -0.000901389, -0.002550492, -0.00364272, -0.003868064, -0.003119694, -0.001532671, 0.000536653, 0.002588654, 0.004099303, 0.004652024, 0.004049846, 0.002378255, -4.98E-18, -0.002520763, -0.004549881, -0.005540131, -0.005175445, -0.003465206,
    -0.000761796, 0.002307663, 0.004983302, 0.006556934, 0.006554988, 0.004873751, 0.001829861, -0.001892077, -0.005388182, -0.007749236, -0.008290482, -0.006740722, -0.003340609, 0.00118072, 0.005753363, 0.00921075, 0.010576345, 0.009324897,
    0.005551556, -5.90E-18, -0.00606839, -0.011144831, -0.013828074, -0.013184453, -0.009026094, -0.002033016, 0.006323963, 0.014059148, 0.019099809, 0.01978018, 0.015293863, 0.005997986, -0.006512361, -0.019595907, -0.030003808, -0.034490827,
    -0.030482991, -0.016666574, 0.006627795, 0.037336155, 0.071901127, 0.105809001, 0.134331181, 0.153333517, 0.160000269, 0.153333517, 0.134331181, 0.105809001, 0.071901127, 0.037336155, 0.006627795, -0.016666574, -0.030482991, -0.034490827,
    -0.030003808, -0.019595907, -0.006512361, 0.005997986, 0.015293863, 0.01978018, 0.019099809, 0.014059148, 0.006323963, -0.002033016, -0.009026094, -0.013184453, -0.013828074, -0.011144831, -0.00606839, -5.90E-18, 0.005551556, 0.009324897,
    0.010576345, 0.00921075, 0.005753363, 0.00118072, -0.003340609, -0.006740722, -0.008290482, -0.007749236, -0.005388182, -0.001892077, 0.001829861, 0.004873751, 0.006554988, 0.006556934, 0.004983302, 0.002307663, -0.000761796, -0.003465206,
    -0.005175445, -0.005540131, -0.004549881, -0.002520763, -4.98E-18, 0.002378255, 0.004049846, 0.004652024, 0.004099303, 0.002588654, 0.000536653, -0.001532671, -0.003119694, -0.003868064, -0.00364272, -0.002550492, -0.000901389, 0.00087695,
    0.002348589, 0.003174815, 0.003190632, 0.002435335, 0.001132205, -0.000375108, -0.00171188, -0.002564408, -0.002752518, -0.002266013, -0.001258154, -3.73E-18, 0.001191301, 0.002031577, 0.002336547, 0.002061062, 0.001302619, 0.00027022, -0.0007721,
    -0.001572033, -0.001949374, -0.001835731, -0.001285052, -0.000454002, 0.000441474, 0.001181574, 0.001596016, 0.001602518, 0.001221904, 0.000567416, -0.000187749, -0.000855639, -0.001279824, -0.001371485, -0.001127131, -0.00062467, -2.47E-18,
    0.000589137, 0.001002542, 0.001150474, 0.001012477, 0.000638358, 0.000132092, -0.00037645, -0.000764421, -0.000945291, -0.000887651, -0.000619557, -0.000218228, 0.00021155, 0.000564407, 0.0007599, 0.00076046, 0.000577872, 0.000267414, -8.82E-05,
    -0.000400361, -0.000596626, -0.000636945, -0.000521449, -0.000287862, -1.42E-18, 0.000269306, 0.000456389, 0.000521531, 0.000457013, 0.00028689, 5.91E-05, -0.000167681, -0.000338942, -0.0004172, -0.00038992, -0.000270856, -9.49E-05, 9.16E-05,
    0.000243126, 0.000325682, 0.000324251, 0.000245116, 0.000112831, -3.70E-05, -0.000167111, -0.000247662, -0.000262925, -0.000214034, -0.000117479, -6.89E-19, 0.000108626, 0.000182989, 0.000207845, 0.000181018, 0.000112929, 2.31E-05, -6.52E-05,
    -0.000130885, -0.000160051, -0.000148594, -0.000102527, -3.57E-05, 3.42E-05, 9.01E-05, 0.000119891, 0.000118507, 8.89E-05, 4.06E-05, -1.32E-05, -5.93E-05, -8.72E-05, -9.18E-05, -7.42E-05, -4.04E-05, -2.74E-19, 3.67E-05, 6.14E-05, 6.91E-05, 5.97E-05,
    3.69E-05, 7.49E-06, -2.09E-05, -4.16E-05, -5.04E-05, -4.64E-05, -3.17E-05, -1.09E-05, 1.04E-05, 2.70E-05, 3.56E-05, 3.48E-05, 2.59E-05, 1.17E-05, -3.76E-06, -1.67E-05, -2.43E-05, -2.53E-05, -2.02E-05, -1.08E-05, -8.31E-20, 9.62E-06, 1.59E-05, 1.76E-05,
    1.50E-05, 9.17E-06, 1.84E-06, -5.06E-06, -9.92E-06, -1.18E-05, -1.07E-05, -7.21E-06, -2.45E-06, 2.28E-06, 5.86E-06, 7.58E-06, 7.29E-06, 5.31E-06, 2.36E-06, -7.44E-07, -3.23E-06, -4.61E-06, -4.69E-06, -3.67E-06, -1.93E-06, -1.62E-20, 1.63E-06, 2.62E-06,
    2.84E-06, 2.36E-06, 1.40E-06, 2.72E-07, -7.27E-07, -1.38E-06, -1.60E-06, -1.41E-06, -9.17E-07, -3.01E-07, 2.72E-07, 6.78E-07, 8.52E-07, 7.98E-07, 5.69E-07, 2.48E-07, -7.74E-08, -3.36E-07, -4.82E-07, -5.02E-07, -4.06E-07, -2.25E-07, -2.26E-21
    
    ];    // LPF Nuttall Window (0-40) of order 500 *
    
    // ----------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    // Filter coefficients for low-pass (0-25 Hz) filter
    private static var FIR500_B_25 = [
    -2.27E-22, 1.45E-07, 2.83E-07, 4.07E-07, 5.07E-07, 5.71E-07, 5.87E-07, 5.45E-07, 4.34E-07, 2.51E-07, -2.63E-21, -3.06E-07, -6.44E-07, -9.80E-07, -1.27E-06, -1.48E-06, -1.55E-06, -1.45E-06, -1.16E-06, -6.70E-07, 1.52E-20, 8.05E-07, 1.67E-06, 2.51E-06,
    3.22E-06, 3.68E-06, 3.81E-06, 3.51E-06, 2.76E-06, 1.57E-06, -5.39E-20, -1.84E-06, -3.76E-06, -5.58E-06, -7.06E-06, -7.97E-06, -8.14E-06, -7.43E-06, -5.79E-06, -3.26E-06, -1.11E-20, 3.72E-06, 7.56E-06, 1.11E-05, 1.39E-05, 1.56E-05, 1.58E-05, 1.43E-05,
    1.11E-05, 6.17E-06, -5.20E-20, -6.96E-06, -1.40E-05, -2.05E-05, -2.55E-05, -2.84E-05, -2.86E-05, -2.57E-05, -1.97E-05, -1.10E-05, 2.20E-19, 1.22E-05, 2.45E-05, 3.55E-05, 4.40E-05, 4.88E-05, 4.88E-05, 4.37E-05, 3.34E-05, 1.85E-05, -1.38E-19, -2.04E-05,
    -4.07E-05, -5.88E-05, -7.25E-05, -8.00E-05, -7.97E-05, -7.11E-05, -5.41E-05, -2.98E-05, -1.48E-19, 3.26E-05, 6.49E-05, 9.34E-05, 0.000114739, 0.000126061, 0.000125232, 0.000111237, 8.44E-05, 4.63E-05, -3.06E-19, -5.04E-05, -9.98E-05, -0.000143226,
    -0.000175427, -0.000192126, -0.000190265, -0.000168482, -0.000127389, -6.97E-05, 1.26E-18, 7.54E-05, 0.000149001, 0.000213131, 0.000260315, 0.000284304, 0.000280781, 0.000247964, 0.000186986, 0.000102005, -5.87E-19, -0.000109751, -0.000216462,
    -0.000308856, -0.000376304, -0.000409984, -0.000403934, -0.000355878, -0.000267736, -0.00014572, -9.57E-19, 0.000156079, 0.000307153, 0.0004373, 0.00053165, 0.000578005, 0.000568281, 0.000499639, 0.000375125, 0.000203759, -1.00E-18, -0.000217386,
    -0.000426979, -0.000606746, -0.000736279, -0.000799003, -0.000784139, -0.000688195, -0.000515785, -0.000279678, 4.57E-18, 0.000297377, 0.000583135, 0.000827311, 0.001002339, 0.001086034, 0.001064203, 0.000932589, 0.000697924, 0.000377896,
    -1.54E-18, -0.000400688, -0.000784657, -0.001111744, -0.001345208, -0.001455695, -0.001424678, -0.001246989, -0.000932124, -0.000504133, 1.85E-18, 0.000533382, 0.001043431, 0.001476914, 0.001785344, 0.001930193, 0.001887388, 0.001650583,
    0.001232809, 0.000666241, -2.17E-18, -0.000703892, -0.001376098, -0.001946605, -0.002351803, -0.002541301, -0.00248378, -0.002171236, -0.001621081, -0.000875794, 2.50E-18, 0.000924848, 0.001807786, 0.002557022, 0.003089176, 0.003338184, 0.003262934,
    0.002852808, 0.002130449, 0.001151334, -2.81E-18, -0.001216846, -0.002379846, -0.003368295, -0.004072224, -0.004404064, -0.004308727, -0.003770992, -0.002819319, -0.001525506, 3.11E-18, 0.001616916, 0.003167421, 0.004490903, 0.005439846,
    0.005895337, 0.005780651, 0.005071465, 0.003801491, 0.002062732, -3.38E-18, -0.002200091, -0.004324907, -0.00615512, -0.00748589, -0.008147995, -0.008026862, -0.007077537, -0.005333936, -0.002911127, 3.60E-18, 0.003145647, 0.006228885, 0.00893488,
    0.010959587, 0.012039512, 0.011979895, 0.010678696, 0.008143975, 0.004502743, -3.76E-18, -0.005012509, -0.010097444, -0.014761645, -0.018492476, -0.020798027, -0.021248016, -0.019512063, -0.015392079, -0.008845912, 3.86E-18, 0.010850398,
    0.023253823, 0.036627512, 0.05029298, 0.0635198, 0.075574391, 0.085770176, 0.09351528, 0.098354139, 0.099999757, 0.098354139, 0.09351528, 0.085770176, 0.075574391, 0.0635198, 0.05029298, 0.036627512, 0.023253823, 0.010850398, 3.86E-18, -0.008845912,
    -0.015392079, -0.019512063, -0.021248016, -0.020798027, -0.018492476, -0.014761645, -0.010097444, -0.005012509, -3.76E-18, 0.004502743, 0.008143975, 0.010678696, 0.011979895, 0.012039512, 0.010959587, 0.00893488, 0.006228885, 0.003145647, 3.60E-18,
    -0.002911127, -0.005333936, -0.007077537, -0.008026862, -0.008147995, -0.00748589, -0.00615512, -0.004324907, -0.002200091, -3.38E-18, 0.002062732, 0.003801491, 0.005071465, 0.005780651, 0.005895337, 0.005439846, 0.004490903, 0.003167421,
    0.001616916, 3.11E-18, -0.001525506, -0.002819319, -0.003770992, -0.004308727, -0.004404064, -0.004072224, -0.003368295, -0.002379846, -0.001216846, -2.81E-18, 0.001151334, 0.002130449, 0.002852808, 0.003262934, 0.003338184, 0.003089176,
    0.002557022, 0.001807786, 0.000924848, 2.50E-18, -0.000875794, -0.001621081, -0.002171236, -0.00248378, -0.002541301, -0.002351803, -0.001946605, -0.001376098, -0.000703892, -2.17E-18, 0.000666241, 0.001232809, 0.001650583, 0.001887388, 0.001930193,
    0.001785344, 0.001476914, 0.001043431, 0.000533382, 1.85E-18, -0.000504133, -0.000932124, -0.001246989, -0.001424678, -0.001455695, -0.001345208, -0.001111744, -0.000784657, -0.000400688, -1.54E-18, 0.000377896, 0.000697924, 0.000932589,
    0.001064203, 0.001086034, 0.001002339, 0.000827311, 0.000583135, 0.000297377, 4.57E-18, -0.000279678, -0.000515785, -0.000688195, -0.000784139, -0.000799003, -0.000736279, -0.000606746, -0.000426979, -0.000217386, -1.00E-18, 0.000203759,
    0.000375125, 0.000499639, 0.000568281, 0.000578005, 0.00053165, 0.0004373, 0.000307153, 0.000156079, -9.57E-19, -0.00014572, -0.000267736, -0.000355878, -0.000403934, -0.000409984, -0.000376304, -0.000308856, -0.000216462, -0.000109751, -5.87E-19,
    0.000102005, 0.000186986, 0.000247964, 0.000280781, 0.000284304, 0.000260315, 0.000213131, 0.000149001, 7.54E-05, 1.26E-18, -6.97E-05, -0.000127389, -0.000168482, -0.000190265, -0.000192126, -0.000175427, -0.000143226, -9.98E-05, -5.04E-05,
    -3.06E-19, 4.63E-05, 8.44E-05, 0.000111237, 0.000125232, 0.000126061, 0.000114739, 9.34E-05, 6.49E-05, 3.26E-05, -1.48E-19, -2.98E-05, -5.41E-05, -7.11E-05, -7.97E-05, -8.00E-05, -7.25E-05, -5.88E-05, -4.07E-05, -2.04E-05, -1.38E-19, 1.85E-05,
    3.34E-05, 4.37E-05, 4.88E-05, 4.88E-05, 4.40E-05, 3.55E-05, 2.45E-05, 1.22E-05, 2.20E-19, -1.10E-05, -1.97E-05, -2.57E-05, -2.86E-05, -2.84E-05, -2.55E-05, -2.05E-05, -1.40E-05, -6.96E-06, -5.20E-20, 6.17E-06, 1.11E-05, 1.43E-05, 1.58E-05, 1.56E-05,
    1.39E-05, 1.11E-05, 7.56E-06, 3.72E-06, -1.11E-20, -3.26E-06, -5.79E-06, -7.43E-06, -8.14E-06, -7.97E-06, -7.06E-06, -5.58E-06, -3.76E-06, -1.84E-06, -5.39E-20, 1.57E-06, 2.76E-06, 3.51E-06, 3.81E-06, 3.68E-06, 3.22E-06, 2.51E-06, 1.67E-06, 8.05E-07,
    1.52E-20, -6.70E-07, -1.16E-06, -1.45E-06, -1.55E-06, -1.48E-06, -1.27E-06, -9.80E-07, -6.44E-07, -3.06E-07, -2.63E-21, 2.51E-07, 4.34E-07, 5.45E-07, 5.87E-07, 5.71E-07, 5.07E-07, 4.07E-07, 2.83E-07, 1.45E-07, -2.27E-22
    
    ];    // LPF Nuttall Window (0-25) of order 500 *
    
    public static var filterValue = 1//FILTER_DEFAULT;
    public static var baseline = false;
    public static var notch   = false
    private static var filter : [Double] = []
    private static var convolutionIndex = 0;
    
    private static var convolutionBuffer : [[Int]] = [[]];
    static var ORDER_FIR = 500; // FIR filter order
    public static var testSignal = false;
    
    private static var pre_IIR_X : [Double] = [0, 0, 0, 0, 0, 0, 0, 0];
    private static var pre_IIR_Y : [Double] = [0, 0, 0, 0, 0, 0, 0, 0];
}

extension DataUtils{
    public static func setFilter() {
        switch (filterValue) {
        case 1:
            filter = FIR500_B_25;
            break;        // 0 to 25 Hz
        case 2:
            filter = FIR500_B_40;
            break;        // 0 to 40 Hz
        case 3:
            // filter applicable only if notch is active
            filter = notch ? FIR500_B_150_NOTCH : [];
            break; // 0 to 150 Hz (-50Hz)
        default:
            break
        }
    }
    
    /**
     * Sets working index based on whether initialization is completed
     * @return working index
     */
    private static func getWorkingIndex() -> Int {
    return initDone ? dataIndex : initIndex;
    }
    
    
    /**
     * Writes raw data samples received from device to appropriate buffer
     * @param received - array of 8 leads data value received from device
     */
//    public static func writeRaw(received: [Int]) {
//        let index = getWorkingIndex();
//        var buffer = initDone ? rawData : initData;
//
//        for i in 0..<NUM_HW_LEADS {
//            buffer[i][index] = received[i];
//        }
//    }
    /**
     * Performs convolution operation
     * @param channel
     * @return
     */
    private static func filterECG(channel: Int) -> Int {
        var filteredVal : Int = 0;
        
        var FIR_count = convolutionIndex;
        for i in 0...FIR_count {
            filteredVal = filteredVal + Int(filter[i]) * convolutionBuffer[channel][FIR_count];
            if (FIR_count == 0){
                FIR_count = ORDER_FIR;
            }
            else{
                FIR_count -= 1
            }
        }
        return Int(filteredVal);
    }
    
    public static func applyFilters() {
        for i in 0..<NUM_HW_LEADS {
            var index = getWorkingIndex();
            var buffer = initDone ? rawData : initData;
            
            convolutionBuffer[i][convolutionIndex] = buffer[i][index];
            
            if (!testSignal && filter != nil) // i.e not RAW
            {
                if (totalDataCount < ORDER_FIR){
                    
                    buffer[i][index] = 0;
                }else{
                    
                    buffer[i][index] = filterECG(channel: i);
                }
            }
        }
        
        convolutionIndex += 1
        if (convolutionIndex == ORDER_FIR + 1){
            
            convolutionIndex = 0;
        }
    }
    
    /**
     * Apply baseline filter and write output to display buffer
     */
    public static func applyBaselineFilters() {
        var index = getWorkingIndex();
        var readBuffer = initDone ? rawData : initData;
        var writeBuffer = initDone ? displayData : initData;
        
        // If baseline filter not set, simply copy raw to display buffer
        if (testSignal || !baseline) {
            for i in 0..<NUM_HW_LEADS {
                writeBuffer![i][index] = readBuffer[i][index];
            }
            return;
        }
        
        for i in 0..<NUM_HW_LEADS {
            pre_IIR_Y[i] = Double( readBuffer[i][index]) - pre_IIR_X[i] + (0.992) * (pre_IIR_Y[i]);
            pre_IIR_X[i] = Double(readBuffer[i][index]);
            writeBuffer![i][index] = Int(pre_IIR_Y[i]);
        }
    }
}

extension DataUtils{
    static func initDataBuffers() {
        rawData = [[Int]].init(repeating: [Int].init(repeating: 0, count: MAX_BUFFER), count: NUM_LEADS)
        initData = [[Int]].init(repeating: [Int].init(repeating: 0, count: INIT_WINDOW), count: NUM_LEADS)//    rawData = new short[NUM_LEADS][MAX_BUFFER]
        //    initData = new short[NUM_LEADS][INIT_WINDOW]
        sumVals = [Int].init(repeating: 0, count: NUM_LEADS)
        avgVals = [Int].init(repeating: 0, count: NUM_LEADS)
        //    sumVals = new int[NUM_LEADS]
        //    avgVals = new int[NUM_LEADS]
        resetIndices()
    }
    //
    static func clearDataBuffers(){
        rawData.removeAll()
        initData.removeAll()
        sumVals.removeAll()
        avgVals.removeAll()
        resetIndices()
    }
    //
    private static func resetIndices() {
        initIndex = 0
        dataIndex = 0
        totalDataCount = 0
        sumCount = 0
    }
}

extension DataUtils{
    //
    static func updateBatteryStatus(battInfoByte : CShort ) {
        let val = (battInfoByte & 0x0F) * 7
        battLevels[battIndex] = Int(val > 90 ? 95 : val)
        print(val)
        if (battCount < 2) {
            switch (battCount) {
            case 0:
                batteryLevel = battLevels[0]
            case 1:
                batteryLevel = (battLevels[0] + battLevels[1]) / 2
            default:
                break
            }
        } else {
            batteryLevel = (battLevels[0] + battLevels[1] + battLevels[2]) / 3
        }
        
        battIndex += 1
        battCount += 1
        
        if (battIndex == 3){
            battIndex = 0
        }
        
    }
    //
    static func getBatteryLevel() -> Int{
        return  batteryLevel
    }
    
    static func writeRaw(received: [Int] ) {
        if (!initDone) {
            for i in 0 ... NUM_HW_LEADS - 1{
                initData[i][initIndex] = received[i]
            }
        } else {
            for i in 0 ... NUM_HW_LEADS - 1{
                rawData[i][dataIndex] = received[i]
            }
        }
    }
    //
    static func populateOtherLeads() {
        let index = initDone ? dataIndex : initIndex
        
        if (!initDone) {
            initData[III][index] = (Int) (initData[II][index] - initData[I][index])
            initData[aVR][index] = (Int) ((-1) * (initData[I][index] + initData[II][index]) / 2)
            initData[aVL][index] = (Int) (initData[I][index] - (initData[II][index] / 2))
            initData[aVF][index] = (Int) (initData[II][index] - (initData[I][index] / 2))
        }
        else {
            rawData[III][index] = (Int) (rawData[II][index] - rawData[I][index])
            rawData[aVR][index] = (Int) ((-1) * (rawData[I][index] + rawData[II][index]) / 2)
            rawData[aVL][index] = (Int) (rawData[I][index] - (rawData[II][index] / 2))
            rawData[aVF][index] = (Int) (rawData[II][index] - (rawData[I][index] / 2))
        }
    }
    
    static func updateSumVals() {
        if (totalDataCount <= SAMPLING_RATE){
            return
        } //ignore first sec data
        
        let index = initDone ? dataIndex : initIndex
        var buffer = initDone ? rawData : initData
        
        for i in 0 ... NUM_LEADS - 1{
            
            sumVals[i] += buffer[i][index]
        }
        //        for (int i = 0  i < NUM_LEADS  i++) {
        //        }
        sumCount += 1
    }
    
    static func  getLeadText(lead: Int) -> String {
        var str = ""
        switch(lead) {
        case I   : str = "I" ;   break
        case II  : str = "II" ;  break
        case III : str = "III" ; break
        case aVR : str = "aVR"  ;break
        case aVL : str = "aVL";  break
        case aVF : str = "aVF";  break
        case V1  : str = "V1" ;  break
        case V2  : str = "V2" ;  break
        case V3  : str = "V3" ;  break
        case V4  : str = "V4" ;  break
        case V5  : str = "V5" ;  break
        case V6  : str = "V6" ;  break
        default:
            break
        }
        return str
    }
}

extension DataUtils{
    static func updateDCValues() {
        if (sumCount == 0){
            return
        }
        var str = "avg: "
        for i in 0 ... NUM_LEADS - 1{
            
            avgVals[i] = sumVals[i] / sumCount
            sumVals[i] = 0
            str += getLeadText(lead: i) + ": "
            str += "\(avgVals[i])"
            str += ", "
        }
        print(str)
        sumCount = 0
    }
    
    static func removeDCfromInitData() {
        updateDCValues()
        for i in 0 ... NUM_LEADS - 1{
            for j in 0 ... INIT_WINDOW - 1{
                
                initData[i][j] -= avgVals[i]
            }
        }
    }
    
    public static func main() {
        var val, msb, lsb : CShort!
        //short val, msb, lsb
        var received = [Int].init(repeating: 0, count: DataUtils.NUM_HW_LEADS)
        //short [] received = new short[NUM_HW_LEADS]
        var count = 0, countA = 0, countB = 0, countN = 0
        //int count = 0, countA = 0, countB = 0, countN = 0
        
        // read input file
        //File file = new File("input/ATOM_RAW_20190610_1952")
        
        // Initialize all data variables
        DataUtils.clearDataBuffers()
        DataUtils.initDataBuffers()
        
        
        
        
        //        try {
        
        //read a file raw.csv and then write it to disk with named centered.cs->no need!
        var datas : [UInt8] = []
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("ATOM_RAW_20190610_1952") {
            let filePath = pathComponent.path
            var dataOriganal = NSData(contentsOfFile: filePath)! as Data
            datas = dataOriganal.withUnsafeBytes {
                Array(UnsafeBufferPointer<UInt8>(start: $0, count: dataOriganal.count/MemoryLayout<UInt8>.stride))
            }
        }
        
        var i = -1
        let lenght = datas.count
        
        while true {
            i += 1
            if i >= lenght{
                break
            }
            val = CShort(datas[i])
            if val == -1 {
                break
            }
            
            if val != DataUtils.PACKET_A && val != DataUtils.PACKET_B{
                //        System.out.println("neither A nor B found")
                continue
            }
            
            if val == DataUtils.PACKET_A{  // Start of Packet
                // Packet_A received
                //            countA++
                countA += 1
                // status bytes used for finding lead connections
                i += 1
                if i >= lenght{
                    break
                }
                val = CShort(datas[i])
                if(val == -1){
                    break
                }
                //
                i += 1
                if i >= lenght{
                    break
                }
                val = CShort(datas[i])
                if val == -1 {
                    break
                }
                //
                //                // battery status byte
                //                val = Int(inputStream!.read(UnsafeMutablePointer(bitPattern: lenghInt)!, maxLength: lenghInt))
                i += 1
                if i >= lenght{
                    break
                }
                val = CShort(datas[i])
                if val == -1 {
                    break
                }
                DataUtils.updateBatteryStatus(battInfoByte: val)
            }
            
            // Packet_B received
            if (val == DataUtils.PACKET_B) {
                countB += 1//countB++
            }
            
            
            for k in 0..<DataUtils.NUM_HW_LEADS{
                
                i += 1
                if i >= lenght{
                    break
                }
                msb = CShort(datas[i])
                if msb == -1 {
                    break
                }
                // Receieve 1st Byte...MSB
                i += 1
                if i >= lenght{
                    break
                }
                lsb = CShort(datas[i])
                if lsb == -1 {
                    break
                }
                // Receieve 2nd Byte...LSB
                
                received[k] = Int(((msb << 8) | lsb) << 1)     //... S/W Gain of 2
                // received[i] = (short)(2*(256*msb + lsb))
            }
            
            i += 1
            if i >= lenght{
                break
            }
            val = CShort(datas[i])
            if val == -1 {
                break
            }
            if(val != DataUtils.PACKET_END) {
                //                countN++
                countN += 1
                //                write(buffer: DataUtilsIOS.NACK.getBytes())         // incorrect packet received
                continue
            }
            
            //            write(buffer: DataUtilsIOS.ACK.getBytes())             // correct packet received
            
            
            // Store raw data points received in data buffers
            DataUtils.writeRaw(received: received)
            
            //                applyFilters()
            //                applyBaselineFilters()
            
            //generate four more ALL_LEADS/channels...
            DataUtils.populateOtherLeads()
            
            //update sum vals for DC calculation
            DataUtils.updateSumVals()
            
            DataUtils.updateIndices()
            count += 1
            //            count++
        }
    }
    
    static func updateIndices() {
        totalDataCount += 1
        // totalDataCount++
        if initDone {
            dataIndex += 1
            if (dataIndex == MAX_BUFFER){
                dataIndex = 0
            }
        } else {
            initIndex += 1
            print("initIndex", initIndex)
            if (initIndex == INIT_WINDOW) {
                initIndex = 0
                removeDCfromInitData()
                initDone = true
            }
        }
    }
    
    static var shared : DataUtils{
        let data = DataUtils()
        initDataBuffers()
        return data
    }
}

extension DataUtils{
    
    public static func resetStaticVariables() {
        totalDataCount = 0
        totalPlotCount = 0
        dataIndex = 0
        plotIndex = 0
        hrIndex = 0
        lastPlotIndex = 0
        hrData = Array(repeating: Array(repeating: 0, count: 2), count: MAX_HR_BUFFER)
    }
    
    public static func decrementHrIndex() {
        hrIndex -= 1
        if (hrIndex < 0){
            hrIndex += MAX_HR_BUFFER
        }
    }
    
    public static func incrementHrIndex() {
        hrIndex += 1
        if (hrIndex == MAX_HR_BUFFER){
            hrIndex = 0
        }
    }
}


