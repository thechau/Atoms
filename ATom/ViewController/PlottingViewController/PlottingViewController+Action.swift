//
//  PlottingViewController+ViewDetail.swift
//  ATOM
//
//  Created by Admin on 20/04/2022.
//

import Foundation
import UIKit

extension PlottingViewController {
  @IBAction func onActionChangeSpeedSwicthButton(_ sender: Any) {
    duration = duration == 0.025 ? 0.015 : 0.025
    showChartEkg(at: indexHighLight)
  }
  
  @IBAction func onActionGridOnOffButton(_ sender: Any) {
    isOnGrid = !isOnGrid
    if isOnGrid {
      drawGridBoard()
    } else {
      removeGridView()
    }
    
  }
  
  @IBAction func onActionAmplitudeButton(_ sender: Any) {
    if Int(heightChartRatio + 0.2) == 3 {
      heightChartRatio = 1
    } else {
      heightChartRatio = heightChartRatio + 1
    }
    showChartEkg(at: indexHighLight)
  }
  
  @IBAction func onTapShowInfoDetail(_ sender: Any) {
    isShowingDetail = !isShowingDetail
    showInfoBoard()
  }
  
  @IBAction func onTapNext(_ sender: Any?) {
      guard indexTypeDisplay < displayList.count - 1 else {
          return
      }
      indexTypeDisplay += 1
      changeTypeDisplay()
  }
  
  @IBAction func onTapBack(_ sender: Any?) {
      guard indexTypeDisplay > 0 else {
          return
      }
      indexTypeDisplay -= 1
      changeTypeDisplay()
  }
  
  @IBAction func onTapExpandButton(_ sender: Any) {
    isExpanding = !isExpanding
    isShowingDetail = false
    setupControlStactView()
    setupGridBoard()
    hideDetailIfNeed()
    showChartEkg(at: indexHighLight)
  }
  
  func setupGridBoard() {
    if isExpanding {
      expandButton.setImage(UIImage(named: "zoom-out"), for: .normal)
      removeGridView()
    } else {
      expandButton.setImage(UIImage(named: "zoom-in"), for: .normal)
      drawGridBoard()
    }
    scrollView.isScrollEnabled = !isExpanding
  }
  
  @IBAction func onTapPause(_ sender: Any?) {
  }
//  
//  @IBAction func onTapPopButton(_ sender: Any?) {
//    navigationController?.popViewController(animated: true)
//  }
}
