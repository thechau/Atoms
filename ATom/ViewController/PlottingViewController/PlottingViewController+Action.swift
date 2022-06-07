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
    if isShowingGrid {
      gridOnLabel.text = "Grid Off"
      girdButton.setImage(UIImage(named: "GridOFF"), for: .normal)
    } else {
      gridOnLabel.text = "Grid On"
      girdButton.setImage(UIImage(named: "GridON"), for: .normal)
    }
    setupGridBoard()
      
      if indexListEkgDisplay == 2 || indexListEkgDisplay == 3 {
          showChartEkg()
      }
  }
  
  @IBAction func onActionAmplitudeButton(_ sender: Any) {
    if indexHeightChartRatio == 3 {
        indexHeightChartRatio = 0
    } else {
        indexHeightChartRatio += 1
    }
    if indexHeightChartRatio == 3 {
      btnAmplitude.setImage(UIImage(named: "GainOFF"), for: .normal)
    } else {
      btnAmplitude.setImage(UIImage(named: "GainON"), for: .normal)
    }
    ampValueLabel.text = " " + ampList[indexHeightChartRatio].description + "mm/mV"
    showChartEkg()
  }
  
  /// show collection list Ekg
  @IBAction func onTapShowSelectionEkg(_ sender: Any) {
    isShowingSelectionsEkg = !isShowingSelectionsEkg
      showSelectionEkgBoard()
  }
  
  @IBAction func onTapNext(_ sender: Any?) {
      guard indexListEkgDisplay < displayList.count - 1 else {
          return
      }
      indexListEkgDisplay += 1
      changeTypeDisplay()
      btnAmplitude.isHidden = !(indexListEkgDisplay == 0)
  }
  
  @IBAction func onTapBack(_ sender: Any?) {
      guard indexListEkgDisplay > 0 else {
          return
      }
      indexListEkgDisplay -= 1
      changeTypeDisplay()
      btnAmplitude.isHidden = !(indexListEkgDisplay == 0)
  }
  
//  @IBAction func onTapExpandButton(_ sender: Any) {
//    isExpanding = !isExpanding
//    expandChartEkg()
      //showInfoBoard()
//
//      let y = !isExpanding ? getHeightMax(): getYMinOfDetailView()
//      setUpBottomCollectionView(y: y)
//  }
  
  func setupGridBoard() {
    if isShowingGrid {
      drawGridBoard()
    } else {
      drawSampleGridView()
    }
    scrollView.isScrollEnabled = !isShowingGrid
  }
  
  @IBAction func onTapPause(_ sender: Any?) {
    isPlaying = !isPlaying
    btnAmplitude.isHidden = !isPlaying
    if isPlaying {
      btnPause.setImage(UIImage(named: "pause"), for: .normal)
      pauseLabel.text = "Pause"
      infoStackview.isHidden = false
      DispatchQueue.main.asyncAfter(deadline: .now() + 20) {[weak self] in
        self?.btnReport.isEnabled = true
      }
    } else {
      btnPause.setImage(UIImage(named: "play-button"), for: .normal)
      pauseLabel.text = "Play"
      infoStackview.isHidden = true
      expandChartEkg()
      btnReport.isEnabled = false
    }
    showChartEkg()
  }
    
  func expandChartEkg() {
    isShowingSelectionsEkg = false
//    setupControlStactView()
    hideDetailIfNeed()
    }
}
