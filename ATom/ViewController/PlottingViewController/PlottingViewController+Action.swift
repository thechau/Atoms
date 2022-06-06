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
    duration = duration == 0.02 ? 0.01 : 0.02
    showChartEkg()
  }
  
  @IBAction func onActionGridOnOffButton(_ sender: Any) {
    isShowingGrid = !isShowingGrid
      showChartEkg()
    vwGridBoard.isHidden = !isShowingGrid
      if isShowingGrid {
          gridOnLabel.text = "Grid On"
          girdButton.setImage(UIImage(named: "Grid On"), for: .normal)
      } else {
          gridOnLabel.text = "Grid Off"
          girdButton.setImage(UIImage(named: "Grid Off"), for: .normal)
      }
    gridOnLabel.text = isShowingGrid ? "Grid On" : "Grid Off"
      
  }
  
  @IBAction func onActionAmplitudeButton(_ sender: Any) {
    if indexHeightChartRatio == 3 {
        indexHeightChartRatio = 0
    } else {
        indexHeightChartRatio += 1
    }
      ampValueLabel.text = " " + ampList[indexHeightChartRatio].description + "mm/mV"
    showChartEkg()
  }
  
    /// show collection list Ekg
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
      btnAmplitude.isHidden = !(indexTypeDisplay == 0)
  }
  
  @IBAction func onTapBack(_ sender: Any?) {
      guard indexTypeDisplay > 0 else {
          return
      }
      indexTypeDisplay -= 1
      changeTypeDisplay()
      btnAmplitude.isHidden = !(indexTypeDisplay == 0)
  }
  
  @IBAction func onTapExpandButton(_ sender: Any) {
    isExpanding = !isExpanding
    expandChartEkg()
  }
  
  func setupGridBoard() {
    if isExpanding {
      removeGridView()
    } else {
      drawGridBoard()
    }
    scrollView.isScrollEnabled = !isExpanding
  }
  
  @IBAction func onTapPause(_ sender: Any?) {
    isPlaying = !isPlaying
    if isPlaying {
      btnPause.setImage(UIImage(named: "pause"), for: .normal)
      pauseLabel.text = "Pause"
      infoStackview.isHidden = false
    } else {
      btnPause.setImage(UIImage(named: "play-button"), for: .normal)
      pauseLabel.text = "Play"
      infoStackview.isHidden = true
    expandChartEkg()
    }
      showChartEkg()
  }
    
    func expandChartEkg() {
        isShowingDetail = false
        setupControlStactView()
        setupGridBoard()
        hideDetailIfNeed()
        showChartEkg()
    }
}
