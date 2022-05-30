//
//  RecordingInformationController.swift
//  SelectGender
//
//  Created by Issac Innerbus on 9/25/19.
//  Copyright © 2019 Tuan Le. All rights reserved.
//

import UIKit
import CoreLocation

class RecordingInformationController: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var txtId: ACFloatingTextfield!
    @IBOutlet weak var txtEmail: ACFloatingTextfield!
    @IBOutlet weak var txtContact: ACFloatingTextfield!
    @IBOutlet weak var txtRefered: ACFloatingTextfield!
    @IBOutlet weak var txtLocation: ACFloatingTextfield!
    @IBOutlet weak var txtComment: ACFloatingTextfield!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var viewShadow:UIView!
    @IBOutlet weak var bottomConstraint:NSLayoutConstraint!
    @IBOutlet weak var leftTitle:NSLayoutConstraint!
    @IBOutlet weak var leftImgDoctor:NSLayoutConstraint!
    @IBOutlet weak var leftViewInfo:NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //   btnReport.layer.cornerRadius = 20
        self.leftViewInfo.constant = UIScreen.main.bounds.size.width
        self.leftImgDoctor.constant = UIScreen.main.bounds.size.width
        self.leftTitle.constant = UIScreen.main.bounds.size.width
        
        customNextButton()
        myView.layer.applySketchShadow()
        myView.layer.cornerRadius = 20
        locationManager.delegate = self
        setUpTextfield()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
//        adjustingHeight(show: true, notification: notification)
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 80
            }
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    func setUpTextfield(){
        txtId.delegate = self
        txtEmail.delegate = self
        txtContact.delegate = self
        txtRefered.delegate = self
        txtLocation.delegate = self
        txtComment.delegate = self
        
        txtId.selectedLineColor = UIColor(hex: "d4d6df")
        txtId.lineColor = UIColor(hex: "d4d6df")
        txtId.placeHolderColor = UIColor(hex: "4c5162")
        txtId.selectedPlaceHolderColor = UIColor(hex: "4c5162")
        txtId.textColor = UIColor(hex: "4f79fc")
        
        txtEmail.selectedLineColor = UIColor(hex: "d4d6df")
        txtEmail.lineColor = UIColor(hex: "d4d6df")
        txtEmail.placeHolderColor = UIColor(hex: "4c5162")
        txtEmail.selectedPlaceHolderColor = UIColor(hex: "4c5162")
        txtEmail.textColor = UIColor(hex: "4f79fc")
        
        txtContact.selectedLineColor = UIColor(hex: "d4d6df")
        txtContact.lineColor = UIColor(hex: "d4d6df")
        txtContact.placeHolderColor = UIColor(hex: "4c5162")
        txtContact.selectedPlaceHolderColor = UIColor(hex: "4c5162")
        txtContact.textColor = UIColor(hex: "4f79fc")
        
        txtRefered.selectedLineColor = UIColor(hex: "d4d6df")
        txtRefered.lineColor = UIColor(hex: "d4d6df")
        txtRefered.placeHolderColor = UIColor(hex: "4c5162")
        txtRefered.selectedPlaceHolderColor = UIColor(hex: "4c5162")
        txtRefered.textColor = UIColor(hex: "4f79fc")
        
        txtLocation.selectedLineColor = UIColor(hex: "d4d6df")
        txtLocation.lineColor = UIColor(hex: "d4d6df")
        txtLocation.placeHolderColor = UIColor(hex: "4c5162")
        txtLocation.selectedPlaceHolderColor = UIColor(hex: "4c5162")
        txtLocation.textColor = UIColor(hex: "4f79fc")
        
        
        txtComment.selectedLineColor = UIColor(hex: "d4d6df")
        txtComment.lineColor = UIColor(hex: "d4d6df")
        txtComment.placeHolderColor = UIColor(hex: "4c5162")
        txtComment.selectedPlaceHolderColor = UIColor(hex: "4c5162")
        txtComment.textColor = UIColor(hex: "4f79fc")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.btnEnableStatus()
    }
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ street: String?, _ city:  String?,_ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.name,
                       placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { street, city, country, error in
            // guard let city = city,
            guard let country = country,let street = street,let city = city, error == nil else { return }
            //print(city + ", " + country)
            self.txtLocation.text = ("\(street),\(city),\(country)")
            self.locationManager.stopUpdatingLocation()
        }
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
    
    @IBAction func  getCurrentLocation(sender: UIButton){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    @IBAction func nextAction(sender: UIButton){
        sender.shakeUpDownButton()
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "showQCR"),
                                        object: self,
                                        userInfo: nil)
        navigationController?.popToRootViewController(animated: false)
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
            self.leftImgDoctor.constant = 0
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
    
    @IBAction func onActionBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


