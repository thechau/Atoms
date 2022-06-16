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
      if indexListEkgDisplay == 3 {
          if isPlaying {
              hideAllViewBottm(true)
          }
//          hideAllViewBottm(!isShowingGrid)
      }
      showChartEkg()
      setupScrollView()
      setupGridBoard()
      
  }
  
  @IBAction func onActionAmplitudeButton(_ sender: Any) {
    if indexShowAmp == 3 {
        indexShowAmp = 0
    } else {
        indexShowAmp += 1
    }
    if indexShowAmp == 3 {
      btnAmplitude.setImage(UIImage(named: "GainOFF"), for: .normal)
    } else {
      btnAmplitude.setImage(UIImage(named: "GainON"), for: .normal)
    }
    ampValueLabel.text = " " + ampList[indexShowAmp].description + "mm/mV"
    showChartEkg()
  }
  
  /// show collection list Ekg
  @IBAction func onTapShowSelectionEkg(_ sender: Any) {
      guard indexListEkgDisplay != 3 else {
          return
      }
    isShowingSelectionsEkg = !isShowingSelectionsEkg
    showSelectionEkgBoard()
  }
  
  @IBAction func onTapNext(_ sender: Any?) {
      guard indexListEkgDisplay < displayList.count - 1 else {
          return
      }
      indexListEkgDisplay += 1
      changeTypeDisplay()
  }
  
  @IBAction func onTapBack(_ sender: Any?) {
      guard indexListEkgDisplay > 0 else {
          return
      }
      indexListEkgDisplay -= 1
      changeTypeDisplay()
      
  }
  
  @IBAction func onTapPause(_ sender: Any?) {
      isPlaying = !isPlaying
      btnAmplitude.isHidden = !isPlaying
      hideAllViewBottm(isPlaying && indexListEkgDisplay == 3)
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
      btnReport.isEnabled = false
    }
    showChartEkg()
  }
}
