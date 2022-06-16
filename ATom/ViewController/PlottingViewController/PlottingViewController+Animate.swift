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
        let y = isShowingSelectionsEkg ? getMinYOfSelectionsEkgViewView() : frameSelections.origin.y //getMaxYOfSelectionsView()
        setUpBottomCollectionView(y: y)
    }
    
    func setUpBottomCollectionView(y: CGFloat) {
        if isShowingSelectionsEkg {
            contentCollectionView.isHidden = false
            self.setHeightCollectionView()
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.viewContainSelectionsEkg.frame.origin = CGPoint(x: 0, y: y)
            self?.view.layoutIfNeeded()
        } completion: { [weak self]_ in
            if self?.isShowingSelectionsEkg == false {
                self?.contentCollectionView.isHidden = true
            }
        }
    }
        
    func hideSelectionsEkgView() {
        isShowingSelectionsEkg = false
        viewContainSelectionsEkg.frame = frameSelections
        view.layoutIfNeeded()
    }
    
    
    func getMinYOfSelectionsEkgViewView() -> CGFloat {
        return view.frame.height - getHeightSelectionsEkgView()
    }
    
    func getHeightSelectionsEkgView() -> CGFloat {
        return viewContainSelectionsEkg.frame.height
    }
        
    fileprivate func scrollToTop() {
        reloadData()
        titleCollectionView.scrollToItem(at: IndexPath(item: indexListEkgDisplay, section: 0),
                                         at: .centeredHorizontally,
                                         animated: true)
    }
    
    func changeTypeDisplay() {
        if indexListEkgDisplay == 0 {
            btnAmplitude.isHidden = false
        } else {
            btnAmplitude.isHidden = true
            indexShowAmp = 1
            ampValueLabel.text = " " + ampList[indexShowAmp].description + "mm/mV"
        }
        scrollToTop()
        hideSelectionsEkgView()
        setupScrollView()
        scrollView.isScrollEnabled = !(indexListEkgDisplay == 0)
        if indexListEkgDisplay == 3 {
            hideAllViewBottm(!isShowingGrid)
        }
        indexHighLight = 0
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
                    self?.viewContainSelectionsEkg.frame = self?.frameSelections ?? .zero
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
