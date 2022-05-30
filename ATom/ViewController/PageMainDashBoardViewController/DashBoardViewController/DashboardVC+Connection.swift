//
//  File.swift
//  ATom
//
//  Created by Phan The Chau on 30/12/2021.
//  Copyright © 2021 phan.the.chau. All rights reserved.
//

import Foundation
import UIKit

extension DashBoardViewController: DashBoardCollectionViewCellDelegate {
    func connect() {
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        animationRotate()
        after(interval: 1) {
            self.connectDevice()
        }
    }
    
    func connectDevice() {
        circleNode1.runAction(circleNodeAction)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (Timer) in
            if self?.cuontConnect != 3 {
                self?.cuontConnect += 1
                //let cell = self?.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! DashBoardReportCollectionViewCell
            } else {
                self?.cuontConnect = 0
                self?.timer.invalidate()
                self?.resultConnect()
            }
        })
    }
    
    func isShowFailedToConnect(isShow: Bool) {
        if isShow {
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.failedToConnectView.isHidden = false
            })
        } else {
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.failedToConnectView.isHidden = true
            })
        }
    }
    
    func resultConnect() {
        let result = Int.random(in: 1...2)
        if result == 1 {
            circleNode1.removeAllActions()
            isShowFailedToConnect(isShow: true)
        } else {
            circleNode1.removeAllActions()
            circleNode1.removeFromParentNode()
            collectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
