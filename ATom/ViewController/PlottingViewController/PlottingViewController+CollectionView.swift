//
//  PlottingViewController+CollectionView.swift
//  ATOM
//
//  Created by Phan The Chau on 12/04/2022.
//

import Foundation
import UIKit


extension PlottingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func reloadData() {
        contentCollectionView.reloadData()
        titleCollectionView.reloadData()
    }
    
    func setHeightCollectionView() {
        switch displayList[indexListEkgDisplay] {
        case .oneEkg:
            heightCollectionView.constant = 4 * (heightItem + 10)
        case .threeEkg:
            heightCollectionView.constant = 2 * (heightItem + 10)
        case .sixEkg:
            heightCollectionView.constant = 2 * (heightItem + 10)
        case .twelveEkg:
            heightCollectionView.constant = 0
        }
    }
    
    func initCollectionView() {
        contentCollectionView.register(UINib(nibName: "OneLeadCell", bundle: nil), forCellWithReuseIdentifier: "OneLeadCell")
        contentCollectionView.register(UINib(nibName: "ThreeLeadCell", bundle: nil), forCellWithReuseIdentifier: "ThreeLeadCell")
        contentCollectionView.register(UINib(nibName: "SixLeadCell", bundle: nil), forCellWithReuseIdentifier: "SixLeadCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.contentCollectionView {
            if indexListEkgDisplay == 0 {
                return oneLeadList.count
            } else if indexListEkgDisplay == 1 {
                return threeLeadList.count
            } else if indexListEkgDisplay == 2 {
                return sixLeadList.count
            }
            return 0
        } else {
            return displayList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.contentCollectionView {
            if indexListEkgDisplay == 0 {
                let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: "OneLeadCell", for: indexPath) as! OneLeadCell
                cell.set(title: oneLeadList[indexPath.item], isHighlight: indexHighLight == indexPath.item)
                return cell
                
            } else if indexListEkgDisplay == 1 {
                let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: "ThreeLeadCell", for: indexPath) as! ThreeLeadCell
                cell.set(titles: threeLeadList[indexPath.item],
                         isHighlight: indexHighLight == indexPath.item)
                return cell
            } else if indexListEkgDisplay == 2 {
                let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: "SixLeadCell", for: indexPath) as! SixLeadCell
                cell.set(titles: sixLeadList[indexPath.item],
                         isHighlight: indexHighLight == indexPath.item)
                return cell
            }
            
            return UICollectionViewCell()
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleClvCell", for: indexPath) as! TitleClvCell
            cell.set(displayList[indexListEkgDisplay])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === self.contentCollectionView {
            indexHighLight = indexPath.item
            reloadData()
        }
    }
}

extension PlottingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === contentCollectionView {
            var witdhCell: CGFloat
            switch displayList[indexListEkgDisplay] {
            case .oneEkg:
                witdhCell = (contentCollectionView.frame.width - 50 ) / 3
            case .threeEkg:
                witdhCell = (contentCollectionView.frame.width - 20) / 2
            case .sixEkg:
                witdhCell = contentCollectionView.frame.width
            case .twelveEkg:
                witdhCell = contentCollectionView.frame.width / 2
            }
            return CGSize(width: witdhCell, height: heightItem)
        } else {
            return collectionView.bounds.size
        }
    }
}

extension PlottingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = self.titleCollectionView.frame.size.width
        indexListEkgDisplay = Int(self.titleCollectionView.contentOffset.x / pageWidth)
        titleCollectionView.reloadData()
        reloadData()
      changeTypeDisplay()
    }
}
