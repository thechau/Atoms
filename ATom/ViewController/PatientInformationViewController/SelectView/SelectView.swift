//
//  SelectView.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 1/10/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit

class SelectView: UIView {
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var containerSelectView: UIView!
    @IBOutlet weak var seccondButton: UIButton!
    @IBOutlet weak var thridButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    private func configSelectView() {
        containerSelectView.layer.cornerRadius = 18
        selectedView.layer.borderWidth = 1
        selectedView.layer.borderColor = #colorLiteral(red: 0.3613691926, green: 0.5268543363, blue: 1, alpha: 1)
        selectedView.tintColor = .clear
//        selectedView.layer.shadowColor = UIColor.black.cgColor
//        selectedView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        selectedView.layer.shadowRadius = 4
//        selectedView.layer.shadowOpacity = 0.5
        selectedView.layer.cornerRadius = 18
    }
    
    private func setPositionSelectView(_ x: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.selectedView.frame.origin.x = x
        }
    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        var positionX = CGFloat()
        switch sender.tag {
        case 0:
            positionX = 0
        case 1:
            positionX = containerSelectView.frame.width / 3
        case 2:
            positionX = containerSelectView.frame.width - containerSelectView.frame.width / 3
        default:
            break
        }
        setTextColorForButton(tag: sender.tag)
        setPositionSelectView(positionX)
    }
    
    private func setTextColorForButton(tag: Int) {
        switch tag {
        case 0:
            firstButton.setTitleColor(#colorLiteral(red: 0.3613691926,
                                                    green: 0.5268543363,
                                                    blue: 1,
                                                    alpha: 1), for: .normal)
            seccondButton.setTitleColor(#colorLiteral(red: 7.920323696e-05, green: 0.001984798582, blue: 0.05834064633, alpha: 1), for: .normal)
            thridButton.setTitleColor(#colorLiteral(red: 7.920323696e-05, green: 0.001984798582, blue: 0.05834064633, alpha: 1), for: .normal)
        case 1:
            firstButton.setTitleColor(#colorLiteral(red: 7.920323696e-05, green: 0.001984798582, blue: 0.05834064633, alpha: 1), for: .normal)
            seccondButton.setTitleColor(#colorLiteral(red: 0.3613691926, green: 0.5268543363, blue: 1, alpha: 1), for: .normal)
            thridButton.setTitleColor(#colorLiteral(red: 7.920323696e-05, green: 0.001984798582, blue: 0.05834064633, alpha: 1), for: .normal)
        case 2:
            firstButton.setTitleColor(#colorLiteral(red: 7.920323696e-05, green: 0.001984798582, blue: 0.05834064633, alpha: 1), for: .normal)
            seccondButton.setTitleColor(#colorLiteral(red: 7.920323696e-05, green: 0.001984798582, blue: 0.05834064633, alpha: 1), for: .normal)
            thridButton.setTitleColor(#colorLiteral(red: 0.3613691926, green: 0.5268543363, blue: 1, alpha: 1), for: .normal)
        default:
            break
        }
    }
    
    func setTitleForButton (titles: [String] ) {
        firstButton.setTitle(titles[0],for: .normal)
        seccondButton.setTitle(titles[1],for: .normal)
        thridButton.setTitle(titles[2],for: .normal)
    }
    
    private func loadNib() {
        let view: UIView? = (Bundle.main.loadNibNamed("SelectView", owner: self, options: nil)?[0] as? UIView)
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let view = view {
            self.addSubview(view)
        }
        configSelectView()
    }
}
