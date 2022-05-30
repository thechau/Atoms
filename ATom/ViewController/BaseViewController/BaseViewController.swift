//
//  BaseViewController.swift
//  ATom
//
//  Created by Nguyễn Vương Thành Lộc on 1/12/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private var menuButton = UIButton(type: .custom)
    private var backButton = UIButton(type: .custom)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //customeNavigation()
        print("SHOWING>> [\(self.classForCoder)]")
    }
    
    func customeNavigation() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9449954033, green: 0.9451572299, blue: 0.9449852109, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "iconsBackLargeActive")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "iconsBackLargeActive")
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: UIBarButtonItem.Style.plain,
                                                           target: nil,
                                                           action: nil)
        removeBackButtonTitle()
        addButtonOnNavi()
        addActionForButton()
        addLogoCenterNavi()
    }
    
    func customeNavigation2() {
        navigationController?.navigationBar.barTintColor = .clear//#colorLiteral(red: 0.9449954033, green: 0.9451572299, blue: 0.9449852109, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "iconsBackLargeActive")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "iconsBackLargeActive")
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: UIBarButtonItem.Style.plain,
                                                           target: nil,
                                                           action: nil)
        removeBackButtonTitle()
        addButtonOnNavi()
        addActionForButton()
        addLogoCenterNavi()
    }
    
    private func addLogoCenterNavi() {
        let x = ((navigationController?.navigationBar.frame.width)! / 2) - 40
        let y = ((navigationController?.navigationBar.frame.height)! / 2) - 10
        let iconApp = UIImageView(frame: CGRect(x: x, y: y, width: 80, height: 20))
        iconApp.image = UIImage(named: "logo")
        navigationController?.navigationBar.addSubview(iconApp)
    }
    
    private func addButtonOnNavi() {
        menuButton = UIButton(type: .custom)
        menuButton.setImage(#imageLiteral(resourceName: "hamburger"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton = UIButton(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "iconsBackLargeActive"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //        menuButton.addTarget(self, action: #selector(selectStateOfScreen), for: .touchUpInside)
        let rightBarItem = UIBarButtonItem(customView: menuButton)
        let leftBarItem = UIBarButtonItem(customView: backButton)
        let rightWidth = rightBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        rightWidth?.isActive = true
        let rightHeight = rightBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        rightHeight?.isActive = true
        let leftWidth = leftBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        leftWidth?.isActive = true
        let leftHeight = leftBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        leftHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.leftBarButtonItem = leftBarItem
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func addActionForButton() {
        backButton.addTarget(self, action: #selector(self.backView), for: .touchUpInside)
    }
    
    @objc private func backView() {
        self.navigationController?.popViewController(animated: true)
    }
  
  @IBAction func onTapPopButton() {
      self.navigationController?.popViewController(animated: true)
  }

    private func removeBackButtonTitle() {
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
