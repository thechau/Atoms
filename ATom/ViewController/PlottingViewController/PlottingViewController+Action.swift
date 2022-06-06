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
    gridOnLabel.text = isShowingGrid ? "Grid On" : "Grid Off"
  }
  
  @IBAction func onActionAmplitudeButton(_ sender: Any) {
    if Int(heightChartRatio + 0.2) == 4 {
      heightChartRatio = 1
    } else {
      heightChartRatio = heightChartRatio + 1
    }
      ampValueLabel.text = " " + ampList[Int(heightChartRatio + 0.2)].description + "mm/mV"
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
      //showInfoBoard()
//
//      let y = !isExpanding ? getHeightMax(): getYMinOfDetailView()
//      setUpBottomCollectionView(y: y)
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
    isPlaying = !isPlaying
    infoStackview.isHidden = !isPlaying
      expandButton.isHidden = !isPlaying
      btnAmplitude.isHidden = !isPlaying
    if isPlaying {
      btnPause.setImage(UIImage(named: "pause"), for: .normal)
      pauseLabel.text = "Pause"
    } else {
      btnPause.setImage(UIImage(named: "play-button"), for: .normal)
      pauseLabel.text = "Play"
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
