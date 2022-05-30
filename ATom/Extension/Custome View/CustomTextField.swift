//
//  CustomTextField.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 1/10/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addUnderline()
    }
    
    private func addUnderline() {
        let border = CALayer()
         border.borderColor = #colorLiteral(red: 0.7892806155, green: 0.7892806155, blue: 0.7892806155, alpha: 0.6624839469)
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1.0, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = 1.0
         self.layer.addSublayer(border)
         self.layer.masksToBounds = true
    }
    
    func setTextLabelInsilde(text: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        label.font = UIFont(name: label.font.fontName, size: 12)
        label.text = text
        label.textColor = #colorLiteral(red: 0.5607843137, green: 0.5843137255, blue: 0.6352941176, alpha: 1)
        self.rightView = label
        self.rightViewMode = .always
    }
}
