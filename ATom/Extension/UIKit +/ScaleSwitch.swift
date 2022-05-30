//
//  File.swift
//  ATom
//
//  Created by Phan The Chau on 29/05/2022.
//  Copyright © 2022 phan.the.chau. All rights reserved.
//

import Foundation
import UIKit

class ScaleSwitch: UISwitch {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        thumbTintColor = UIColor(red: 79/255, green: 121/255, blue: 252/255, alpha: 1)
        onTintColor = UIColor.white
        tintColor = UIColor.white
        self.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }
}

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
