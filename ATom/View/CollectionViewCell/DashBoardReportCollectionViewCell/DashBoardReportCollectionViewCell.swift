//
//  DashBoardReportCollectionViewCell.swift
//  ATom
//
//  Created by phan.the.chau on 12/16/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit
import SceneKit

class DashBoardReportCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var statusConnectLabel: UILabel!
    
    var countStatus = 0
    override func awakeFromNib() {
           super.awakeFromNib()
        animationStatusLabel()
    }
    
    private func animationStatusLabel() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] (Timer) in
            self?.update()
        }
        
    }
    
    private func update() {
        if countStatus == 4 {
            countStatus = 0
        } else {
            countStatus += 1
        }
        
        switch countStatus {
        case 0:
            statusConnectLabel.text = "."
        case 1:
            statusConnectLabel.text = "."
        case 2:
            statusConnectLabel.text = ".."
        case 3:
            statusConnectLabel.text = "..."
        default:
            statusConnectLabel.text = "...."
        }
    }
}
