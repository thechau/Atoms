//
//  MainElectrodesViewController.swift
//  ATom
//
//  Created by Phan The Chau on 25/02/2022.
//  Copyright © 2022 phan.the.chau. All rights reserved.
//

import UIKit

class MainElectrodesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onActionPositionButotn(_ sender: Any) {
        let vcReport = newViewController(name: "ElectrodesViewController") as! ElectrodesViewController
        navigationController?.pushViewController(vcReport, animated: true)
    }
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "ElectrodesController", bundle: nil) .
            instantiateViewController(withIdentifier: name)
    }
    
    @IBAction func onActionViewARButton(_ sender: Any) {
    }
    
    @IBAction func onActionGalleryButton(_ sender: Any) {
        
    }

}
