//
//  DashBoardElectrodesCollectionViewCell.swift
//  ATom
//
//  Created by phan.the.chau on 12/16/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit
import SceneKit

protocol DashBoardElectrodesCollectionViewCellDelegate: AnyObject {
  func dashBoardElectrodesCollectionViewCell(cell: DashBoardElectrodesCollectionViewCell, onTapNext sender: Any?)
}

class DashBoardElectrodesCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var nextButton: CustomButtom!
  weak var delegate: DashBoardElectrodesCollectionViewCellDelegate?
  
  @IBAction func onClickNextButton(_ sender: Any) {
    delegate?.dashBoardElectrodesCollectionViewCell(cell: self, onTapNext: nil)
  }
}
