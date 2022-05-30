//
//  DashBoardViewController.swift
//  ATom
//
//  Created by phan.the.chau on 11/26/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit
import SceneKit
import SceneKit.ModelIO
import SlideMenuControllerSwift

class DashBoardViewController: UIViewController {
    
    // MARK: -- IBOutlets
    @IBOutlet weak var topConstraintCollectionView: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintGrayView: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shadownLabel: UILabel!
    @IBOutlet weak var failedToConnectView: FailedToconnectDeviceView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomCancelButtonContraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var leftArrowContraint: NSLayoutConstraint!
    @IBOutlet weak var reightArrowContraint: NSLayoutConstraint!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var viewBackground: UIView!
    
    var reportButton: (() -> Void)?
    var startERCButton: (() -> Void)?
    var showPatienInformation: (() -> Void)?
    
    var button: HamburgerButton! = nil
    var isShowECR = false
    
    struct SceneKitComponents {
        
    }
    
    var worldNode: SCNNode!
    var textViewNode: SCNNode!
    var menuNode: SCNNode!
    var gradientNode: SCNNode!
    var gradientNode2: SCNNode!
    
    var boxNode: SCNNode!
    
    var logoNode: SCNNode!
    var deviceNode: SCNNode!
    var atomTextNode: SCNNode!
    var simpleTextNode: SCNNode!
    var backgroundNode: SCNNode!
    var circleNode1: SCNNode!
    let cameraNode = SCNNode()
    
    var scene = SCNScene()
    
    
    var circleNodeAction = SCNAction()
    
    var backgroundColor = UIColor.init(hex: "f3f3f3")
    
    var nameButton1 = "New Patient"
    var nameButton2 = "Existing Patient"
    var nameButton3 = "Quick ECG"
    
    var zPositionCamera: CGFloat = 0
    var textColor = UIColor(red: 50 / 255.0,
                            green: 50 / 255.0,
                            blue: 50 / 255.0,
                            alpha: 1)
    
    var options = NodeOptions()
    
    struct NodeOptions {
        let fontMenu = UIFont.init(name: "Roboto-Light", size: 5)
        let scaleNode = SCNVector3(0.9, 0.9, 0.9)
        let nameDevice = "1.dae"
    }
    
    enum Status {
        case first
        case second
        case three
    }
    
    var currentStatus = Status.first
    var animationStatus = Status.first
    var timer = Timer()
    var cuontConnect = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSnenKit()
        configCollectionView()
        addFakeShadownModel()
        NotificationCenter.default.addObserver(self, selector: #selector(updateECR), name: NSNotification.Name.init(rawValue: "showQCR"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isShowECR {
            after(interval: 1) {
                self.showQuickEGC()
            }
            isShowECR = false
        }
    }
    
    @objc func updateECR() {
        isShowECR = true
    }
    
    @IBAction func onActionElectrodes(_ sender: Any) {
        startERCButton?()
    }
    
    
    func showPatientInformationController() {
        let patient = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GenderAndSexSelectionViewController")  as! GenderAndSexSelectionViewController
        self.navigationController?.pushViewController(patient, animated: true)
    }
    
    func showSearchScreen() {
        let ub = UIStoryboard(name: "ReportSTB", bundle: nil)
        let vc = ub.instantiateViewController(withIdentifier: "SearchPatientViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showQuickEGC() {
        animation2()
    }
    
    @IBAction func onActionReport(_ sender: Any) {
        reportButton?()
    }
    
    @IBAction func onActionStart(_ sender: CustomButtom) {
        animation1()
    }
}

func after(interval: TimeInterval, completion: (() -> Void)?) {
    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
        completion?()
    }
}

extension DashBoardViewController: FailedToconnectDeviceViewDelegate {
    func retryButton() {
        isShowFailedToConnect(isShow: false)
        connectDevice()
    }
}
