//
//  HeightWeightController.swift
//  SelectGender
//
//  Created by Tuan Le on 9/3/19.
//  Copyright © 2019 Tuan Le. All rights reserved.
//

import UIKit
class HeightWeightController: UIViewController,
                              UITableViewDataSource,
                              UITableViewDelegate,
                              UICollectionViewDataSource,
                              UICollectionViewDelegate,
                              UICollectionViewDelegateFlowLayout,
                              CircularCollectionViewLayoutDelegate,
                              CAAnimationDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableViewHeight: UITableView!
    @IBOutlet weak var viewParentTable: UIView!
    @IBOutlet weak var viewDrag: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewRuler: UIView!
    @IBOutlet weak var imgPerson: UIImageView!
    @IBOutlet weak var heightPerson: NSLayoutConstraint!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var viewShadow:UIView!
    @IBOutlet weak var lbKg:UILabel!
    @IBOutlet weak var lbWeight:UILabel!
    @IBOutlet weak var lbHeight:UILabel!
    @IBOutlet weak var topViewDrag: NSLayoutConstraint!
    @IBOutlet weak var topImageBg: NSLayoutConstraint!
    @IBOutlet weak var leftRuler: NSLayoutConstraint!
    @IBOutlet weak var topWeight: NSLayoutConstraint!
    @IBOutlet weak var leftTitle: NSLayoutConstraint!
    @IBOutlet weak var leftImg: NSLayoutConstraint!
    @IBOutlet weak var bottomImg: NSLayoutConstraint!
    @IBOutlet weak var widthImg: NSLayoutConstraint!
    var bloodViewController:BloodPressureController?
    
    var numbers : [Float] = [Float]()
    var heightCell : CGFloat = 10
    var heightDragView : CGFloat = 40/2
    var panGesture = UIPanGestureRecognizer()
    let maxHeight:Float = 7
    let defaultHeigh:Float = 5.7
    var startingConstant:CGFloat = 0;
    var numberWeight: [Int] = [Int]()
    var changeValue = false
    var selectedAge = 0
    var selectedGender = 0
    var imagesListArray = [CGImage]()
    var lastImage: UIImage?
    var animation : CAKeyframeAnimation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNextButton()
        addPanGesture()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutTopView()
    }
    
    fileprivate func layoutTopView() {
        let height = viewMain.frame.size.height / CGFloat(numbers.count)
        if(height != heightCell){
            heightCell = height
            setUpLabelHeight()
            topImageBg.constant = getTopImgAnimationScale()
        }
    }
    
    fileprivate func setupView() {
        // Do any additional setup after loading the view.
        collectionView!.register(UINib(nibName: "CircularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        for i in stride(from: 0, through: maxHeight, by: 0.1).reversed() {
            numbers.append(Float(i).rounded(toPlaces: 1))
        }
        
        for i in 0...200 {
            numberWeight.append(i)
        }
        tableViewHeight.separatorColor = UIColor.clear
        if let collectionViewFlowLayout = collectionView?.collectionViewLayout as? CircularCollectionViewLayout {
            collectionViewFlowLayout.delegate = self
        }
        lbHeight.attributedText = parseHeightString(number: defaultHeigh)
        topViewDrag.constant = self.view.frame.size.height + heightDragView
        leftTitle.constant = UIScreen.main.bounds.size.width
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    private func addBloodView() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        bloodViewController = storyboard.instantiateViewController(withIdentifier: "BloodPressureController") as? BloodPressureController
        add(bloodViewController!, frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size))
        bloodViewController?.view.isHidden = true
    }
    
    fileprivate func addPanGesture() {
        panGesture = PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(draggedView(_:)))
        panGesture.cancelsTouchesInView = false
        viewDrag.addGestureRecognizer(panGesture)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(heightCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HeightTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "HeightCell") as! HeightTableViewCell
        let number = numbers[indexPath.row]
        if(isInt(number: number)){
            cell.lbCenter.font = UIFont.systemFont(ofSize: 25)
        }else{
            if(isEven(number: number)){
                cell.lbCenter.font = UIFont.systemFont(ofSize: 20)
            }else{
                cell.lbCenter.font = UIFont.systemFont(ofSize: 15)
            }
        }
        cell.lbCenter.textColor = UIColor(hex: "d4d6df")
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func draggedView(_ gestureRecognizer: UIPanGestureRecognizer) {
//        self.view.layoutIfNeeded()
        switch gestureRecognizer.state {
        case .began:
            self.startingConstant = self.topViewDrag.constant
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
            
            if(self.startingConstant + translation.y >= -20 && self.startingConstant + translation.y <=  self.viewMain.frame.size.height - 20 - (heightCell * 10)){
                self.topViewDrag.constant = self.startingConstant + translation.y
                self.topImageBg.constant = (self.startingConstant + heightDragView) + translation.y
            }
            
            if(percent > 0 && percent <= 70){
                lbHeight.attributedText = self.parseHeightString(number: numbers[Int(percent - 1)])
            }else if(percent == 0){
                lbHeight.attributedText = self.parseHeightString(number: numbers[0])
            }else{
                lbHeight.attributedText = self.parseHeightString(number: 0)
            }
        case .ended:
            let percent = round(Float(gestureRecognizer.view!.center.y)/Float(heightCell))
            if(percent > 0 && percent <= 70){
                lbHeight.attributedText = self.parseHeightString(number: numbers[Int(percent - 1)])
            }else if(percent == 0){
                lbHeight.attributedText = self.parseHeightString(number: numbers[0])
            }else{
                lbHeight.attributedText = self.parseHeightString(number: 0)
            }
        case .cancelled:
            debugPrint("cancel")
            break
        case .failed:
            debugPrint("failed")
            break
        @unknown default:
            break
        }
        
    }
    
    func isInt(number: Float) -> Bool {
        let num = number.truncatingRemainder(dividingBy: 1)
        if(num == 0){
            return true
        }else{
            return false
        }
    }
    
    func isEven(number: Float) -> Bool {
        let num = (number * 10).truncatingRemainder(dividingBy: 2)
        if(num == 0){
            return true
        }else{
            return false
        }
    }
    
    func setUpLabelHeight() {
        var top: CGFloat = 0.0
        for i in 0...Int(maxHeight) {
            top = (CGFloat(i) * heightCell * 10)
            let lbHeight = UILabel()
            lbHeight.font = UIFont(name: "Roboto-Regular", size: 11)!
            lbHeight.text = "\((Int(maxHeight) - i)) ft"
            lbHeight.textColor = UIColor(hex: "4c5162")
            self.viewMain.addSubview(lbHeight)
            lbHeight.translatesAutoresizingMaskIntoConstraints = false
            viewMain.addConstraint(lbHeight.makeConstraint(attribute: .trailing, toView: viewParentTable, constant: 30))
            viewMain.addConstraint(lbHeight.makeConstraint(attribute: .top, toView: viewMain, constant: top - 3))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberWeight.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CircularCollectionViewCell
        let number = numberWeight[indexPath.row]
        if(number % 10 == 0){
            cell.lbWeight?.textColor = UIColor(hex: "4c5162")
            cell.lbWeightNumber!.text = "\(number)"
            cell.lbWeightNumber?.textColor = UIColor(hex: "4c5162")
        }else{
            if(number % 5 == 0){
                cell.lbWeight?.textColor = UIColor(hex: "4c5162")
            }else{
                cell.lbWeight?.textColor = UIColor(hex: "d4d6df")
            }
           cell.lbWeightNumber?.text = ""
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let number = numberWeight[indexPath.row]
        if(number % 10 == 0){
            return CGSize(width: 50.0, height: 10.0)
        }else{
            return CGSize(width: 10.0, height: 10.0)
        }
    }
    
    func customNextButton() {
        btnNext.applyGradient(colours: UIColor().colorGradientDisable())
        viewShadow.layer.cornerRadius = viewShadow.frame.size.height/2
        viewShadow.layer.shadowColor = UIColor(hex: "b2cff3").cgColor
        viewShadow.layer.shadowOffset = CGSize(width: 0, height: 19)
        viewShadow.layer.shadowRadius = 10
        viewShadow.layer.shadowOpacity = 1
    }
    
    func btnDisableStatus() {
        btnNext.isUserInteractionEnabled = false
        btnNext.updateGradient(colours: UIColor().colorGradientDisable())
    }
    
    func btnEnableStatus() {
        btnNext.isUserInteractionEnabled = true
        btnNext.updateGradient(colours: UIColor().colorGradientActive())
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
    
    func parseHeightString(number: Float)->NSMutableAttributedString{
        let str = String(number)
        let strArr = str.components(separatedBy: ".")
        let height = "\(strArr[0])'\(strArr[1])'' ft/in"
        return self.changeColorText(height, linkTextWithColor: "ft/in", color: UIColor(hex: "4f79fc"), linkColor: UIColor(hex: "4f79fc"))
    }
    
    func collectionViewCurrentIndex(index: Int) {
        lbWeight.text = "\(index)"
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
        print("next button press")
        
        self.bloodViewController?.selectedAge = selectedAge
        self.bloodViewController?.selectedGender = selectedGender
        self.bloodViewController?.imgPerson.image = UIImage(named: (self.bloodViewController?.getNameImage(age: selectedAge, selectedGender: selectedGender))!)
        UIView.animate(withDuration: 0.8, animations: {
            self.leftRuler.constant = -30
            self.topViewDrag.constant = self.view.frame.size.height + self.heightDragView
            self.leftTitle.constant = -(UIScreen.main.bounds.size.width)
            self.topWeight.constant = UIScreen.main.bounds.size.height
            self.leftImg.constant = -(UIScreen.main.bounds.size.width)
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.bloodViewController?.view.isHidden = false
            self.showBloodController()
            self.bloodViewController?.setUpImg()
        }
        
        
    }
    
    
    func showBloodController(){
//        self.imgPerson.isHidden = true
        self.btnNext.isHidden = true
        self.bloodViewController?.setUpAnimationRuler()
    }
    
    
    func setUpAnimationRuler(){
        UIView.animate(withDuration: 1, animations: {
            self.leftRuler.constant = 75
            self.leftTitle.constant = 0
            self.topViewDrag.constant = self.getTopImgAnimationScale() - self.heightDragView
            self.topWeight.constant = 0
            self.view.layoutIfNeeded()
        }) { (finished) in
        }
    }
    
    func getTopImgAnimationScale()->CGFloat{
        return CGFloat(maxHeight - defaultHeigh + 0.1) * 10 * heightCell
    }
    
    func getNameImage(age: Int,selectedGender: Int)->String{
        if(selectedGender == 0) {
            if(age >= 1 && age <= 15) {
                return "boy_bg"
            }else if(age >= 16 && age <= 40) {
                return "teen_boy"
            }else{
                return "men"
            }
        }else{
            if(age >= 1 && age <= 15) {
                return "girl_bg"
            }else if(age >= 16 && age <= 40) {
                return "teen_girl"
            }else{
                return "women"
            }
        }
    }
    
    func getNameImageSitting(age: Int,selectedGender: Int)->String{
        if(selectedGender == 0){
            if(age >= 1 && age <= 15){
                return "boy_sitting"
            }else if(age >= 16 && age <= 40){
                return "teen_boy_sitting"
            }else{
                return "men_sitting"
            }
        }else{
            if(age >= 1 && age <= 15) {
                return "girl_bg_sitting"
            }else if(age >= 16 && age <= 40) {
                return "teen_girl_sitting"
            }else{
                return "women_sitting"
            }
        }
    }
    
    
    func setUpWeight(age: Int, selectedGender: Int) {
        var des: CGFloat = 0
        if(age <= 15){
            des = 30
        }else if(selectedGender == 0){
            des = 70
        }else{
            des = 50
        }
        
        var offsetX: CGFloat = 0
        if let collectionViewFlowLayout = collectionView?.collectionViewLayout as? CircularCollectionViewLayout {
            offsetX = des * collectionViewFlowLayout.anglePerItem/collectionViewFlowLayout.factor
        }
        
        collectionView.setContentOffset(CGPoint(x: offsetX,
                                                     y: collectionView.frame.origin.y),
                                                animated: false)
        
    }
}
