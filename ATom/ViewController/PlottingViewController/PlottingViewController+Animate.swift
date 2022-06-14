//
//  PlottingViewController+PanGesture.swift
//  ATOM
//
//  Created by Phan The Chau on 12/04/2022.
//
import UIKit

extension PlottingViewController {
    /// animation show selection ekg
    func showSelectionEkgBoard() {
        let y = isShowingSelectionsEkg ? getMinYOfSelectionsEkgViewView() : getMaxYOfSelectionsView()
        setUpBottomCollectionView(y: y)
    }
    
    func setUpBottomCollectionView(y: CGFloat) {
        contentCollectionView.isHidden = false
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseInOut) { [weak self] in
            self?.viewContainSelectionsEkg.frame.origin = CGPoint(x: 0, y: y)
            self?.setHeightCollectionView()
            self?.view.layoutIfNeeded()
        }
    }
        
    func hideDetailIfNeed() {
        contentCollectionView.isHidden = true
        heightCollectionView.constant = 0
        viewContainSelectionsEkg.frame.origin = CGPoint(x: 0, y: getYDetailView())
        viewContainSelectionsEkg.layoutSubviews()
        view.layoutSubviews()
    }
    
    func getYDetailView() -> CGFloat {
        switch (isShowingSelectionsEkg, false) {
        case (true, _):
            return view.frame.height - getHeightSelectionsEkgView()
        case (false, true):
            return view.frame.height - 90
        default:
            return view.frame.height - 173
        }
    }
    
    func getMinYOfSelectionsEkgViewView() -> CGFloat {
        return view.frame.height - getHeightSelectionsEkgView()
    }
    
    func getHeightSelectionsEkgView() -> CGFloat {
        return viewContainSelectionsEkg.frame.height
    }
    
    func getMaxYOfSelectionsView() -> CGFloat {
        if isShowingSelectionsEkg {
            return view.frame.height - 90
        } else {
            return view.frame.height - 173
        }
    }
    
    fileprivate func tableviewAction() {
        reloadData()
        titleCollectionView.scrollToItem(at: IndexPath(item: indexListEkgDisplay, section: 0),
                                         at: .centeredHorizontally,
                                         animated: true)
    }
    
    func changeTypeDisplay() {
        contentCollectionView.isHidden = true
        if indexListEkgDisplay == 0 {
            btnAmplitude.isHidden = false
        } else {
            btnAmplitude.isHidden = true
            indexShowAmp = 1
            ampValueLabel.text = " " + ampList[indexShowAmp].description + "mm/mV"
        }
        isShowingSelectionsEkg = false
        tableviewAction()
        hideDetailIfNeed()
        indexHighLight = 0
        setupScrollView()
        scrollView.isScrollEnabled = !(indexListEkgDisplay == 0)
        if indexListEkgDisplay == 3 {
            hideAllViewBottm(!isShowingGrid)
        }
    }
    
    func hideAllViewBottm(_ isHidden: Bool) {
        let heightView = view.frame.height
        let heightSelectionsView = viewContainSelectionsEkg.frame.height
        infoStackview.isHidden = isHidden
        if isHidden {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {[weak self] in
                self?.viewContainSelectionsEkg.frame.origin.y = heightView
                self?.viewBottom.frame.origin.y = heightView + heightSelectionsView
                self?.view.layoutIfNeeded()
            }
            
        } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {[weak self] in
                    self?.viewContainSelectionsEkg.frame.origin.y = heightView - heightSelectionsView
                    self?.viewBottom.frame.origin.y = heightView - (self?.viewBottom.frame.height ?? 0)
                    self?.view.layoutIfNeeded()
                }
        }
    }
    
    @objc func hide() {
        hideAllViewBottm(true)
    }
    
    @objc func showSelectionsEkgViewWhenTapGridView(_ sender: Any?) {
        hideAllViewBottm(false)
        hideSelectionEkgTimer?.invalidate()
        hideSelectionEkgTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hide), userInfo: nil, repeats: false)
    }
}
