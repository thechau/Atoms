//
//  CollectionViewController.swift
//  CircularCollectionView
//
//  Created by Rounak Jain on 10/05/15.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  
  
  
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  let images: [String] = Bundle.main.paths(forResourcesOfType: "png", inDirectory: "Images") 
  var number: [String] = [String]()
  override func viewDidLoad() {
    super.viewDidLoad()
    // Register cell classes
    collectionView!.register(UINib(nibName: "CircularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    let imageView = UIImageView(image: UIImage(named: "bg-dark.jpg"))
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    collectionView!.backgroundView = imageView
    for i in 0...99{
      number.append(String(i))
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return number.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CircularCollectionViewCell
//    cell.imageName = images[indexPath.row]
    return cell

  }
  
 
  
//   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//  }
  
  
}

//extension CollectionViewController: UICollectionViewDataSource {
//
//  // MARK: UICollectionViewDataSource
//
//  override func collectionView(collectionView: UICollectionView,
//    numberOfItemsInSection section: Int) -> Int {
//      return images.count
//  }
//
//  override func collectionView(collectionView: UICollectionView,
//    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CircularCollectionViewCell
//      cell.imageName = images[indexPath.row]
//      return cell
//  }
//
//}
