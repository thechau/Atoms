//
//  ReportDashBoardViewController.swift
//  ATom
//
//  Created by phan.the.chau on 3/10/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit

class ReportDashBoardViewController: UIViewController {
    
    @IBOutlet weak var imageReport: UIImageView!
    var backToDashBoardButton: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageReport.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            
            self.imageReport.isHidden = true
        }

    }

    
    @IBAction func onActionReportButton(_ sender: Any) {
        let vcReport = newViewController(name: "ReportViewController") as! ReportViewController
        self.navigationController?.pushViewController(vcReport, animated: true)
    }
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "ReportSTB", bundle: nil) .
            instantiateViewController(withIdentifier: name)
    }
    
    @IBAction func onActionStartECR(_ sender: Any) {
        backToDashBoardButton?()
    }
}
