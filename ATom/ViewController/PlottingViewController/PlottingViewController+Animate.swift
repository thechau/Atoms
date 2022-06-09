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
        contentCollectionView.isHidden = false
        setHeightCollectionView()
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
        if indexListEkgDisplay == 0 {
            btnAmplitude.isHidden = false
        } else {
            btnAmplitude.isHidden = true
            indexShowAmp = 1
            ampValueLabel.text = " " + ampList[indexShowAmp].description + "mm/mV"
        }
        if indexListEkgDisplay == 3 {
            hideAllViewBottm(isPlaying)
            scrollView.addGestureRecognizer(tap)
        } else {
            scrollView.removeGestureRecognizer(tap)
        }
        
        isShowingSelectionsEkg = false
        tableviewAction()
        hideDetailIfNeed()
        indexHighLight = 0

    }
    
    func hideAllViewBottm(_ isHidden: Bool) {
        viewContainSelectionsEkg.isHidden = isHidden
        controlStackView.isHidden = isHidden
        viewBottom.isHidden = isHidden
    }
    
    @objc func showSelectionsEkgViewWhenTapGridView(_ sender: Any?) {
        hideAllViewBottm(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {[weak self] in
            self?.hideAllViewBottm(true)
        }
    }
}
