//
//  BloodPressureController.swift
//  SelectGender
//
//  Created by Tuan Le on 9/8/19.
//  Copyright © 2019 Tuan Le. All rights reserved.
//

import UIKit

class BloodPressureController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewHeight: UITableView!
    @IBOutlet weak var viewParentTable: UIView!
    @IBOutlet weak var viewDragSys: UIView!
    @IBOutlet weak var viewDragDia: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgPerson: UIImageView!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var viewShadow:UIView!
    @IBOutlet weak var lbSys:UILabel!
    @IBOutlet weak var lbDia:UILabel!
    @IBOutlet weak var topViewDragSys: NSLayoutConstraint!
    @IBOutlet weak var topViewDragDia: NSLayoutConstraint!
    @IBOutlet weak var leftRuler: NSLayoutConstraint!
    @IBOutlet weak var leftImg: NSLayoutConstraint!
    @IBOutlet weak var leftTitle: NSLayoutConstraint!
    
    var numbers : [Int] = [Int]()
    var heightCell : CGFloat = 10
    var heightDragView : CGFloat = 40
    var panGesture  = UIPanGestureRecognizer()
    var panGestureDia  = UIPanGestureRecognizer()
    var startingConstant:CGFloat = 0;
    let minBlood = 10
    let maxBlood = 290
    let defaultSystolic = 136
    let defaultDiaStolic = 92
    var changeValue = false
    var selectedAge = 0
    var selectedGender = 0
    var patientInfoController:PatientInformationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in (minBlood...maxBlood).reversed(){
            if(i % 2 == 0){
              numbers.append(i)
            }
            
        }
        
        tableViewHeight.separatorColor = UIColor.clear
        // Do any additional setup after loading the view.
        panGesture = PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(draggedViewSys(_:)))
        panGesture.cancelsTouchesInView = false
        self.viewDragSys.addGestureRecognizer(panGesture)
        
        panGestureDia = PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(draggedViewDia(_:)))
        panGestureDia.cancelsTouchesInView = false
        self.viewDragDia.addGestureRecognizer(panGestureDia)
        customNextButton()
        self.leftRuler.constant = 0
        self.topViewDragSys.constant = UIScreen.main.bounds.size.height
        self.topViewDragDia.constant = UIScreen.main.bounds.size.height
        self.leftTitle.constant = UIScreen.main.bounds.size.width
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        patientInfoController = storyboard.instantiateViewController(withIdentifier: "PatientInformationController") as? PatientInformationController
        self.add(patientInfoController!, frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size))
        patientInfoController?.view.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        let height = viewMain.frame.size.height / CGFloat(numbers.count)
        if(height != heightCell){
            heightCell = height
            setUpLabelBlood()
            self.lbDia.attributedText = self.parseBloodString(number: defaultDiaStolic)
            self.lbSys.attributedText = self.parseBloodString(number: defaultSystolic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(heightCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : BloodTableviewCell =  tableView.dequeueReusableCell(withIdentifier: "HeightCell") as! BloodTableviewCell
        let number = numbers[indexPath.row]
        if(number % 10 == 0){
            cell.lbCenter.font = UIFont.systemFont(ofSize: 25)
            cell.lbCenter.textColor = UIColor(hex: "8e97aa")
        }else{
            if(number % 2 == 0){
                cell.lbCenter.font = UIFont.systemFont(ofSize: 20)
            }else{
                cell.lbCenter.font = UIFont.systemFont(ofSize: 15)
            }
            cell.lbCenter.textColor = UIColor(hex: "d4d6df")
        }
        
        cell.lbCenter.textAlignment = .center
        cell.selectionStyle = .none
        return cell
    }
    
    func setUpLabelBlood(){
        var top: CGFloat = 0.0
        debugPrint("heightCell\(numbers.count)")
        debugPrint("viewMain\(viewMain.frame.size.height)")
        for i in 0...(numbers.count/5) {
            top = (CGFloat(i) * heightCell * 5)
            let lbHeight = UILabel()
            lbHeight.font = UIFont(name: "Roboto-Regular", size: 11)!
            lbHeight.text = "\((Int(maxBlood) - i*10))"
            lbHeight.textColor = UIColor(hex: "4c5162")
            self.viewMain.addSubview(lbHeight)
            lbHeight.translatesAutoresizingMaskIntoConstraints = false
            if(i % 2 == 0){
                viewMain.addConstraint(lbHeight.makeConstraint(attribute: .leading, toView: viewParentTable, constant: -25))
            }else{
                viewMain.addConstraint(lbHeight.makeConstraint(attribute: .trailing, toView: viewParentTable, constant: 25))
            }
            
            viewMain.addConstraint(lbHeight.makeConstraint(attribute: .top, toView: viewMain, constant: top - 3))
        }
        
    }
    
    
    @objc func draggedViewSys(_ gestureRecognizer:UIPanGestureRecognizer){
        //        self.view.layoutIfNeeded()
        switch gestureRecognizer.state {
            
        case .began:
            self.startingConstant = self.topViewDragSys.constant
        case .possible:
            debugPrint("possible")
            break
        case .changed:
            if(!changeValue){
                changeValue = true
                btnEnableStatus()
            }
            let translation = gestureRecognizer.translation(in: self.view)
            let percent = round(Float(gestureRecognizer.view!.center.y)/Float(heightCell))
            debugPrint(percent)
            if(self.startingConstant + translation.y >= -20 && self.startingConstant + translation.y <=  self.viewMain.frame.size.height - 20){
                self.topViewDragSys.constant = self.startingConstant + translation.y
            }
            if(percent > 0 && Int(percent) <= (numbers.count - 1)){
                lbSys.attributedText = self.parseBloodString(number: numbers[Int(percent - 1)])
            }else if(percent == 0){
                lbSys.attributedText = self.parseBloodString(number: numbers[0])
            }else{
                lbSys.attributedText = self.parseBloodString(number: minBlood)
            }
        case .ended:
            let percent = round(Float(gestureRecognizer.view!.center.y)/Float(heightCell))
            if(percent > 0 && Int(percent) <= (numbers.count - 1)){
                lbSys.attributedText = self.parseBloodString(number: numbers[Int(percent - 1)])
            }else if(percent == 0){
                lbSys.attributedText = self.parseBloodString(number: numbers[0])
            }else{
                lbSys.attributedText = self.parseBloodString(number: minBlood)
            }
        case .cancelled:
            debugPrint("cancel")
            break
        case .failed:
            debugPrint("failed")
            break
        }
        
    }
    
    @objc func draggedViewDia(_ gestureRecognizer:UIPanGestureRecognizer){
        //        self.view.layoutIfNeeded()
        switch gestureRecognizer.state {
            
        case .began:
            self.startingConstant = self.topViewDragDia.constant
        case .possible:
            debugPrint("possible")
            break
        case .changed:
            if(!changeValue){
                changeValue = true
                btnEnableStatus()
            }
            let translation = gestureRecognizer.translation(in: self.view)
            let percent = round(Float(gestureRecognizer.view!.center.y)/Float(heightCell))
                        
            if(self.startingConstant + translation.y >= -20 && self.startingConstant + translation.y <=  self.viewMain.frame.size.height - 20){
                self.topViewDragDia.constant = self.startingConstant + translation.y
            }
            if(percent > 0 && Int(percent) <= (numbers.count - 1)){
                lbDia.attributedText = self.parseBloodString(number: numbers[Int(percent - 1)])
            }else if(percent == 0){
                lbDia.attributedText = self.parseBloodString(number: numbers[0])
            }else{
                lbDia.attributedText = self.parseBloodString(number: minBlood)
            }
        case .ended:
            let percent = round(Float(gestureRecognizer.view!.center.y)/Float(heightCell))
            if(percent > 0 && Int(percent) <= (numbers.count - 1)){
                lbDia.attributedText = self.parseBloodString(number: numbers[Int(percent - 1)])
            }else if(percent == 0){
                lbDia.attributedText = self.parseBloodString(number: numbers[0])
            }else{
                lbDia.attributedText = self.parseBloodString(number: minBlood)
            }
        case .cancelled:
            debugPrint("cancel")
            break
        case .failed:
            debugPrint("failed")
            break
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
    
    func parseBloodString(number: Int)->NSMutableAttributedString{
        let str = String(number)
        let blood = "\(str) mm Hg"
        return self.changeColorText(blood, linkTextWithColor: "mm Hg", color: UIColor(hex: "4f79fc"), linkColor: UIColor(hex: "4f79fc"))
    }
    
    func changeColorText(_ text : String, linkTextWithColor : String, color: UIColor, linkColor:UIColor)->NSMutableAttributedString{
        let range = (text as NSString).range(of: linkTextWithColor)
        
        let myMutableString = NSMutableAttributedString(string: text)
        let strRange = (text as NSString).range(of: text)
        
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range:strRange)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: linkColor, range:range)
        
        myMutableString.addAttribute(NSAttributedString.Key.font,value: UIFont(name: "Roboto-Medium", size: 24)!,range: strRange)
        myMutableString.addAttribute(NSAttributedString.Key.font,value: UIFont(name: "Roboto-Regular", size: 12)!,range: range)
        return myMutableString
        
    }
    
    //Action button
    @IBAction func backAction() {
        print("back button press")
    }
    
    @IBAction func menuAction() {
        print("menu button press")
    }
    
    @IBAction func nextAction(sender: UIButton){
        sender.shakeUpDownButton()
        UIView.animate(withDuration: 0.8, animations: {
            self.topViewDragDia.constant = self.view.frame.size.height + self.heightDragView
            self.topViewDragSys.constant = self.view.frame.size.height + self.heightDragView
            self.leftImg.constant = -(self.imgPerson.frame.size.width + 30)
            self.leftRuler.constant = -(self.viewParentTable.frame.size.width + 30)
            self.leftTitle.constant = -(UIScreen.main.bounds.size.width)
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.patientInfoController?.view.isHidden = false
            self.patientInfoController?.setUpUIAnimation()
        }
    }
    
    func setUpAnimationRuler(){
        UIView.animate(withDuration: 0.8, animations: {
            self.leftRuler.constant = 75
            self.topViewDragSys.constant = CGFloat((self.maxBlood - self.defaultSystolic + 2)/2) * self.heightCell - 20
            self.topViewDragDia.constant = CGFloat((self.maxBlood - self.defaultDiaStolic + 2)/2) * self.heightCell - 20
            self.leftImg.constant = 0
            self.leftTitle.constant = 0
            self.view.layoutIfNeeded()
        }) { (finished) in
        }
    }
    
    func setUpImg(){
        self.imgPerson.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.imgPerson.alpha = 1
        }) { (finished) in
            self.imgPerson.alpha = 1
        }
    }
    
    func getHeightViewMain()->CGFloat{
        return self.viewMain.frame.size.height
    }
    
    func getNameImage(age: Int,selectedGender: Int)->String{
        if(selectedGender == 0){
            if(age >= 1 && age <= 15){
                return "boy_blood"
            }else if(age >= 16 && age <= 40){
                return "teen_boy_blood"
            }else{
                return "men_blood"
            }
        }else{
            if(age >= 1 && age <= 15){
                return "girl_blood"
            }else if(age >= 16 && age <= 40){
                return "teen_girl_blood"
            }else{
                return "women_blood"
            }
        }
    }
}
