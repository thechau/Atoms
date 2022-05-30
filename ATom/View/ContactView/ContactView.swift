//
//  ContactView.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 12/3/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit
protocol ContactViewDelegate {
    func closeContactView()
}
class ContactView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    var delegate: ContactViewDelegate?
       override init(frame: CGRect) {
           super.init(frame: frame)
           loadNib()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           loadNib()
       }
    
    func configView() {
        setUp()
    }
    
    func setUp() {
        contentView.tintColor = .clear
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.cornerRadius = 25
    }
    
       private func loadNib() {
           let view: UIView? = (Bundle.main.loadNibNamed("ContactView", owner: self, options: nil)?[0] as? UIView)
           view?.frame = bounds
           view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           if let view = view {
               self.addSubview(view)
            }
        configView()
       }
    
    @IBAction func closeButton(_ sender: UIButton) {
        delegate?.closeContactView()
    }
}
