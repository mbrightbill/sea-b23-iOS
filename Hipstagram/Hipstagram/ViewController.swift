//
//  ViewController.swift
//  Hipstagram
//
//  Created by Bradley Johnson on 10/15/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, GalleryDelegate, UICollectionViewDataSource {
    
    var managedObjectContext : NSManagedObjectContext!
    var filters : [Filter]?
    var thumbnailContainers = [ThumbnailContainer]()
    var originalThumbnail : UIImage?
    var gpuContext : CIContext?
    var imageQueue = NSOperationQueue()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //get gpu context
        var options = [kCIContextWorkingColorSpace : NSNull()]
        var myEAGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        self.gpuContext = CIContext(EAGLContext: myEAGLContext, options: options)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Filter")
        var error : NSError?
        //first fetch to see if we have anything in the database
        if let filters = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Filter] {
            //checking if that fetch produced any items
            if filters.isEmpty {
                //its empty, now we gotta seed it
                self.seedCoreData()
                self.filters = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Filter]
            } else {
                self.filters = filters
            }
        }
        
        self.collectionView.dataSource = self
    }
    
    func seedCoreData() {
        
        //var newFilter = Filter() //this wont work!
        var sepiaFilter = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        sepiaFilter.name = "CISepiaTone"
        sepiaFilter.favorited = true
        
        var gaussianBlurFilter = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        gaussianBlurFilter.name = "CIGaussianBlur"
        gaussianBlurFilter.favorited = false
        
        var error : NSError?
        //this attempts to save everything in the context into the database
        self.managedObjectContext.save(&error)
        if error != nil {
            println(error!.localizedDescription)
        }
    }
    
    func resetThumbnails() {
        
        //first we generate the thumbnail from the image that was selected
        var size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        self.imageView.image?.drawInRect(CGRect(x: 0, y: 0, width: 100, height: 100))
        self.originalThumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //now we need to setup our thumbnail containers
        var newThumbnailContainers = [ThumbnailContainer]()
        for var index = 0; index < self.filters?.count; ++index {
            let filter = self.filters![index]
            var thumbnailContainer = ThumbnailContainer(filterName: filter.name, thumbNail: self.originalThumbnail!, queue: self.imageQueue, context: self.gpuContext!)
            newThumbnailContainers.append(thumbnailContainer)
        }
        self.thumbnailContainers = newThumbnailContainers
        self.collectionView.reloadData()
    }

    @IBAction func hipmePressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.performSegueWithIdentifier("SHOW_GALLERY", sender: self)
        }
        
        let photosActions = UIAlertAction(title: "Photos Framework", style: .Default) { (action) -> Void in
        self.performSegueWithIdentifier("SHOW_PHOTOS_FRAMEWORK", sender: self)
        }
        
        alertController.addAction(galleryAction)
        alertController.addAction(photosActions)
        
        self.presentViewController(alertController, animated: true, completion: nil) 
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_GALLERY" {
            let galleryVC = segue.destinationViewController as GalleryViewController
            galleryVC.delegate = self
            
        }
    }
    
    func userDidSelectPhoto(image: UIImage) {
        self.imageView.image = image
        self.resetThumbnails()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.thumbnailContainers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("THUMBNAIL_CELL", forIndexPath: indexPath) as ThumbnailCell
        let thumbnailContainer = self.thumbnailContainers[indexPath.row]
        if thumbnailContainer.filteredThumbnail != nil {
            cell.imageView.image = thumbnailContainer.filteredThumbnail
        } else {
            cell.imageView.image = thumbnailContainer.originalThumbnail
    thumbnailContainer.generateFilterThumbnail({ (filteredThumb) -> (Void) in
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ThumbnailCell {
                    cell.imageView.image = filteredThumb
                }
            })
            
        }
        return cell
    }
}

