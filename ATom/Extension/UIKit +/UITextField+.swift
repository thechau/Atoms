//
//  UITextField+.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 2/14/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit
extension UITextField {
    func setLeftView(image: UIImage) {
       let iconView = UIImageView(frame: CGRect(x: 10, y: 12, width: 20, height: 20)) // set your Own size
       iconView.image = image
       let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
       self.tintColor = .lightGray
     }
    
    func cornerRadius(value: CGFloat) {
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
    }
}
