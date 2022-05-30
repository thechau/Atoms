//
//  SpacingLabel.swift
//  ATom
//
//  Created by phan.the.chau on 11/12/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import Foundation
import UIKit

class CustomJapaneseUILabel: UILabel {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.attributedText = setTextContentTypeAttributedStringCustom(text: self.text!, fontSize: self.font, lineSpacing: 6, textColor: "000000")
        self.textAlignment  = .center
    }
    
    func setTextContentTypeAttributedStringCustom(text: String, fontSize: UIFont, lineSpacing: Int, textColor: String) -> NSAttributedString {
        let defaultFont = fontSize
        let detailTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor(hexString: textColor), NSAttributedString.Key.font: defaultFont]
        let detailString = NSMutableAttributedString(string: "", attributes: detailTextAttribute)
        let paragraphStyle = NSMutableParagraphStyle()
        detailString.append(NSMutableAttributedString(string: text))
        paragraphStyle.lineSpacing = CGFloat(lineSpacing) // Whatever line spacing you want in points
        detailString.addAttribute(.paragraphStyle,
                                  value: paragraphStyle,
                                  range: NSMakeRange(0, detailString.length))
        return detailString
    }
}

public extension UIColor {
    
    /// 16進数表記のRGB文字列からUIColorを生成する
    ///
    /// - Parameters:
    ///   - hexString: RGBの16進数表記, #は付けても付けなくてもいい, ( e.g. "#FF00FF" (紫) )
    ///   - alphaHexString: アルファ値の16進数表記, 00~FF, #は付けない, ( e.g. "FF" (完全不透明) )
    convenience init(hexString: String, alphaHexString: String = "FF") {
        var cString: String = hexString.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines as NSCharacterSet) as CharacterSet)
            .uppercased()
            .replacingOccurrences(of: "#", with: "")
        
        if cString.count != 6 {
            cString = "FFFFFF"
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        var alphaValue: UInt32 = 0
        Scanner(string: alphaHexString).scanHexInt32(&alphaValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alphaValue) / 255.0
        )
    }
    
    /// 16進数のARGB文字列からUIColorを生成する
    ///
    /// - Parameter alphaRGBHexString: ARGBの16進数表記, #は付けても付けなくてもいい, ( e.g. "#80FF0000" (透明度50%, 赤) )
    convenience init(alphaRGBHexString: String) {
        let cString: String = alphaRGBHexString.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines as NSCharacterSet) as CharacterSet)
            .uppercased()
            .replacingOccurrences(of: "#", with: "")
        
        let alphaString = String(cString.prefix(2))
        let rgbString = String(cString.suffix(cString.count - 2))
        
        self.init(hexString: rgbString, alphaHexString: alphaString)
    }
    
    /// 16進数のRGBA文字列からUIColorを生成する
    ///
    /// - Parameter rgbAlphaHexString: RGBAの16進数表記, #は付けても付けなくてもいい, ( e.g. "#0000FF80" (透明度50%, 青) )
    convenience init(rgbAlphaHexString: String) {
        let cString: String = rgbAlphaHexString.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines as NSCharacterSet) as CharacterSet).uppercased()
        
        let alphaString = String(cString.suffix(2))
        let rgbString = String(cString.prefix(cString.count - 2))
        
        self.init(hexString: rgbString, alphaHexString: alphaString)
    }
    
    /**
     alpha調整
     */
    func alpha(alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }
}
