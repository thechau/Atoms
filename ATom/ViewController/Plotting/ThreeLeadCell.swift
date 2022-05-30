//
//  ThreeLeadCell.swift
//  ATOM
//
//  Created by Admin on 10/04/2022.
//

import UIKit

class ThreeLeadCell: UICollectionViewCell {
  @IBOutlet weak var label1: UILabel!
  @IBOutlet weak var label2: UILabel!
  @IBOutlet weak var label3: UILabel!
  @IBOutlet weak var backgroundGradient: UIView!
  let gradient:CAGradientLayer = CAGradientLayer()
  private var listLabel: [UILabel] = []
  
  override func awakeFromNib() {
    super.awakeFromNib()
    listLabel = [label1, label2, label3]
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
    backgroundGradient.addGradient(isHiglight: isHighlight, gradient: gradient)
    if isHighlight {
      for label in listLabel {
        label.textColor = .white
      }
    } else {
      for label in listLabel {
        label.textColor = textColor
      }
    }
  }
}
