//
//  HeaderReportCell.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 12/6/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit

class HeaderReportCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var parentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    func configView() {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
