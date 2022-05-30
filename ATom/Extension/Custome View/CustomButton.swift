//
//  CustomButton.swift
//  ATom
//
//  Created by phan.the.chau on 11/13/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(named: "4f79fc")
    }
}
