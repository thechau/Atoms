//
//  DashBoardCollectionViewCell.swift
//  ATom
//
//  Created by phan.the.chau on 12/16/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit
import SceneKit
protocol DashBoardCollectionViewCellDelegate: class {
    func connect()
}

class DashBoardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var connectButton: UIButton!
    
    weak var delegate: DashBoardCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func connectButton(_ sender: UIButton) {
        delegate?.connect()
    }
}
