//
//  ViewController.swift
//  NewTask
//
//  Created by Phan The Chau on 07/02/2022.
//

import UIKit

class ElectrodesViewController: UIViewController, iCarouselDataSource {
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var shorrtNameRibLabel: UILabel!
    @IBOutlet weak var descriptionRibLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var nameRibLabel: UILabel!
    @IBOutlet weak var ribsButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iCarouselView: iCarousel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let redColor = UIColor(red: 163/255, green: 16/255, blue: 27/255, alpha: 1)
    private let yellowColor = UIColor(red: 246/255, green: 190/255, blue: 0, alpha: 1)
    private let blackColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 1)
    private let brownColor = UIColor(red: 88/255, green: 67/255, blue: 31/255, alpha: 1)
    private let violetColor = UIColor(red: 153/255, green: 31/255, blue: 183/255, alpha: 1)
    private let greenColor = UIColor(red: 42/255, green: 135/255, blue: 15/255, alpha: 1)
    
    var index = 0
    let duration: TimeInterval = 1
    var isOnRibs = true
    var listIconDisplay = [UIImage?]()
    
    var pointList = [CGPoint.zero, CGPoint(x: 1240, y: 1400),
                     CGPoint(x: 2444, y: 1424),
                     CGPoint(x: 1545, y: 3340),
                     CGPoint(x: 2271, y: 3335),
                     CGPoint(x: 1779, y: 1970),
                     CGPoint(x: 2015, y: 1962),
                     CGPoint(x: 2147, y: 2012),
                     CGPoint(x: 2221, y: 2061),
                     CGPoint(x: 2404, y: 2034),
                     CGPoint(x: 2545, y: 1997)]
    var listIcon = [nil,
                    UIImage(named: "icon_red"),
                    UIImage(named: "icon_yellow"),
                    UIImage(named: "icon_black"),
                    UIImage(named: "icon_green"),
                    UIImage(named: "icon_red"),
                    UIImage(named: "icon_yellow"),
                    UIImage(named: "icon_green"),
                    UIImage(named: "icon_brown"),
                    UIImage(named: "icon_black"),
                    UIImage(named: "icon_violet")]
    var listColor:[UIColor?] = []
    var shortNameRib = ["","RA", "LA",
                        "RL",
                        "LL",
                        "V1",
                        "V2",
                        "V3",
                        "V4",
                        "V5",
                        "V6"]
    
    var nameRib = ["","RA (Right Arm)", "LA (Left Arm)",
                   "RL (Right Leg)",
                   "LL (Left Leg)",
                   "V1 (Chest Lead)",
                   "V2 (Chest Lead)",
                   "V3 (Chest Lead)",
                   "V4 (Chest Lead)",
                   "V5 (Chest Lead)",
                   "V6 (Chest Lead)"]
    
    var descriptionRib = ["", "Anywhere between the right shoulder and right elbow",
                          "Anywhere between the left shoulder and the left elbow",
                          "Anywhere below the right torso and above the right ankle",
                          "Anywhere below the left torso and above the left ankle",
                          "Fourth intercostal space on the right sternum",
                          "Fourth intercostal space at the left sternum",
                          "Midway between imaginary line joining V2 and V4 ",
                          "Fifth intercostal space at the midclavicular line",
                          "Midway between V4 and V6 on same horizontal level",
                          "Mid-axillary line on the same horizontal level as V4 and V5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListIcon()
        iCarouselView.dataSource = self
        iCarouselView.type = .cylinder
        iCarouselView.isUserInteractionEnabled = false
        setImageButtonRib()
        setupLeftRightButton()
        reset()
        gradientView.setUpGradient()
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return pointList.count
    }
    
    func getListIcon() {
        listColor  = [nil,
                      redColor,
                      yellowColor,
                      blackColor,
                      greenColor,
                      redColor,
                      yellowColor,
                      greenColor,
                      brownColor,
                      blackColor,
                      violetColor]
        listIconDisplay = listIcon
        if index < 3 {
            listIconDisplay[listIconDisplay.count - 1] = nil
            listIconDisplay[listIconDisplay.count - 2] = nil
        } else if index > listIconDisplay.count - 4 {
            listIconDisplay[0] = nil
            listIconDisplay[1] = nil
            listIconDisplay[2] = nil
        }
        iCarouselView.reloadData()
    }
    
    func setupLeftRightButton() {
        if index < 2 {
            leftButton.isHidden = true
            rightButton.isHidden = false
        } else if index == pointList.count - 1 {
            leftButton.isHidden = false
            rightButton.isHidden = true
        } else {
            leftButton.isHidden = false
            rightButton.isHidden = false
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let imageView: UIImageView
        let height = 40
        if view != nil {
            imageView = view as! UIImageView
        } else {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height:height))
            
        }
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = self.view.backgroundColor
        imageView.image = listIconDisplay[index]
        return imageView
    }
    
    // Do any additional setup after loading the view.
    @IBAction func onActionRightButton(_ sender: Any) {
        getListIcon()
        if index == pointList.count - 1 {
            index = 0
        } else {
            index += 1
        }
        iCarouselView.scroll(byNumberOfItems: 1, duration: duration)
        zoom(at: index)
        setupLeftRightButton()
        
        tipsLabel.isHidden = true
        gradientView.isHidden = true
    }
    
    @IBAction func onActionLeftButton(_ sender: Any) {
        guard index > 1 else {
            return
        }
        getListIcon()
        iCarouselView.scroll(byNumberOfItems: -1, duration: duration)
        index -= 1
        zoom(at: index)
        setupLeftRightButton()
        getListIcon()
        tipsLabel.isHidden = true
        gradientView.isHidden = true
        
    }
    
    @IBAction func onActionReset(_ sender: Any) {
        reset()
        iCarouselView.scroll(toOffset: 0, duration: duration)
        index = 0
        getListIcon()
    }
    
    func zoom(at index: Int) {
        guard index != 0 else {
            return
        }
        let point = pointList[index]
        setupNameRibs()
        let midX = imageView.bounds.midX
        let midY = imageView.bounds.midY
        let size = imageView.bounds.size
        
        let x = (point.x/3840.0) * size.width
        let y = (point.y/3840.0) * size.height
        
        let t = CGAffineTransform.identity
        UIView.animate(withDuration: duration) {
            self.imageView.transform = t.scaledBy(x: 4, y: 4).translatedBy(x: midX - x, y: midY - y)
        }
    }
    
    func reset() {
        self.imageView.transform = .identity
        shorrtNameRibLabel.text = shortNameRib[0]
        nameRibLabel.text = nameRib[0]
        descriptionRibLabel.text = descriptionRib[0]
        leftButton.isHidden = true
        rightButton.isHidden = false
        tipsLabel.isHidden = false
        gradientView.isHidden = false
    }
    
    @IBAction func onActionQuestionButton(_ sender: Any) {
        showPopUp()
    }
    
    @IBAction func onActionBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func setupNameRibs() {
        shorrtNameRibLabel.text = shortNameRib[index]
        nameRibLabel.text = nameRib[index]
        descriptionRibLabel.text = descriptionRib[index]
        nameRibLabel.textColor = listColor[index]
    }
    
    @IBAction func onActionRibs(_ sender: Any) {
        isOnRibs = !isOnRibs
        imageView.image = isOnRibs ? UIImage(named: "bodyWithRib") : UIImage(named: "rawBody")
        setImageButtonRib()
    }
    
    func setImageButtonRib() {
        let backgroundColor = isOnRibs ? UIColor.black : UIColor.white
        let image = isOnRibs ? UIImage(named: "ribs_on") : UIImage(named: "ribs_off")
        ribsButton.setImage(image, for: .normal)
        ribsButton.backgroundColor = backgroundColor
        ribsButton.layer.cornerRadius = ribsButton.bounds.width / 2
        gradientView.layer.cornerRadius = 8
        gradientView.clipsToBounds = true
    }
    
    func showPopUp() {
        let storyboard = UIStoryboard(name: "PopUpInfo", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! PopUpViewController
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true, completion: nil)
    }
}

