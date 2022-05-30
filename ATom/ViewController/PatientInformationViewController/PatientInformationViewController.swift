//
//  PatientInformationViewController.swift
//  ATom
//
//  Created by Nguyen Vuong Thanh Loc on 1/10/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit
import CoreLocation

class PatientInformationViewController: BaseViewController, CLLocationManagerDelegate {
    @IBOutlet weak var viewShadow:UIView!
    @IBOutlet weak var generateReportButton: UIButton!
    @IBOutlet weak var ageTextField: CustomTextField!
    @IBOutlet weak var namePatientTextField: CustomTextField!
    @IBOutlet weak var genderTextFiled: CustomTextField!
    @IBOutlet weak var heightTextField: CustomTextField!
    @IBOutlet weak var weightTextField: CustomTextField!
    @IBOutlet weak var contactTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var sytolicTextField: CustomTextField!
    @IBOutlet weak var diastolicTextField: CustomTextField!
    @IBOutlet weak var SelectSmokingView: SelectView!
    @IBOutlet weak var selectAlcoholView: SelectView!
    @IBOutlet weak var selectActivityView: SelectView!
    @IBOutlet weak var txtId: ACFloatingTextfield!
    @IBOutlet weak var txtRefered: ACFloatingTextfield!
    @IBOutlet weak var txtLocation: ACFloatingTextfield!
    @IBOutlet weak var txtComment: ACFloatingTextfield!
    let genders = ["Men", "Woman"]
    var ages: [String] = []
    var height: [String] = []
    var weight : [String] = []
    let genderPickerView = UIPickerView()
    let agePickerView = UIPickerView()
    let heightPickerView = UIPickerView()
    let weightPickerView = UIPickerView()
    var value1 = ""
    var value2 = "0''"
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        configTextField()
        configSelectView()
        createToolbarForPicker()
        createValueOfPickerView()
        customNextButton()
        locationManager.delegate = self
        

        for picker in [genderPickerView, agePickerView, heightPickerView, weightPickerView] {
            picker.delegate = self
        }
    }
    
    private func createValueOfPickerView() {
        for i in 0...100 {
            ages.append("\(i)")
            weight.append("\(i)")
            height.append("\(i)")
        }
    }
    
    private func configTextField() {
        heightTextField.setTextLabelInsilde(text: "Ft/in")
        weightTextField.setTextLabelInsilde(text: "kg")
        sytolicTextField.setTextLabelInsilde(text: "mmHg")
        diastolicTextField.setTextLabelInsilde(text: "mmHg")
        
        genderTextFiled?.inputView = genderPickerView
        ageTextField?.inputView = agePickerView
        heightTextField?.inputView = heightPickerView
        weightTextField?.inputView = weightPickerView
        
        txtId.delegate = self
        txtRefered.delegate = self
        txtLocation.delegate = self
        txtComment.delegate = self
        
        txtId.selectedLineColor = UIColor(hex: "d4d6df")
        txtId.lineColor = UIColor(hex: "d4d6df")
        txtId.placeHolderColor = UIColor(hex: "4c5162")
        txtId.selectedPlaceHolderColor = UIColor(hex: "4c5162")
        txtId.textColor = UIColor(hex: "4f79fc")
        
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
    
    func customNextButton(){
         generateReportButton.applyGradient(colours: UIColor().colorGradientDisable())
         //add shadow
         viewShadow.layer.cornerRadius = viewShadow.frame.size.height/2
         viewShadow.layer.shadowColor = UIColor(hex: "b2cff3").cgColor
         viewShadow.layer.shadowOffset = CGSize(width: 0, height: 19)
         viewShadow.layer.shadowRadius = 10
         viewShadow.layer.shadowOpacity = 1
     }
    
    private func createToolbarForPicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        leftButton.setBackgroundImage(UIImage(named: "ic-leftBaritem"), for: .normal)
        let leftBarItem = UIBarButtonItem(customView: leftButton)
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        rightButton.setBackgroundImage(UIImage(named: "ic-rightBaritem"), for: .normal)
        let rightBarItem = UIBarButtonItem(customView: rightButton)
        
        let currWidthLeft = leftBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidthLeft?.isActive = true
        let currHeightLeft = leftBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeightLeft?.isActive = true
        
        let currWidthRight = rightBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidthRight?.isActive = true
        let currHeightRight = rightBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeightRight?.isActive = true
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        space.width = 30
        toolBar.setItems([leftBarItem, space, rightBarItem, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        genderTextFiled.inputAccessoryView = toolBar
        for textField in [genderTextFiled, ageTextField, heightTextField, weightTextField] {
            textField?.inputAccessoryView = toolBar
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configSelectView() {
        SelectSmokingView.setTitleForButton(titles: ["No Smoking", "Moderate", "High"])
        selectAlcoholView.setTitleForButton(titles: ["No Drinking", "Moderate", "High"])
        selectActivityView.setTitleForButton(titles: ["Active", "Moderate", "Sedentary"])
        SelectSmokingView.isUserInteractionEnabled = true
        SelectSmokingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(segmentValueChange)))
        selectAlcoholView.isUserInteractionEnabled = true
        
        selectAlcoholView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(segmentValueChange)))
        selectActivityView.isUserInteractionEnabled = true
        
        selectActivityView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(segmentValueChange)))
    }
    
    
    
    @objc func segmentValueChange() {
        btnEnableStatus()
    }
    
    func btnDisableStatus(){
        generateReportButton.isUserInteractionEnabled = false
        generateReportButton.updateGradient(colours: UIColor().colorGradientDisable())
    }
    
    func btnEnableStatus(){
        generateReportButton.isUserInteractionEnabled = true
        generateReportButton.updateGradient(colours: UIColor().colorGradientActive())
    }
    
    private func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ street: String?, _ city:  String?,_ country:  String?, _ error: Error?) -> ()) {
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
    
    @IBAction func  onActionUpdateReport(sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func  getCurrentLocation(sender: UIButton) {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func select() {
        
    }
}

extension PatientInformationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == heightPickerView {
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderPickerView {
            return genders.count
        } else if pickerView == agePickerView {
            return ages.count
        } else if pickerView == heightPickerView {
            return height.count
        } else {
            return weight.count
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderPickerView {
            return genders[row]
        } else if pickerView == agePickerView {
            return ages[row]
        } else if pickerView == heightPickerView {
            if component == 0 {
              return height[row] + "'"
            }
            return height[row] + "''"
        } else {
            return weight[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPickerView {
            genderTextFiled.text = genders[row]
        } else if pickerView == agePickerView {
            ageTextField.text = ages[row]
        } else if pickerView == heightPickerView {
            if component == 0 {
                value1 = height[row] + "'"
            }
            if component == 1 {
                value2 = height[row] + "''"
            }
            selectHeightForTextField()
        } else {
            weightTextField.text = weight[row]
        }
    }
    
    private func selectHeightForTextField() {
        heightTextField.text = "\(value1) \(value2)"
    }
}

extension PatientInformationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.btnEnableStatus()
    }
}

