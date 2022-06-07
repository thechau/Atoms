//
//  PlottingViewController+PanGesture.swift
//  ATOM
//
//  Created by Phan The Chau on 12/04/2022.
//
import UIKit

extension PlottingViewController {
    /// animation show detail view
    func showInfoBoard() {
        setupControlStactView()
        let y = !isShowingSelectionsEkg ? getHeightMax(): getYMinOfDetailView()
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
    
    /// show-hide control stack view
    func setupControlStactView() {
//      if isShowingSelectionsEkg {
//        controlStackView.isHidden = false
//      } else {
//        controlStackView.isHidden = isExpanding
//      }
    }
    //
    func hideDetailIfNeed() {
        contentCollectionView.isHidden = false
        setHeightCollectionView()
        heightCollectionView.constant = 0
        viewContainSelectionsEkg.frame.origin = CGPoint(x: 0, y: getYDetailView())
        viewContainSelectionsEkg.layoutSubviews()
        view.layoutSubviews()
    }
    
    func getYDetailView() -> CGFloat {
        switch (isShowingSelectionsEkg, isExpanding) {
        case (true, _):
            return view.frame.height - getHeightDetailView()
        case (false, true):
            return view.frame.height - 90
        default:
            return view.frame.height - 179
        }
    }
    
    func getYMinOfDetailView() -> CGFloat {
        return view.frame.height - getHeightDetailView()
    }
    
    func getHeightDetailView() -> CGFloat {
        return viewContainSelectionsEkg.frame.height
    }
    
    func getHeightMax() -> CGFloat {
        if isShowingGrid {
            return view.frame.height - 90
        } else {
            return view.frame.height - 179
        }
    }
    
    fileprivate func tableviewAction() {
        reloadData()
        titleCollectionView.scrollToItem(at: IndexPath(item: indexTypeDisplay, section: 0),
                                         at: .centeredHorizontally,
                                         animated: true)
    }
    
    func changeTypeDisplay() {
        indexHighLight = 0
        isShowingSelectionsEkg = false
//        isExpanding = false
        tableviewAction()
        hideDetailIfNeed()
        setupControlStactView()
        setupGridBoard()
    }
}
