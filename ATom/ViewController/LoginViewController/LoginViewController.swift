//
//  LoginViewController.swift
//  ATom
//
//  Created by phan.the.chau on 11/12/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let arr = [3, 6 , 5 , 8, 10, 20, 15]
    // 3 5 67 98 3
    func almostIncreasingSequence(sequence: [Int], index: Int = 0, unique: Int = -1, checkUni: Bool = false ) -> Bool {
        var uni = unique
        if !checkUni {
            var flag = false
            var arr = sequence.sorted()
            for i in 0 ..< arr.count - 1 {
                if arr[i] == arr[i + 1] {
                    if flag {
                        return false
                    }
                    flag = true
                    uni = arr[i]
                }
            }
        }
        if index > sequence.count - 1 {
            return false
        } else {
            var temp = sequence
            var temp2 = sequence
            let listSet = Set(temp)
            if uni == temp2.remove(at: index) || uni == -1 {
                let findListSet = Set(temp2.sorted())
                if findListSet.isSubset(of: listSet) {
                    return true
                }
            }
            return almostIncreasingSequence(sequence: temp, index: index + 1, unique: uni, checkUni: true)
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func onActionSignInButton(_ sender: Any) {
        let mainView = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "PageMainDashBoardViewController")
        mainView.modalPresentationStyle = .overFullScreen
        self.present(mainView, animated: true, completion: nil)
    }
    
    @IBAction func onActionSignUpButton(_ sender: Any) {
        
    }
}
