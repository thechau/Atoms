//
//  MainSlideMenuViewcontrollerViewController.swift
//  ATom
//
//  Created by phan.the.chau on 2/24/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ElectrodecsController: UIViewController {
    
    @IBOutlet weak var widthConstraintManObject: NSLayoutConstraint!
    @IBOutlet weak var manObject: UIImageView!
    
    var backToDashBoardButton: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onActionStartECG(_ sender: Any) {
        backToDashBoardButton?()
    }
    
    @IBAction func onActionElectrodesButton(_ sender: Any) {
        view.layoutIfNeeded()
        self.widthConstraintManObject.constant = 520
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            
        }
    }
    
    @IBAction func onActionPositionButton(_ sender: Any) {
        let vcReport = newViewController(name: "ElectrodesViewController") as! ElectrodesViewController
        navigationController?.pushViewController(vcReport, animated: true)
        
    }
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "ElectrodesController", bundle: nil) .
            instantiateViewController(withIdentifier: name)
    }
}
