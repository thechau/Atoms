//
//  PopUpViewController.swift
//  NewTask
//
//  Created by Admin on 14/02/2022.
//

import Foundation
import UIKit

class PopUpViewController: UIViewController {
  @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
      contentView.layer.cornerRadius = 8
      contentView.clipsToBounds = true
    }
  
  @IBAction func onActionClose(_ sender: Any) {
      dismiss(animated: true)
  }
}
