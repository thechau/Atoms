//
//  OneLeadCell.swift
//  ATOM
//
//  Created by Admin on 10/04/2022.
//

import UIKit

class OneLeadCell: UICollectionViewCell {
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var backgroundGradient: UIView!
  let gradient:CAGradientLayer = CAGradientLayer()

  override func awakeFromNib() {
    super.awakeFromNib()
    label.text = "1"
    backgroundGradient.layer.cornerRadius = backgroundGradient.frame.height / 2
    backgroundGradient.clipsToBounds = true
  }
  
  func set(title: String, isHighlight: Bool) {
    label.text = title
    setHighlight(isHighlight)
  }
  
  private func setHighlight(_ isHighlight: Bool) {
    backgroundGradient.addGradient(isHiglight: isHighlight, gradient: gradient)
    if isHighlight {
      label.textColor = .white
    } else {
      label.textColor = textColor
    }
  }
}

extension UIView {
  func addGradient(isHiglight: Bool, gradient: CAGradientLayer) {
    let blue1 = UIColor(red: 90/255, green: 115/255, blue: 251/255, alpha: 1).cgColor
    let blue2 = UIColor(red: 90/255, green: 115/255, blue: 251/255, alpha: 0.65).cgColor
    let colorHighlight: [CGColor] = [blue1,blue2]

    gradient.frame.size = bounds.size
    if isHiglight {
      gradient.colors = colorHighlight
    } else {
      gradient.colors = [backgroundColor?.cgColor ?? UIColor.clear.cgColor]
    }
    gradient.startPoint = CGPoint(x: 0.0, y: 0)
    gradient.endPoint = CGPoint(x: 1.0, y: 0)
    layer.addSublayer(gradient)
    layoutIfNeeded()
  }
}
