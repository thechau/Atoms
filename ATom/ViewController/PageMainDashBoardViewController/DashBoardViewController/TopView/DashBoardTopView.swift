//
//  DashBoardTopView.swift
//  ATom
//
//  Created by phan.the.chau on 3/10/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit

protocol DashBoardTopViewProtocol: class {
    func onActionMenuButton()
    func onActionBackButton()
}

class DashBoardTopView: UIView {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var hamburgerButton: UIButton!
    
    weak var delegate: DashBoardTopViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    private func loadNib() {
        let view: UIView? = (Bundle.main.loadNibNamed("DashBoardTopView", owner: self, options: nil)?[0] as? UIView)
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let view = view {
            self.addSubview(view)
        }
        
        let button = HamburgerButton(frame: CGRect(x: 356, y: 6, width: 50, height: 40))
        hamburgerButton.isHidden = true
        button.addTarget(self, action: #selector(toggle(_:)), for:.touchUpInside)
        self.addSubview(button)
    }
    
    
    @objc func toggle(_ sender: AnyObject!) {
        delegate?.onActionMenuButton()
    }

}
