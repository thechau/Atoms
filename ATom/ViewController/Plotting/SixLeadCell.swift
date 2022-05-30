//
//  SixLeadCell.swift
//  ATOM
//
//  Created by Admin on 10/04/2022.
//

import UIKit

class SixLeadCell: UICollectionViewCell {
  @IBOutlet weak var label1: UILabel!
  @IBOutlet weak var label2: UILabel!
  @IBOutlet weak var label3: UILabel!
  @IBOutlet weak var label4: UILabel!
  @IBOutlet weak var label5: UILabel!
  @IBOutlet weak var label6: UILabel!
  
  @IBOutlet weak var backgroundGradient: UIView!
  
  let gradient:CAGradientLayer = CAGradientLayer()
  private var listLabel: [UILabel] = []
  
  override func awakeFromNib() {
    super.awakeFromNib()
    listLabel = [label1, label2, label3, label4, label5, label6]
    backgroundGradient.layer.cornerRadius = backgroundGradient.frame.height / 2
    backgroundGradient.clipsToBounds = true
  }
  
  func set(titles: [String], isHighlight: Bool) {
    for index in 0 ..< titles.count {
      listLabel[index].text = titles[index]
    }
    setHighlight(isHighlight)
  }
  
  private func setHighlight(_ isHighlight: Bool) {
    if isHighlight {
      for label in listLabel {
        label.textColor = .white
      }
    } else {
      for label in listLabel {
        label.textColor = textColor
      }
    }
    layoutIfNeeded()
    backgroundGradient.addGradient(isHiglight: isHighlight, gradient: gradient)
    
  }
}
