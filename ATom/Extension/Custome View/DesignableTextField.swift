//
//  DesignableTextField.swift
//  UIComponent
//
//  Created by phan.duong.ngoc on 9/13/19.
//  Copyright © 2019 teamLab. All rights reserved.
//

import UIKit

@IBDesignable
public class DesignableTextField: UITextField {
    // MARK: - Corner
    
    @IBInspectable var cornerRadius: CGFloat {
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
    
    // MARK: - Text padding left
    @IBInspectable var paddingLeft: CGFloat {
        get {
            return leftView?.frame.size.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    // MARK: - Text padding right
    @IBInspectable var paddingRight: CGFloat {
        get {
            return rightView?.frame.size.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    // MARK: - Border
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
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
