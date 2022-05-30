//
//  TagFilterCell.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 2/12/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit

class TagFilterCell: UICollectionViewCell {
    @IBOutlet weak var subContentView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var circleView: circleView!
    @IBOutlet weak var numberOfProperty: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subContentView.layer.cornerRadius = 10
    }
    
    func setUpCell(type: PatientType, count: Int) {
        switch type {
        case .alert:
            setTypeTile(color: .red, title: "Alert", count: count)
        case .boderLine:
            setTypeTile(color: #colorLiteral(red: 0.9841310382, green: 0.6565454602, blue: 0.1195167229, alpha: 1), title: "Borderline", count: count)
        case .normal:
            setTypeTile(color: #colorLiteral(red: 0.4369465709, green: 0.7026609778, blue: 0.2202561498, alpha: 1), title: "Normal", count: count)
        default:
            setTypeTile(color: .green, title: "Alert", count: count)
            
        }
    }
    
    private func setTypeTile(color: UIColor, title: String, count: Int) {
        circleView.backgroundColor = color
        typeLabel.text = title
        numberOfProperty.text = "\(count)"
    }
}
