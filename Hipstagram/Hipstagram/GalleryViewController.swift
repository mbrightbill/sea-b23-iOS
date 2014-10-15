//
//  GalleryViewController.swift
//  Hipstagram
//
//  Created by Bradley Johnson on 10/15/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

protocol GalleryDelegate {
    func userDidSelectPhoto(image : UIImage) -> (Void)
}

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var images = [UIImage]()
    
    var delegate : GalleryDelegate?

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var image1 = UIImage(named: "photo2.jpg")
        var image2 = UIImage(named: "photo3.jpg")
        self.images.append(image1)
        self.images.append(image2)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as GalleryCell
        cell.imageView.image = self.images[indexPath.row]
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    self.delegate?.userDidSelectPhoto(self.images[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)   
    }

}
