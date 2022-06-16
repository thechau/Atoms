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
      showChartEkg()
      setupScrollView()
      setupGridBoard()
      setupApm()
      showChartEkg()
      if indexListEkgDisplay == 3, isPlaying, !isShowingGrid {
          hideAllViewBottm(true)
          isShowingSelectionsEkg = false
      } else {
          isShowingSelectionsEkg = false
          hideAllViewBottm(false)
      }
      
  }
    
    func setupApm() {
        if !isShowingGrid {
            ampValueLabel.text = "Not to Scale"
            btnAmplitude.isHidden = true
        } else {
            ampValueLabel.text = " " + ampList[indexShowAmp].description + "mm/mV"
            btnAmplitude.isHidden = !(indexListEkgDisplay == 0)
        }
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
    showChartEkg()
    setupApm()
  }
  
  /// show collection list Ekg
  @IBAction func onTapShowSelectionEkg(_ sender: Any) {
      guard indexListEkgDisplay != 3 else {
          return
      }
      isShowingSelectionsEkg = !isShowingSelectionsEkg
      setUpBottomCollectionView()
  }
    
  @IBAction func onTapNext(_ sender: Any?) {
      guard indexListEkgDisplay < 3 else {
          return
      }
      indexListEkgDisplay += 1
      changeIndexEkgDisplay()
  }
  
  @IBAction func onTapBack(_ sender: Any?) {
      guard indexListEkgDisplay > 0 else {
          return
      }
      indexListEkgDisplay -= 1
      changeIndexEkgDisplay()
      
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
      pauseLabel.text = "Record"
      infoStackview.isHidden = true
      btnReport.isEnabled = false
    }
      if indexListEkgDisplay == 3, !isShowingGrid, isPlaying {
          hideAllViewBottm(true)
          isShowingSelectionsEkg = false
      } else {
          setUpBottomCollectionView()
      }
    showChartEkg()
  }
}
