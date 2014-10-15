//
//  ThumbnailContainer.swift
//  Hipstagram
//
//  Created by Bradley Johnson on 10/15/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class ThumbnailContainer {
    
    var originalThumbnail : UIImage
    var filteredThumbnail : UIImage?
    var filterName : String
    var imageQueue : NSOperationQueue
    var gpuContext : CIContext
    var ciFilter : CIFilter?
    
    init(filterName : String, thumbNail : UIImage, queue : NSOperationQueue, context : CIContext) {
        self.originalThumbnail = thumbNail
        self.imageQueue = queue
        self.gpuContext = context
        self.filterName = filterName
    }
    
    func generateFilterThumbnail(completionHandler : (filteredThumb : UIImage) -> (Void)) {
        
        self.imageQueue.addOperationWithBlock { () -> Void in
            //setup filter
            var image = CIImage(image: self.originalThumbnail)
            var imgFilter = CIFilter(name:self.filterName)
            imgFilter.setDefaults()
            imgFilter.setValue(image, forKey: kCIInputImageKey)
            
            //generate result
            var result = imgFilter.valueForKey(kCIOutputImageKey) as CIImage
            var extent = result.extent()
            var imgRef = self.gpuContext.createCGImage(result, fromRect: extent)
            self.ciFilter =  imgFilter
            
            //run callback on main thread
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.filteredThumbnail = UIImage(CGImage: imgRef)
                completionHandler(filteredThumb: self.filteredThumbnail!)
            })
        }
    }
    
}
