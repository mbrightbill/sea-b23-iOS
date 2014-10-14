//
//  ViewController.swift
//  PhotoFilters
//
//  Created by Bradley Johnson on 10/13/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit
import CoreImage
import CoreData
import OpenGLES


class ViewController: UIViewController, GalleryDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    var context : CIContext?
    var originalThumbnail : UIImage?
    //core data array
    var filters = [Filter]()
    //array of thumbnail wrapper objects
    var filterThumbnails = [FilterThumbnail]()
    
    let imageQueue = NSOperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting up our core image context
        self.generateThumbnail()
        var options = [kCIContextWorkingColorSpace : NSNull()]
        var myEAGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        self.context = CIContext(EAGLContext: myEAGLContext, options: options)
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var seeder = CoreDataSeeder(context: appDelegate.managedObjectContext!)
        
        //seeder.seedCoreData()
        self.fetchFilters()
        self.resetFilterThumbnails()
        
        
//        self.filterNames.append("CISepiaTone")
//        self.filterNames.append("CIGaussianBlur")
//        self.filterNames.append("CIGammaAdjust")
//        self.filterNames.append("CIGlassDistortion")
        
        var image = UIImage(named: "photo2.jpg")
        println(image.size)
        self.collectionView.dataSource = self
    }
    
    func generateThumbnail () {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        self.imageView.image?.drawInRect(CGRect(x: 0, y: 0, width: 100, height: 100))
        self.originalThumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
//    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
//        if identifier == "SHOW_GALLERY" {
////            let destinationVC =
//        }
//    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_GALLERY" {
            let destinationVC = segue.destinationViewController as GalleryViewController
            destinationVC.delegate = self
           // destinationVC.myParentViewController = self
        }
    }
    
    func enterFilterMode() {
        self.imageViewTrailingConstraint.constant = self.imageViewTrailingConstraint.constant * 3
        self.imageViewLeadingConstraint.constant = self.imageViewLeadingConstraint.constant * 3
        self.imageViewBottomConstraint.constant = self.imageViewBottomConstraint.constant * 3
        self.collectionViewBottomConstraint.constant = 100
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "exitFilteringMode")
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func exitFilteringMode () {
        
        //reset the contraints back to normal values
        //remove the Done button
        self.navigationItem.rightBarButtonItem = nil
    }
    @IBAction func photosPressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: "Choose an option", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.performSegueWithIdentifier("SHOW_GALLERY", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                
            }
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        let filterAction = UIAlertAction(title: "Filters", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            self.enterFilterMode()
        }
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(filterAction)
          self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapOnPicture(image : UIImage) {
        println("did tap on picture")
        self.imageView.image = image
        self.generateThumbnail()
        self.resetFilterThumbnails()
        self.collectionView.reloadData()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FILTER_CELL", forIndexPath: indexPath) as FilterThumbnailCell
        var filterThumbnail = self.filterThumbnails[indexPath.row]
        //lazing loading
        if filterThumbnail.filteredThumbnail != nil {
            cell.imageView.image = filterThumbnail.filteredThumbnail
        } else {
            cell.imageView.image = filterThumbnail.originalThumbnail
            filterThumbnail.generateThumbnail({ (image) -> Void in
                
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? FilterThumbnailCell {
                    cell.imageView.image = image
                }
            })
        }
//        var filterThumbnail = FilterThumbnail(name: self.filterNames[indexPath.row], thumbnail: self.originalThumbnail!, queue: self.imageQueue, context: self.context!)
//        filterThumbnail.generateThumbnail { (image) -> Void in
//            cell.imageView.image = image
//
        //cell.imageView.image = self.originalThumbnail
        return cell
    }

    func fetchFilters() {
        var fetchRequest = NSFetchRequest(entityName: "Filter")
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context = appDelegate.managedObjectContext
        
        var error: NSError?
        let fetchResults = context?.executeFetchRequest(fetchRequest, error: &error)
        if let filters = fetchResults as? [Filter] {
            println("filters: \(filters.count)")
            self.filters = filters
        }
    }
    
    func resetFilterThumbnails () {
        var newFilters = [FilterThumbnail]()
        for var index = 0; index < self.filters.count; ++index {
            var filter = self.filters[index]
            var filterName = filter.name
            var thumbnail = FilterThumbnail(name: filterName, thumbnail: self.originalThumbnail!, queue: self.imageQueue, context: self.context!)
            newFilters.append(thumbnail)
        }
        self.filterThumbnails = newFilters
    }
}

