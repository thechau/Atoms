//
//  CustomButtom.swift
//  Test
//
//  Created by nguyen.vuong.thanh.loc on 11/13/19.
//  Copyright © 2019 vuongthanhloc. All rights reserved.
//

import UIKit
class CustomButtom: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    func setUp() {
        self.tintColor = .clear
        self.layer.cornerRadius = 18
        self.applyGradient(colours: UIColor().colorGradientActive())
    }
}
