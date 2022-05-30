//
//  TagFilterView.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 12/5/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit

class TagFilterView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var circleView: circleView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    private func loadNib() {
        let view: UIView? = (Bundle.main.loadNibNamed("TagFilterView", owner: self, options: nil)?[0] as? UIView)
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let view = view {
            self.addSubview(view)
        }
        contentView.layer.cornerRadius = 10
    }

}
