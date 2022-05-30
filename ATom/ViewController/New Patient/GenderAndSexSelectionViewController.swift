//
//  ViewController.swift
//  SelectGender
//
//  Created by Tuan Le on 8/20/19.
//  Copyright © 2019 Tuan Le. All rights reserved.
//

import UIKit

class GenderAndSexSelectionViewController: UIViewController,
                                           UITextFieldDelegate,
                                           UIScrollViewDelegate,
                                           UpdateScrollIndex,
                                           UICollectionViewDelegate,
                                           UICollectionViewDataSource,
                                           UICollectionViewDelegateFlowLayout {

   // var sgGender: WMSegment!
    var titleView: UIView!
    @IBOutlet weak var sgGender:WMSegment!
    
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var viewShadow:UIView!
    @IBOutlet weak var txtFullname:ACFloatingTextfield!
    @IBOutlet weak var lbYrs: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftSelectedGender: NSLayoutConstraint!
    @IBOutlet weak var imgGender: UIImageView!
    @IBOutlet weak var bottomScrollviewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topImg: NSLayoutConstraint!
    @IBOutlet weak var leftTxtFullname: NSLayoutConstraint!
    @IBOutlet weak var topSelectedAge: NSLayoutConstraint!
    @IBOutlet var pickerAge: MVHorizontalPicker!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewTop: UIView!
//    @IBOutlet weak var sgGender: WMSegment!
    let maxHeight:Float = 7
    let defaultHeigh:Float = 5.7
    var numbersHeight : [Float] = [Float]()
    var pickerData: [String] = [String]()
    var selectedRow = 40
    var selectedGender = 0
    let reuseIdentifier = "cell"
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    var heightViewController:HeightWeightController?
    var firstTime = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        UIApplication.shared.statusBarStyle = .lightContent
        for i in stride(from: 0, through: maxHeight, by: 0.1).reversed() {
            numbersHeight.append(Float(i).rounded(toPlaces: 1))
        }
        NotificationCenter.default.addObserver(self, selector: #selector(GenderAndSexSelectionViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GenderAndSexSelectionViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        customNavigationBar()
        customNextButton()
        setUpViewAge()
        imgGender.isHidden = true
        collectionView.collectionViewLayout = layout
        //collectionView.isScrollEnabled = false
    }
    
    override func viewWillLayoutSubviews() {
//        sgGender.center.x = titleView.frame.size.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pickerAge.setSelectedItemIndex(selectedRow, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        heightViewController = storyboard.instantiateViewController(withIdentifier: "HeightWeightController") as? HeightWeightController
        self.add(heightViewController!, frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size))
        heightViewController?.view.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //Mark: Setup UI
    
    func customNavigationBar(){
        sgGender.selectorTextColor = UIColor(hex: "4c5162")
        sgGender.selectorColor = UIColor(hex: "f3f3f3")
        sgGender.SelectedFont = UIFont(name: "Roboto-Regular", size: 13)!
        sgGender.bgColor = UIColor(hex: "fefcfc")
        sgGender.normalFont = UIFont(name: "Roboto-Regular", size: 13)!
        sgGender.bgColor = UIColor.white
        sgGender.backgroundColor = UIColor.clear
        sgGender.buttonTitles = "Male,Female"
        sgGender.buttonImages = "male,female"
        sgGender.isRounded = true
        sgGender.textColor = UIColor(hex: "929fae")
        sgGender.addTarget(self, action: #selector(segmentValueChange(_:)), for: .valueChanged)
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
    
    func setUpViewAge(){
        pickerAge.delegate = self
        lbYrs.textColor = UIColor(hex: "929fae")
        pickerAge.tintColor = UIColor(hex: "929fae")
        txtFullname.delegate = self
        txtFullname.font = UIFont(name: "Roboto-Regular", size: 15)!
        for i in 0...100 {
            pickerData.append(String(i))
        }
        pickerAge.titles = pickerData
        pickerAge.itemWidth = UIScreen.main.bounds.size.width/9
    }
    
    //UItextField delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text != "" && selectedRow != 0){
            lbYrs.textColor = UIColor(hex: "4f79fc")
            btnEnableStatus()
            pickerAge.tintColor = UIColor(hex: "4f79fc")
        }else{
           lbYrs.textColor = UIColor(hex: "929fae")
            btnDisableStatus()
            pickerAge.tintColor = UIColor(hex: "929fae")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //Action button
    @IBAction func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuAction() {
        print("menu button press")
    }
    
    @IBAction func nextAction(sender: UIButton){

        self.heightViewController?.selectedAge = selectedRow
        self.heightViewController?.selectedGender = selectedGender
        self.heightViewController?.imgPerson.image = UIImage(named: (self.heightViewController?.getNameImage(age: selectedRow, selectedGender: selectedGender))!)
        self.heightViewController?.setUpWeight(age: selectedRow, selectedGender: selectedGender)
        self.topImg.constant = heightViewController!.getTopImgAnimationScale() + 30.0
        self.leftTxtFullname.constant = -(self.view.frame.size.width/2 + self.txtFullname.frame.size.width)
        self.leftSelectedGender.constant = -(self.view.frame.size.width/2 + self.sgGender.frame.size.width)
        self.topSelectedAge.constant = 200
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layout.invalidateLayout()
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.heightViewController?.view.isHidden = false
            self.heightViewController?.setUpAnimationRuler()
        }
        
    }
    
    @IBAction func segmentValueChange(_ sender: WMSegment) {
        var animated = true
        if(selectedRow == 0){
            animated = false
        }
        switch sender.selectedSegmentIndex {
        case 0:
            selectedGender = 0
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: animated)

        case 1:
            selectedGender = 1
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            collectionView.scrollToItem(at: IndexPath(item: 1, section: 0),
                                        at: .left,
                                        animated: true)
        default:
            print("default item")
        }
    }

    
    @IBAction func pickerValueChanged(sender: AnyObject) {
        selectedRow = pickerAge.selectedItemIndex
    }
    
    func UpdateIndex() {
        if(pickerAge.scrollingIndex == 0){
            btnDisableStatus()
        }else if(pickerAge.scrollingIndex != 0 && txtFullname.text != ""){
            btnEnableStatus()
        }
        
        if let item = collectionView.cellForItem(at: IndexPath(item: selectedGender, section: 0)) as? MyCollectionViewCell{
            
            UIView.transition(with: item.myImg,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { item.myImg.image = UIImage(named: self.getNameImage(age: self.pickerAge.scrollingIndex)) },
                              completion: nil)
        }
    }
    
    //handle Keyboard overlap textfield
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        let userInfo = notification.userInfo!
//        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = CGFloat(120) * (show ? 1 : -1)
        
        UIView.animate(withDuration: animationDurarion, animations: {
            self.bottomConstraint.constant += changeInHeight
            self.layout.invalidateLayout()
            self.view.layoutIfNeeded()
        }, completion: { (finish) in
        })
    }
    
    func getNameImage(age: Int)->String{
        if(selectedGender == 0) {
            if(age == 0){
                return "egg"
            }else if(age >= 1 && age <= 15) {
                return "boy"
            }else if(age >= 16 && age <= 40) {
                return "teen_boy"
            }else {
                return "men"
            }
        } else {
            if(age == 0) {
                return "egg"
            }else if(age >= 1 && age <= 15) {
                return "girl"
            }else if(age >= 16 && age <= 40) {
                return "teen_girl"
            }else {
                return "women"
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(selectedRow != 0){
            cell.alpha = 0.5
//            cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            UIView.animate(withDuration: 1) {
                cell.alpha = 1
                cell.transform = .identity
            }
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath as IndexPath) as! MyCollectionViewCell
        cell.myImg.image = UIImage(named: getNameImage(age: selectedRow))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

}

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var myImg: UIImageView!
}

