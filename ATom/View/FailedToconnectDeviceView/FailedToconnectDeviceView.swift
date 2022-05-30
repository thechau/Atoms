//
//  FailedToconnectDeviceView.swift
//  ATom
//
//  Created by Nguyễn Vương Thành Lộc on 2/8/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit
protocol FailedToconnectDeviceViewDelegate: class {
    func retryButton()
}
class FailedToconnectDeviceView: UIView {
    
    weak var delegate: FailedToconnectDeviceViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    
    func loadViewFromNib() {
        let view: UIView? = (Bundle.main.loadNibNamed("FailedToconnectDeviceView", owner: self, options: nil)?[0] as? UIView)
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view!)
    }

    @IBAction func retryButton(_ sender: UIButton) {
        delegate?.retryButton()
    }
}
