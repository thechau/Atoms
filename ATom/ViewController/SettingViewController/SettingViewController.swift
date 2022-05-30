//
//  SettingViewController.swift
//  ATom
//
//  Created by Nguyễn Vương Thành Lộc on 2/23/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var confirmLogout: confirmLogoutView!
    @IBOutlet weak var selectWeightView: SwitchView!
    @IBOutlet weak var selectHeightView: SwitchView!
    @IBOutlet weak var selectFromTypeView: SwitchView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        selectFromTypeView.setTitleForButton(titleButton1: "Standard", titleButton2: "Graphical")
        selectHeightView.setTitleForButton(titleButton1: "Centimeters", titleButton2: "Feet/inch")
        selectWeightView.setTitleForButton(titleButton1: "Pound", titleButton2: "Kg")
        confirmLogout.delegate = self
        confirmLogout.isHidden = true
    }
    
    @IBAction func signoutButton(_ sender: CustomButtom) {
        confirmLogout.isHidden = false
    }
    
    @IBAction func onActionCloseButton(_ sender: CustomButtom) {
        popView()
    }
    
    func popView() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: ConfirmLogoutViewDelegate

extension SettingViewController: ConfirmLogoutViewDelegate {
    func cancleAction() {
        confirmLogout.isHidden = true
    }
    
    func yesAction() {
        confirmLogout.isHidden = true
        popView()
    }
}
