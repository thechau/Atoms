//
//  Component.swift
//  ATOM
//
//  Created by Admin on 10/04/2022.
//

import Foundation
import UIKit

enum NumberEkg: Int {
  case oneEkg = 1
  case threeEkg = 3
  case sixEkg = 6
  case twelveEkg = 12
  
  func getImageIcon() -> UIImage? {
    switch self {
    case .oneEkg:
      return UIImage(named: "lead1")
    case .threeEkg:
      return UIImage(named: "lead3")
    case .sixEkg:
      return UIImage(named: "lead6")
    case .twelveEkg:
      return UIImage(named: "lead12")
    }
  }
  
  func getTitle() -> String {
    switch self {
    case .oneEkg:
      return "One Lead EKG"
    case .threeEkg:
      return "Three Lead EKG"
    case .sixEkg:
      return "Six Lead EKG"
    case .twelveEkg:
      return "Twelve Lead EKG"
    }
  }
}
let textColor = UIColor(red: 76/255, green: 81/255, blue: 98/255, alpha: 1)
