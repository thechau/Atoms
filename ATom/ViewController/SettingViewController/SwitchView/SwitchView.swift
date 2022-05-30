//
//  SwitchView.swift
//  ATom
//
//  Created by Nguyễn Vương Thành Lộc on 2/23/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit

class SwitchView: UIView {
    @IBOutlet weak var value1Button: UIButton!
    @IBOutlet weak var value2Button: UIButton!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    
    func loadViewFromNib() {
        let view: UIView? = (Bundle.main.loadNibNamed("SwitchView", owner: self, options: nil)?[0] as? UIView)
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view!)
        configView()
    }
    
    private func configView() {
           selectView.layer.borderWidth = 1
           selectView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
           selectView.tintColor = .clear
           selectView.layer.shadowColor = UIColor(hex: "c9cdda").cgColor
           selectView.layer.shadowOffset = CGSize(width: 0, height: 4)
           selectView.layer.shadowRadius = 2
           selectView.layer.shadowOpacity = 1
           selectView.layer.cornerRadius = 18
           contentView.layer.cornerRadius = 18
           value1Button.setTitleColor(UIColor.darkGray, for: .normal)
           value2Button.setTitleColor(UIColor.lightGray, for: .normal)
       }
    
    private func changeTextColorWhenSelect(isLatest: Bool) {
        if isLatest {
            value1Button.setTitleColor(UIColor.darkGray, for: .normal)
            value2Button.setTitleColor(UIColor.lightGray, for: .normal)
        } else {
            value2Button.setTitleColor(UIColor.darkGray, for: .normal)
            value1Button.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
    private func setPositionSelectView(_ x: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.selectView.frame.origin.x = x
        }
    }
    
    @IBAction func selectTypeReportButton(_ sender: UIButton) {
        let positionX = sender.tag == 0 ? 0 : self.frame.width/2
        setPositionSelectView(positionX)
        changeTextColorWhenSelect(isLatest: sender.tag == 0 ? true : false)
    }
    
    func setTitleForButton(titleButton1: String, titleButton2: String) {
        value1Button.setTitle(titleButton1, for: .normal)
        value2Button.setTitle(titleButton2, for: .normal)
    }

}
