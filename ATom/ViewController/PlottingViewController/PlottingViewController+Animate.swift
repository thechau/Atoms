//
//  PlottingViewController+PanGesture.swift
//  ATOM
//
//  Created by Phan The Chau on 12/04/2022.
//
import UIKit

extension PlottingViewController {
    
    func setUpBottomCollectionView() {
        if isShowingSelectionsEkg {
            self.heightCollectionView.constant = getHeightCollectionView()
            contentCollectionView.reloadData()
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.heightCollectionView.constant = self?.getHeightCollectionView() ?? 0
            self?.view.layoutIfNeeded()
        } completion: { [weak self]_ in
            self?.contentCollectionView.reloadData()
            if self?.isShowingSelectionsEkg == false {
                self?.heightCollectionView.constant = 0
            }
            self?.view.setNeedsDisplay()
        }
    }
    
    func getMinYOfSelectionsEkgViewView() -> CGFloat {
        return viewContainSelectionsEkg.frame.maxY - frameSelections.height - getHeightCollectionView()
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
    
    func changeIndexEkgDisplay() {
        indexShowAmp = 1
        setupApm()
        setupApm()
        scrollToTop()
        setupScrollView()
        view.layoutIfNeeded()
        showChartEkg()
        if indexListEkgDisplay == 3, !isShowingGrid, isPlaying {
            hideAllViewBottm(true)
            isShowingSelectionsEkg = false
        } else {
            isShowingSelectionsEkg = false
            setUpBottomCollectionView()
        }
        indexHighLight = 0
    }
    
    func hideAllViewBottm(_ isHidden: Bool) {
        isShowingSelectionsEkg = false
        let heightView = view.frame.height
        let heightSelectionsView = viewContainSelectionsEkg.frame.height
        infoStackview.isHidden = isHidden
        if isHidden {
            UIView.animate(withDuration: 0.3) {[weak self] in
                self?.viewContainSelectionsEkg.frame.origin.y = self?.view.frame.maxY ?? 0
                self?.viewBottom.frame.origin.y = heightView + heightSelectionsView
                self?.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.heightCollectionView.constant = 0
                self?.viewContainSelectionsEkg.frame = self?.frameSelections ?? .zero
                self?.viewBottom.frame = self?.frameBottomView ?? .zero
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
