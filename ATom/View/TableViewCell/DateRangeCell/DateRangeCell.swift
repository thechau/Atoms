//
//  DateRangeCell.swift
//  Test
//
//  Created by nguyen.vuong.thanh.loc on 11/13/19.
//  Copyright © 2019 vuongthanhloc. All rights reserved.
//

import UIKit

class DateRangeCell: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            checkImage.image = #imageLiteral(resourceName: "ic-check")
        } else {
            checkImage.image = #imageLiteral(resourceName: "ic-circle")
        }
        
    }
    
}
