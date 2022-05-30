//
//  circleView.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 12/3/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit

class circleView: UIView {
    
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
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
}
