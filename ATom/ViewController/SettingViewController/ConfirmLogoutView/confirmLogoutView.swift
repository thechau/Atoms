//
//  ConfirmLogoutView.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 2/26/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit
protocol ConfirmLogoutViewDelegate: class {
    func cancleAction()
    func yesAction()
}
class confirmLogoutView: UIView {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    weak var delegate: ConfirmLogoutViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    private func loadNib() {
        let view: UIView? = (Bundle.main.loadNibNamed("ConfirmLogoutView", owner: self, options: nil)?[0] as? UIView)
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let view = view {
            self.addSubview(view)
        }
        setUp()
    }
    
    private func setUp() {
        shadowView.tintColor = .clear
        contentView.layer.cornerRadius = 30
        applyGradient(colours: UIColor().colorGradientActive())
    }
    
    func applyGradient(colours: [UIColor]){
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colours.map { $0.cgColor }
        gradientLayer.name = "gradient"
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        contentView.clipsToBounds = true
        shadowView.layer.cornerRadius = shadowView.frame.size.height/2
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 19)
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOpacity = 1
    }
    
    @IBAction func yesButton(_ sender: UIButton) {
        delegate?.yesAction()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        delegate?.cancleAction()
    }
}

extension UIView {
    func setUpGradient() { 
        applyGradient2(colours: UIColor().colorGradientActive())
    }
    
    func applyGradient2(colours: [UIColor]){
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colours.map { $0.cgColor }
        gradientLayer.name = "gradient"
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.clipsToBounds = true
    }
}
