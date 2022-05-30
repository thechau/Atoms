//
//  PatientOptionCell.swift
//  ATom
//
//  Created by nguyen.vuong.thanh.loc on 11/28/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit

class PatientOptionCell: UITableViewCell {

    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var typePatientLabel: UILabel!
    @IBOutlet weak var patientView: SelectPatientView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showSelect(isShow: Bool) {
        if isShow {
            patientView.showIconCheck(isShow: true)
            patientView.enableSelect(enable: true)

        } else {
            patientView.showIconCheck(isShow: false)
            patientView.enableSelect(enable: false)

        }
    }
    
    private func setTypeTile(color: UIColor, title: String) {
        dotView.backgroundColor = color
        typePatientLabel.textColor = color
        typePatientLabel.text = title
    }
    
    func setTypePatient(type: PatientType) {
        switch type {
        case .alert:
            setTypeTile(color: .red, title: "Alert")
        case .boderLine:
            setTypeTile(color: #colorLiteral(red: 0.9841310382, green: 0.6565454602, blue: 0.1195167229, alpha: 1), title: "Borderline")
        case .normal:
            setTypeTile(color: #colorLiteral(red: 0.4369465709, green: 0.7026609778, blue: 0.2202561498, alpha: 1), title: "Normal")
        default:
            setTypeTile(color: .green, title: "Alert")

        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
