//
//  UIColorExtension.swift
//  SelectGender
//
//  Created by Tuan Le on 8/20/19.
//  Copyright © 2019 Tuan Le. All rights reserved.
//
import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hexString).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    func colorGradientActive() -> [UIColor]{
        return [UIColor(hex: "5372ff"), UIColor(hex: "3f97f1")]
    }
    
    func colorGradientDisable() -> [UIColor]{
        return [UIColor(hex: "9caef9"), UIColor(hex: "92c0f2")]
    }
    
}

extension UIButton {

    func shakeUpDownButton() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 1
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x, y: center.y + 5)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x, y: center.y - 5)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
    
    func applyGradient(colours: [UIColor]){
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colours.map { $0.cgColor }
        gradientLayer.name = "gradient"
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height/2
    }
    
    func updateGradient(colours: [UIColor]){
        for item in self.layer.sublayers! {
            if item.name == "gradient" {
                if let gradientLayer = item as? CAGradientLayer{
                    gradientLayer.colors = colours.map { $0.cgColor }
                }
            }
        }
    }
    
}

extension Float {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

extension UIImageView {
    
    func shakeLeftRightImage() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 1
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 10, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 10, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.1,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 11,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 1.0
        if spread == 0
        {
            shadowPath = nil
        }
        else
        {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
