//
//  MainSlideMenuViewcontrollerViewController.swift
//  ATom
//
//  Created by phan.the.chau on 2/24/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MainSlideViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func OnActionShowSlide(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let mainVC = self.storyboard?.instantiateViewController(identifier: "DashBoardViewController") as! DashBoardViewController
            let rightVC = self.storyboard?.instantiateViewController(identifier: "LeftSlideViewController") as! LeftSlideViewController
            let slideMenuController = SlideMenuController(mainViewController: mainVC, rightMenuViewController: rightVC)
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.pushViewController(slideMenuController, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
}
