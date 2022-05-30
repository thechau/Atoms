//
//  RegisterViewController.swift
//  ATom
//
//  Created by phan.the.chau on 11/12/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var backBarButton: UIButton!
    @IBOutlet weak var centerYOfPopupViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    private func setUpView() {
        centerYOfPopupViewConstraint.constant = 80
    }
    
    private func setConstraintForPopupView() {
        centerYOfPopupViewConstraint.constant = centerYOfPopupViewConstraint.constant == 0 ? 800 : 0
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @IBAction func onActionSubmitButton(_ sender: Any) {
        setConstraintForPopupView()
    }
    
    @IBAction func onActionCloseButton(_ sender: Any) {
        setConstraintForPopupView()
    }
    
    @IBAction func onActionResendButon(_ sender: Any) {
        setConstraintForPopupView()
    }
    
    @IBAction func onActionBackBarButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
