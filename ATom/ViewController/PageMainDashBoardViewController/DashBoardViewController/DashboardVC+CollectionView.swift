//
//  File.swift
//  ATom
//
//  Created by Phan The Chau on 30/12/2021.
//  Copyright © 2021 phan.the.chau. All rights reserved.
//

import Foundation
import UIKit

extension DashBoardViewController: UICollectionViewDelegateFlowLayout {
    func addFakeShadownModel() {
        let shadowSize: CGFloat = 10
        let contactRect = CGRect(x: -shadowSize * 4, y: shadownLabel.frame.size.height - (shadowSize * 0.4), width: shadownLabel.frame.size.width + shadowSize * 8, height: shadowSize)
        shadownLabel.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        shadownLabel.layer.shadowRadius = 5
        shadownLabel.layer.shadowOpacity = 0.4
    }
    
    func configCollectionView() {
        collectionView.register(UINib(nibName: "DashBoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DashBoardCollectionViewCell")
        
        collectionView.register(UINib(nibName: "DashBoardReportCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DashBoardReportCollectionViewCell")
        
        collectionView.register(UINib(nibName: "DashBoardElectrodesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DashBoardElectrodesCollectionViewCell")

        collectionView.delegate = self
        collectionView.dataSource = self
        
        failedToConnectView.isHidden = true
        failedToConnectView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension DashBoardViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardCollectionViewCell", for: indexPath) as! DashBoardCollectionViewCell
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardReportCollectionViewCell", for: indexPath) as! DashBoardReportCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardElectrodesCollectionViewCell", for: indexPath) as! DashBoardElectrodesCollectionViewCell
          cell.delegate = self
                return cell
        }
    }
}

extension DashBoardViewController: DashBoardElectrodesCollectionViewCellDelegate {
  func dashBoardElectrodesCollectionViewCell(cell: DashBoardElectrodesCollectionViewCell, onTapNext sender: Any?) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "PlottingViewController") as! PlottingViewController
    navigationController?.pushViewController(vc, animated: true)
  }
}
