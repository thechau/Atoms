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
    @IBOutlet weak var viewCorners: UIView!
    @IBOutlet weak var viewPanGuesture: UIView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var btnPause: RoundedButtonWithShadow!
    @IBOutlet weak var btnReport: RoundedButtonWithShadow!
    @IBOutlet weak var btnAmplitude: UIButton!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var scaleSwitch: ScaleSwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewPan: UIView!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var gridOnLabel: UILabel!
    @IBOutlet weak var girdButton: RoundedButtonWithShadow!
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var ampValueLabel: UILabel!
//    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var controlStackView: UIStackView!
    // Chart
    @IBOutlet weak var vwGridBoard: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewContainerGridView: UIView!
    var vwModel = ChartECGViewModel()
    
    private let heightChart: CGFloat = 120
    var isFirstTime = true
    var isShowingDetail = false
    var isExpanding = false
    
    let disposeBag = DisposeBag()
    var chartTimer: Timer?
    let smallColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    var duration = 0.02
    var isPausing = false
    var indexTypeDisplay = 0
    var indexHighLight = 0 {
        didSet {
            showChartEkg()
        }
    }
    
    var vw = UIView()
    var ppi: Float = 0
    var screenScale = 0
    
    // Chart
    
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
    
    var heightItem = 40.0
    let displayList: [NumberEkg] = [.oneEkg, .threeEkg, .sixEkg, .twelveEkg]
    let ampList = [5, 10, 15, 20]
    var indexHeightChartRatio: Int = 1
    var timeSpeed = 0.02
    var isShowingGrid = true
    var isPlaying = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initCollectionView()
        vwModel = ChartECGViewModel(value: 1500)
        hideDetailIfNeed()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //getData()
        drawGridBoard()
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
        chartTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(drawForAMonment), userInfo: nil, repeats: true)
        
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
                                        name: "aV1",
                                        timer: chartTimer)
        plottingChartViewaV2.setupChart(viewController: self,
                                        name: "aV2",
                                        timer: chartTimer)
        plottingChartViewaV3.setupChart(viewController: self,
                                        name: "aV3",
                                        timer: chartTimer)
        plottingChartViewaV4.setupChart(viewController: self,
                                        name: "aV4",
                                        timer: chartTimer)
        plottingChartViewaV5.setupChart(viewController: self,
                                        name: "aV5",
                                        timer: chartTimer)
        plottingChartViewaV6.setupChart(viewController: self,
                                        name: "aV6",
                                        timer: chartTimer)
        showChartEkg()
        hideDetailIfNeed()
        RunLoop.main
            .add(chartTimer ?? Timer(),
                         forMode: .common)
    }
    
    
    
    fileprivate func setupCollectionView() {
        let collectionLayout = UICollectionViewFlowLayout()
        contentCollectionView.collectionViewLayout = collectionLayout
    }
    
    private func initView() {
        viewPan.layer.cornerRadius = viewPan.frame.height / 2
        viewPan.clipsToBounds = true
        viewCorners.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        viewContainerGridView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        setupCollectionView()
        hideDetailIfNeed()
        infoStackview.isHidden = true
        ampValueLabel.text = ampList[indexHeightChartRatio].description + "mm/mV"
    }
    
    func getListChart() -> [[PlottingChartView]] {
        let typeDisplay = displayList[indexTypeDisplay]
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
    
  func getHeightSignleEkg() -> CGFloat {
      return vwGridBoard.frame.height - 179
  }
    func showChartEkg() {
        guard isPlaying else {
            stackView.subviews.forEach { vi in
                vi.isHidden = true
            }
            return
        }
        stackView.subviews.forEach { vi in
            vi.isHidden = false
        }
        let indexDisplay = indexHighLight
        let listDisplay = getListChart()
        var height: CGFloat = 0
        var heightItem = (isExpanding || !isShowingGrid) ? caculateHeightItemExpanding() : 200
        
      if indexTypeDisplay == 0 {
        heightItem = getHeightSignleEkg()
      }
        if (isExpanding || !isShowingGrid), indexTypeDisplay != 0 {
            indexHeightChartRatio = indexHeightChartRatio / Int(120.0)
        }
        
        for index in 0 ..< listDisplay.count {
            for charView in listDisplay[index] {
                charView.isHidden = !(index == indexDisplay)
                charView.backgroundColor = .clear
                charView.drawingHeight = heightChart * CGFloat(indexHeightChartRatio)
                if !charView.isHidden {
                    height += heightItem
                }
            }
        }
        
        heightStackView.constant = height
        view.layoutIfNeeded()
        stackView.layoutIfNeeded()
        stackView.subviews.forEach { uiview in
            guard let chart = uiview as? PlottingChartView else {
                return
            }
            chart.duration = timeSpeed
            chart.setLayoutChart()
        }
        stackView.layoutIfNeeded()
        view.layoutIfNeeded()
        getData()
        scrollView.contentInset.bottom = getHeightDetailView() + 50
        scrollView.scrollToTop()
    }
    
    
    func caculateHeightItemExpanding() -> CGFloat {
        let totalHeight = vwGridBoard.frame.height - getHeightDetailView() + 60
        var heightStackViewChart = 200.0
        switch indexTypeDisplay {
        case 0:
            heightStackViewChart = 200
        case 1:
            heightStackViewChart = totalHeight / 3.0
        case 2:
            heightStackViewChart = totalHeight / 6.0
        case 3:
            heightStackViewChart = totalHeight / 12.0
        default:
            break
        }
        
        return heightStackViewChart
    }
}
