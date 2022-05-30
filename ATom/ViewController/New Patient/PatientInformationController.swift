//
//  PatientInformationController.swift
//  SelectGender
//
//  Created by Issac Innerbus on 9/23/19.
//  Copyright © 2019 Tuan Le. All rights reserved.
//

import UIKit

class PatientInformationController: UIViewController,CAAnimationDelegate {

    @IBOutlet weak var sgSmokeLevel: WMSegment!
    @IBOutlet weak var sgDrinkLevel: WMSegment!
    @IBOutlet weak var sgActivityLevel: WMSegment!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var viewShadow:UIView!
    @IBOutlet weak var imgPen:UIImageView!
    @IBOutlet weak var imgReport:UIImageView!
    @IBOutlet weak var imgPlus:UIImageView!
    @IBOutlet weak var topViewInfo:NSLayoutConstraint!
    @IBOutlet weak var leftPlus:NSLayoutConstraint!
    @IBOutlet weak var rightPen:NSLayoutConstraint!
    @IBOutlet weak var leftViewInfo: NSLayoutConstraint!
    @IBOutlet weak var imgAnimation:UIImageView!
    @IBOutlet weak var leftTitle: NSLayoutConstraint!
    @IBOutlet weak var leftImgReport: NSLayoutConstraint!
//    var imagesListArray = [CGImage]()
    var lastImage: UIImage?
    var recordingInformation:RecordingInformationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI(){
        self.viewInfo.layer.cornerRadius = 10
        self.leftViewInfo.constant = UIScreen.main.bounds.size.width
        self.leftImgReport.constant = UIScreen.main.bounds.size.width
        self.leftTitle.constant = UIScreen.main.bounds.size.width
        setUpSmokeLevel()
        customNextButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        recordingInformation = storyboard.instantiateViewController(withIdentifier: "RecordingInformationController") as? RecordingInformationController
        self.add(recordingInformation!, frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size))
        recordingInformation?.view.isHidden = true
    }

    func setUpSmokeLevel(){
        sgSmokeLevel.buttonTitles = "No Smoking,Moderate,High"
        sgSmokeLevel.buttonImages = "no_smoking,moderate_smoking,high_smoking"
//        sgSmokeLevel.isRounded = true
        sgSmokeLevel.textColor = UIColor(hex: "929fae")
        sgSmokeLevel.selectorTextColor = UIColor(hex: "4c5162")
        sgSmokeLevel.selectorColor = UIColor(hex: "f3f3f3")
        sgSmokeLevel.SelectedFont = UIFont(name: "Roboto-Regular", size: 13)!
        sgSmokeLevel.bgColor = UIColor.white
        sgSmokeLevel.backgroundColor = UIColor.clear
        sgSmokeLevel.normalFont = UIFont(name: "Roboto-Regular", size: 12)!
        sgSmokeLevel.addTarget(self, action: #selector(segmentValueChange(_:)), for: .valueChanged)
        
        sgDrinkLevel.buttonTitles = "No Drinking,Moderate,High"
        sgDrinkLevel.buttonImages = "no_drinking,moderate_drinking,high_drinking"
        sgDrinkLevel.textColor = UIColor(hex: "929fae")
        sgDrinkLevel.selectorTextColor = UIColor(hex: "4c5162")
        sgDrinkLevel.selectorColor = UIColor(hex: "f3f3f3")
        sgDrinkLevel.SelectedFont = UIFont(name: "Roboto-Regular", size: 13)!
        sgDrinkLevel.bgColor = UIColor.white
        sgDrinkLevel.backgroundColor = UIColor.clear
        sgDrinkLevel.normalFont = UIFont(name: "Roboto-Regular", size: 12)!
        sgDrinkLevel.addTarget(self, action: #selector(segmentValueChange(_:)), for: .valueChanged)
        
        sgActivityLevel.buttonTitles = "Active,Moderate,Low"
        sgActivityLevel.buttonImages = "high_exercise,moderate_exercise,low_exercise"
        sgActivityLevel.textColor = UIColor(hex: "929fae")
        sgActivityLevel.selectorTextColor = UIColor(hex: "4c5162")
        sgActivityLevel.selectorColor = UIColor(hex: "f3f3f3")
        sgActivityLevel.SelectedFont = UIFont(name: "Roboto-Regular", size: 13)!
        sgActivityLevel.bgColor = UIColor.white
        sgActivityLevel.backgroundColor = UIColor.clear
        sgActivityLevel.normalFont = UIFont(name: "Roboto-Regular", size: 12)!
        sgActivityLevel.addTarget(self, action: #selector(segmentValueChange(_:)), for: .valueChanged)
    }
    
    func customNextButton(){
        btnNext.applyGradient(colours: UIColor().colorGradientDisable())
        //add shadow
        viewShadow.layer.cornerRadius = viewShadow.frame.size.height/2
        viewShadow.layer.shadowColor = UIColor(hex: "b2cff3").cgColor
        viewShadow.layer.shadowOffset = CGSize(width: 0, height: 19)
        viewShadow.layer.shadowRadius = 10
        viewShadow.layer.shadowOpacity = 1
    }
    
    func btnDisableStatus(){
        btnNext.isUserInteractionEnabled = false
        btnNext.updateGradient(colours: UIColor().colorGradientDisable())
    }
    
    func btnEnableStatus(){
        btnNext.isUserInteractionEnabled = true
        btnNext.updateGradient(colours: UIColor().colorGradientActive())
    }
    
    @IBAction func segmentValueChange(_ sender: WMSegment) {
        imgPen.shakeLeftRightImage()
        btnEnableStatus()
    }
    
    @IBAction func nextAction(sender: UIButton){
        sender.shakeUpDownButton()
        
        UIView.animate(withDuration: 0.8, animations: {
            self.leftViewInfo.constant = -(UIScreen.main.bounds.size.width)
            self.leftImgReport.constant = -(UIScreen.main.bounds.size.width)
            self.leftTitle.constant = -(UIScreen.main.bounds.size.width)
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.recordingInformation?.view.isHidden = false
            self.recordingInformation?.setUpUIAnimation()
        }
    }
    
    func disappearImgReport() {
        UIView.animate(withDuration: 0.8, animations: {
            self.leftImgReport.constant = -(UIScreen.main.bounds.size.width)
            self.view.setNeedsDisplay()
        }) { (finished) in
        }
    }
    func disappearTitle(){
        UIView.animate(withDuration: 0.8, animations: {
            self.leftTitle.constant = -(UIScreen.main.bounds.size.width)
            self.view.setNeedsDisplay()
        }) { (finished) in
            self.recordingInformation?.view.isHidden = false
            self.recordingInformation?.setUpUIAnimation()
        }
    }
    
    func setUpUIAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.appearImgDoctor()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.appearTitle()
        })
        
        UIView.animate(withDuration: 0.8, animations: {
            self.leftViewInfo.constant = 0
            self.view.layoutIfNeeded()
        }) { (finished) in
        }
    }
    
    func appearImgDoctor(){
        UIView.animate(withDuration: 0.8, animations: {
            self.leftImgReport.constant = 0
            self.view.layoutIfNeeded()
        }) { (finished) in
        }
    }
    
    func appearTitle(){
        UIView.animate(withDuration: 0.8, animations: {
            self.leftTitle.constant = 0
            self.view.layoutIfNeeded()
        }) { (finished) in
        }
    }
    
        
    @IBAction func onActionBackButotn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}


