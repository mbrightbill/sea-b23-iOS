//
//  PhotosFrameworkViewController.swift
//  Hipstagram
//
//  Created by Bradley Johnson on 10/15/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit
import Photos

class PhotosFrameworkViewController: UIViewController, UICollectionViewDataSource {
    
    var assetFetchResults: PHFetchResult!
    var assetCollection: PHAssetCollection!
    var imageManager: PHCachingImageManager!
    var assetCellSize: CGSize!
    
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //THIS IS THE START OF NEW STUFF WE LEARNED ON DAY 3
        
        // Get image image, asset fetch results
        self.imageManager = PHCachingImageManager()
        
        // Pass nil, fetch all assets
        self.assetFetchResults = PHAsset.fetchAssetsWithOptions(nil)
        
        // Determine device scale, adjust asset cell size
        var scale = UIScreen.mainScreen().scale
        var flowLayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        
        var cellSize = flowLayout.itemSize
        self.assetCellSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetFetchResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PHOTOS_CELL", forIndexPath: indexPath) as PhotosFrameworkCell
        
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        
        var asset = self.assetFetchResults[indexPath.row] as PHAsset
        
        self.imageManager.requestImageForAsset(asset, targetSize: self.assetCellSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
            
            if cell.tag == currentTag {
                cell.imageView.image = image
            }
        }
        
        return cell
    }
}

