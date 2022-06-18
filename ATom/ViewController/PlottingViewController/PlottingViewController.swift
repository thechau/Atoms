//
//  ViewController.swift
//  ATOM
//
//  Created by Admin on 09/04/2022.
//

import UIKit
//import SwiftChart
import RxSwift
import Charts

class PlottingViewController: BaseViewController {
    @IBOutlet weak var infoStackview: UIStackView!
    @IBOutlet weak var heightStackView: NSLayoutConstraint!
    @IBOutlet weak var viewContainSelectionsEkg: UIView!
    @IBOutlet weak var viewPanGuesture: UIView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var btnPause: RoundedButtonWithShadow!
    @IBOutlet weak var btnReport: RoundedButtonWithShadow!
    @IBOutlet weak var btnAmplitude: UIButton!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var scaleSwitch: ScaleSwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentScrollView: UIView!
    @IBOutlet weak var viewPan: UIView!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var gridOnLabel: UILabel!
    @IBOutlet weak var girdButton: RoundedButtonWithShadow!
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var ampValueLabel: UILabel!
    @IBOutlet weak var controlStackView: UIStackView!
    @IBOutlet weak var viewBottom: UIView!

    // Chart
    @IBOutlet weak var vwGridBoard: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewContainerGridView: UIView!
    var vwModel = ChartECGViewModel()
    private let heightItemEkg: CGFloat = 220
    var isFirstTime = true
    var isShowingSelectionsEkg = false
    
    let disposeBag = DisposeBag()
    var chartTimer: Timer?
    var hideSelectionEkgTimer: Timer?
    let smallColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    var isPausing = false
    
    /// One EKG, Three EKG, Six EKG, Twelve EKG
    var indexListEkgDisplay = 0
    var heightItem = 40.0
    var indexShowAmp: Int = 1
    var timeSpeed = 0.02
    var isShowingGrid = true
    var isPlaying = false
    var indexHighLight = 0
    
    var vw = UIView()
    var screenScale = 0
    var frameSelections = CGRect()
    var frameBottomView = CGRect()
    // Chart
    let valueHeightDraw = [5.0, 10.0, 15.0, 20.0]
    let oneLeadList = ["I", "II", "III", "aVR","aVL", "aVF","V1","V2","V3", "V4","V5","V6"]
    let threeLeadList = [["I", "II", "III"],
                         ["aVR", "aVL", "aVF"],
                         ["V1","V2", "V3"],
                         ["V4","V5", "V6"]]
    let sixLeadList = [["I", "II", "III", "aVR", "aVL", "aVF"], ["V1","V2", "V3", "V4","V5", "V6"]]
    
    var plottingChartViewI: PlottingChartView!
    var plottingChartViewII: PlottingChartView!
    var plottingChartViewIII: PlottingChartView!
    var plottingChartViewaVR: PlottingChartView!
    var plottingChartViewaVL: PlottingChartView!
    var plottingChartViewaVF: PlottingChartView!
    var plottingChartViewaV1: PlottingChartView!
    var plottingChartViewaV2: PlottingChartView!
    var plottingChartViewaV3: PlottingChartView!
    var plottingChartViewaV4: PlottingChartView!
    var plottingChartViewaV5: PlottingChartView!
    var plottingChartViewaV6: PlottingChartView!
    
    let displayList: [NumberEkg] = [.oneEkg, .threeEkg, .sixEkg, .twelveEkg]
    let ampList = [5, 10, 15, 20]
    var tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initCollectionView()
        vwModel = ChartECGViewModel(value: 1500)
        ppi = UIDevice.setPPIValue()
        setUpBottomCollectionView()
        frameSelections = viewContainSelectionsEkg.frame
        frameBottomView = viewBottom.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //getData()
        setupGridBoard()
        getAllOfLead()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func getAllOfLead() {
        plottingChartViewI = PlottingChartView.instanceFromNib()
        plottingChartViewII = PlottingChartView.instanceFromNib()
        plottingChartViewIII = PlottingChartView.instanceFromNib()
        
        plottingChartViewaVR = PlottingChartView.instanceFromNib()
        plottingChartViewaVL = PlottingChartView.instanceFromNib()
        plottingChartViewaVF = PlottingChartView.instanceFromNib()
        
        plottingChartViewaV1 = PlottingChartView.instanceFromNib()
        plottingChartViewaV2 = PlottingChartView.instanceFromNib()
        plottingChartViewaV3 = PlottingChartView.instanceFromNib()
        
        
        plottingChartViewaV4 = PlottingChartView.instanceFromNib()
        plottingChartViewaV5 = PlottingChartView.instanceFromNib()
        plottingChartViewaV6 = PlottingChartView.instanceFromNib()
        //
        stackView.addArrangedSubview(plottingChartViewI)
        stackView.addArrangedSubview(plottingChartViewII)
        stackView.addArrangedSubview(plottingChartViewIII)
        stackView.addArrangedSubview(plottingChartViewaVR)
        stackView.addArrangedSubview(plottingChartViewaVL)
        stackView.addArrangedSubview(plottingChartViewaVF)
        stackView.addArrangedSubview(plottingChartViewaV1)
        stackView.addArrangedSubview(plottingChartViewaV2)
        stackView.addArrangedSubview(plottingChartViewaV3)
        stackView.addArrangedSubview(plottingChartViewaV4)
        stackView.addArrangedSubview(plottingChartViewaV5)
        stackView.addArrangedSubview(plottingChartViewaV6)
        
        stackView.layoutIfNeeded()
        chartTimer = Timer.scheduledTimer(timeInterval: timeSpeed, target: self, selector: #selector(drawForAMonment), userInfo: nil, repeats: true)
        
        plottingChartViewI.setupChart(viewController: self,
                                      name: "I",
                                      timer: chartTimer)
        plottingChartViewII.setupChart(viewController: self,
                                       name: "II",
                                       timer: chartTimer)
        plottingChartViewIII.setupChart(viewController: self,
                                        name: "III",
                                        timer: chartTimer)
        plottingChartViewaVR.setupChart(viewController: self,
                                        name: "aVR",
                                        timer: chartTimer)
        plottingChartViewaVL.setupChart(viewController: self,
                                        name: "aVL",
                                        timer: chartTimer)
        plottingChartViewaVF.setupChart(viewController: self,
                                        name: "aVF",
                                        timer: chartTimer)
        plottingChartViewaV1.setupChart(viewController: self,
                                        name: "V1",
                                        timer: chartTimer)
        plottingChartViewaV2.setupChart(viewController: self,
                                        name: "V2",
                                        timer: chartTimer)
        plottingChartViewaV3.setupChart(viewController: self,
                                        name: "V3",
                                        timer: chartTimer)
        plottingChartViewaV4.setupChart(viewController: self,
                                        name: "V4",
                                        timer: chartTimer)
        plottingChartViewaV5.setupChart(viewController: self,
                                        name: "V5",
                                        timer: chartTimer)
        plottingChartViewaV6.setupChart(viewController: self,
                                        name: "V6",
                                        timer: chartTimer)
        showChartEkg()
        RunLoop.main
            .add(chartTimer ?? Timer(),
                         forMode: .common)
    }
    
    func setupScrollView() {
        if indexListEkgDisplay == 0 || !isShowingGrid {
            scrollView.isScrollEnabled = false
        } else if indexListEkgDisplay == 3, !isShowingGrid {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
        if indexListEkgDisplay == 3, !isShowingGrid {
            scrollView.addGestureRecognizer(tap)
        } else {
            scrollView.removeGestureRecognizer(tap)
            hideSelectionEkgTimer?.invalidate()
        }
    }
    
    fileprivate func setupCollectionView() {
        let collectionLayout = UICollectionViewFlowLayout()
        contentCollectionView.collectionViewLayout = collectionLayout
    }
    
    private func initView() {
        tap = UITapGestureRecognizer(target: self, action: #selector(showSelectionsEkgViewWhenTapGridView(_:)))
        viewPan.layer.cornerRadius = viewPan.frame.height / 2
        viewPan.clipsToBounds = true
        viewContainSelectionsEkg.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        viewContainerGridView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        setupCollectionView()
        infoStackview.isHidden = true
        setupApm()
        setupScrollView()
    }
    
    func getHeightDisplayChart() -> CGFloat {
        return scrollView.frame.height - frameSelections.height
    }
    
    func getListChart() -> [[PlottingChartView]] {
        let typeDisplay = displayList[indexListEkgDisplay]
        switch typeDisplay {
        case .oneEkg:
            return [[plottingChartViewI], [plottingChartViewII], [plottingChartViewIII],
                    [plottingChartViewaVR], [plottingChartViewaVL], [plottingChartViewaVF],
                    [plottingChartViewaV1], [plottingChartViewaV2], [plottingChartViewaV3],
                    [plottingChartViewaV4], [plottingChartViewaV5],[plottingChartViewaV6]]
        case .threeEkg:
            return [[plottingChartViewI, plottingChartViewII, plottingChartViewIII],
                    [plottingChartViewaVR, plottingChartViewaVL, plottingChartViewaVF],
                    [plottingChartViewaV1, plottingChartViewaV2, plottingChartViewaV3],
                    [plottingChartViewaV4, plottingChartViewaV5,plottingChartViewaV6]]
        case .sixEkg:
            return [[plottingChartViewI, plottingChartViewII, plottingChartViewIII,
                     plottingChartViewaVR, plottingChartViewaVL, plottingChartViewaVF],
                    [plottingChartViewaV1, plottingChartViewaV2, plottingChartViewaV3,
                     plottingChartViewaV4, plottingChartViewaV5,plottingChartViewaV6]]
        case .twelveEkg:
            return [[plottingChartViewI, plottingChartViewII, plottingChartViewIII,
                     plottingChartViewaVR, plottingChartViewaVL, plottingChartViewaVF,
                     plottingChartViewaV1, plottingChartViewaV2, plottingChartViewaV3,
                     plottingChartViewaV4, plottingChartViewaV5,plottingChartViewaV6]]
        }
    }
        
    func showChartEkg() {
        guard isPlaying else {
            stackView.subviews.forEach { vi in
                vi.isHidden = true
            }
            chartTimer?.invalidate()
            return
        }
        stackView.subviews.forEach { vi in
            vi.isHidden = false
        }
        
        if indexListEkgDisplay != 0 {
            indexShowAmp = 1
        }
        let listDisplay = getListChart()
        let heightDraw = caculateHeightOfOneEkg()
        heightStackView.constant = caculateTotalHeightEkg()
        stackView.layoutIfNeeded()
        for index in 0 ..< listDisplay.count {
            for charView in listDisplay[index] {
                charView.isHidden = !(index == indexHighLight)
                charView.backgroundColor = .clear
                charView.drawingHeight = heightDraw
                charView.lineView.isHidden = (indexListEkgDisplay == 0)
                charView.setDrawingRatio(isHighSpeed: scaleSwitch.isOn)
            }
        }
        

        stackView.subviews.forEach { uiview in
            guard let chart = uiview as? PlottingChartView else {
                return
            }
            chart.setLayoutChart()
        }
        stackView.layoutIfNeeded()
        getData()
        scrollView.contentInset.bottom = 173 - 50
        scrollView.scrollToTop()
        setupGridBoard()
        chartTimer?.invalidate()
        chartTimer = Timer.scheduledTimer(timeInterval: timeSpeed,
                                          target: self,
                                          selector: #selector(drawForAMonment),
                                          userInfo: nil, repeats: true)
        RunLoop.current.add(self.chartTimer!, forMode: RunLoop.Mode.common)
    }
    
    func caculateTotalHeightEkg() -> CGFloat {
        switch indexListEkgDisplay {
        case 0:
            return getHeightDisplayChart()
        case 1:
            if isShowingGrid {
                return 3 * caculateHeightOfOneEkg() * 4 / 7
            } else {
                return 3 * caculateHeightOfOneEkg()
            }
            

        case 2:
            if isShowingGrid {
                return 6 * caculateHeightOfOneEkg() * 4 / 7
            } else {
                return 6 * caculateHeightOfOneEkg()
            }
     
        case 3:
            if isShowingGrid {
                return 12 * caculateHeightOfOneEkg() * 4 / 7
            } else {
                return 12 * caculateHeightOfOneEkg()
            }
            
        default:
            return 0
        }
    }
    
    
    func caculateHeightOfOneEkg() -> CGFloat {
        let pixel = 70.0
        let totalHeightDisplay = getHeightDisplayChart() - 60
        var heightStackViewChart = valueHeightDraw[indexShowAmp] * pixel / 2.0
        guard !isShowingGrid else {
            return heightStackViewChart
        }
        switch indexListEkgDisplay {
        case 0:
            break
        case 1:
            heightStackViewChart = totalHeightDisplay / 3.0
            
        case 2:
            heightStackViewChart = totalHeightDisplay / 6.0
        case 3:
            heightStackViewChart = (vwGridBoard.frame.height - 100.0) / 12.0
        default:
            break
        }
        return heightStackViewChart
    }
}
