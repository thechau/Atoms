//
//  CircularCollectionViewCell.swift
//  CircularCollectionView
//
//  Created by Rounak Jain on 10/05/15.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit

class CircularCollectionViewCell: UICollectionViewCell {
  
  var imageName = "" {
    didSet {
      imageView!.image = UIImage(named: imageName)
    }
  }
  
  @IBOutlet weak var imageView: UIImageView?
  @IBOutlet weak var lbWeight: UILabel?
  @IBOutlet weak var lbWeightNumber: UILabel?
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
//    contentView.layer.cornerRadius = 5
//    contentView.layer.borderColor = UIColor.black.cgColor
//    contentView.layer.borderWidth = 1
    contentView.layer.shouldRasterize = true
    contentView.layer.rasterizationScale = UIScreen.main.scale
    contentView.clipsToBounds = true
    
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    imageView!.contentMode = .scaleAspectFill
  }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
    self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
    self.center.y += (circularlayoutAttributes.anchorPoint.y - 3) * (self.bounds.size.height)
  }
  
}
