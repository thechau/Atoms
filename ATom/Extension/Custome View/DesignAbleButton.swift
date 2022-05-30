//
//  DesignAbleButton.swift
//  ATom
//
//  Created by phan.the.chau on 11/13/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit

@IBDesignable
public class DesignableButton: UIButton {
    // MARK: - Corner
    
    override var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var maskedCorners: UInt {
        get {
            return layer.maskedCorners.rawValue
        }
        set {
            layer.maskedCorners = CACornerMask(rawValue: newValue)
        }
    }
    
    // MARK: - Border
    
    override var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    override var borderColor: UIColor? {
        get {
            return layer.borderColor.flatMap(UIColor.init)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // MARK: - Shadow
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return layer.shadowColor.flatMap(UIColor.init)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
}

@IBDesignable
public class DesignableUILabel: UILabel {
    // MARK: - Corner

}

