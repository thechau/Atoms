//
//  TitleClvCell.swift
//  ATOM
//
//  Created by Admin on 09/04/2022.
//

import Foundation
import UIKit

class TitleClvCell: UICollectionViewCell {
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!

  override class func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func set(_ number: NumberEkg) {
    iconImageView.image = number.getImageIcon()
    titleLabel.text = number.getTitle()
  }
}
