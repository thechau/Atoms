//
//  CircularCollectionViewLayout.swift
//  CircularCollectionView
//
//  Created by Rounak Jain on 27/05/15.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
  
  var anchorPoint = CGPoint(x: 0.5, y:0.5)
    var centerX: CGFloat = 0.0
  var angle: CGFloat = 0 {
    didSet {
      zIndex = Int(angle*1000000)
      transform = CGAffineTransform(rotationAngle: angle)
    }
  }
  override func copy(with zone: NSZone? = nil) -> Any {
    let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
    copiedAttributes.anchorPoint = self.anchorPoint
    copiedAttributes.angle = self.angle
    return copiedAttributes
  }
  
}

protocol CircularCollectionViewLayoutDelegate {
    func collectionViewCurrentIndex(index: Int)
}


class CircularCollectionViewLayout: UICollectionViewLayout {
  
  let itemSize = CGSize(width: 8, height: 40)
  let itemSizeHead = CGSize(width: 30, height: 40)
  var delegate: CircularCollectionViewLayoutDelegate!
  private var contentHeight: CGFloat  = 10.0
  private var contentWidth: CGFloat   = 10.0
  public var maxEnd   = 0
  public var currentEnd   = 0
  private var firstTime   = false
  var angleAtExtreme: CGFloat {
    return collectionView!.numberOfItems(inSection: 0) > 0 ? -CGFloat(collectionView!.numberOfItems(inSection: 0)-1)*anglePerItem : 0
  }
  
  var angle: CGFloat {
    return angleAtExtreme*collectionView!.contentOffset.x/(collectionViewContentSize.width - collectionView!.bounds.size.width )
  }
    var anglePerItem: CGFloat {
        return atan(itemSize.width/radius)
    }
    
    
    var angleAtExtremeHead: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ? -CGFloat(collectionView!.numberOfItems(inSection: 0)-1)*anglePerItemHead : 0
    }
    
    var angleHead: CGFloat {
        return angleAtExtremeHead*collectionView!.contentOffset.x/(collectionViewContentSize.width - collectionView!.bounds.size.width)
    }
    var anglePerItemHead: CGFloat {
        return atan(itemSizeHead.width/radius)
    }
    var factor: CGFloat{
        return  -angleAtExtreme/(collectionViewContentSize.width - collectionView!.bounds.size.width)
    }
    
    
  
  var radius: CGFloat = 150 {
    didSet {
      invalidateLayout()
    }
  }
  
  
    
    func anglePerItem(index: Int)->CGFloat{
        if(index % 10 == 0){
            return atan(itemSizeHead.width/radius)
        }else{
            return atan(itemSize.width/radius)
        }
    }
  
  var attributesList = [CircularCollectionViewLayoutAttributes]()
  
  override var collectionViewContentSize: CGSize{
//    debugPrint(collectionView!.numberOfItems(inSection: 0))
    let numHeader = collectionView!.numberOfItems(inSection: 0) / 10
    let num = collectionView!.numberOfItems(inSection: 0) - numHeader
//    debugPrint("collectionViewContentSize: \(CGFloat(num)*itemSize.width + (CGFloat(numHeader) * itemSizeHead.width))")
    return CGSize(width: CGFloat(num)*itemSize.width + (CGFloat(numHeader) * itemSizeHead.width),
                  height: collectionView!.bounds.size.height)
  }
  
  override class var layoutAttributesClass: AnyClass {
    return CircularCollectionViewLayoutAttributes.self
  }
  
  
  override func prepare() {
    
    super.prepare()
    let centerX = collectionView!.contentOffset.x + ((collectionView!.bounds.size.width)/2.0)
    let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
    debugPrint(anchorPointY)
    //1
    let theta = atan2((collectionView!.bounds.size.width)/2.0, radius + (itemSize.height/2.0) - ((collectionView!.bounds.size.height)/2.0)) //1
    //2
    var startIndex = 0
    var endIndex = collectionView!.numberOfItems(inSection: 0) - 1
    //3
    if (angle < -theta) {
      startIndex = Int(floor((-theta - angle)/anglePerItem))
    }
    //4
    endIndex = min(endIndex, Int(ceil((theta - angle)/anglePerItem)))
    //5
    if (endIndex < startIndex) {
      endIndex = 0
      startIndex = 0
    }
    if(!firstTime){
        maxEnd = endIndex
        firstTime = true
    }
    debugPrint("start:\(startIndex) - end:\(endIndex)")
    currentEnd = endIndex
    attributesList = (startIndex...endIndex).map { (i) -> CircularCollectionViewLayoutAttributes in
      let attributes = CircularCollectionViewLayoutAttributes(forCellWith: NSIndexPath(item: i, section: 0) as IndexPath)
        if(i % 10 == 0){
            attributes.size = self.itemSizeHead
        }else{
            attributes.size = self.itemSize
        }
        
      attributes.center = CGPoint(x: centerX, y: (self.collectionView!.bounds).midY)
      attributes.angle = self.angle + (self.anglePerItem*CGFloat(i))
      attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
      attributes.centerX = attributes.center.x
        
    debugPrint("\(anglePerItem)")
        if(startIndex == 0){
            self.delegate.collectionViewCurrentIndex(index: (endIndex - maxEnd) < 0 ? 0 :  (endIndex - maxEnd))
        }else if(endIndex == collectionView!.numberOfItems(inSection: 0) - 1){
            let max = collectionView!.numberOfItems(inSection: 0) - 1
            self.delegate.collectionViewCurrentIndex(index: (startIndex + maxEnd) > max ? max :  (startIndex + maxEnd))
        }else{
            self.delegate.collectionViewCurrentIndex(index: endIndex - ((endIndex - startIndex)/2))
        }
      return attributes
    }
    
  }
    
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      return attributesList
  }
//  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//    return attributesList[indexPath.row]
//  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  
//Uncomment the section below to activate snapping behavior
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    var finalContentOffset = proposedContentOffset
        let factor = -angleAtExtreme/(collectionViewContentSize.width - collectionView!.bounds.size.width)
    let proposedAngle = proposedContentOffset.x*factor
    let ratio = proposedAngle/anglePerItem
    var multiplier: CGFloat
    if (velocity.x > 0) {
      multiplier = ceil(ratio)
    } else if (velocity.x < 0) {
      multiplier = floor(ratio)
    } else {
      multiplier = round(ratio)
    }
    finalContentOffset.x = multiplier*anglePerItem/factor
    return finalContentOffset
  }
}
