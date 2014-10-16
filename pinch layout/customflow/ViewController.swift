//
//  ViewController.swift
//  customflow
//
//  Created by Bradley Johnson on 10/15/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var flowlayout : UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.flowlayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        // Do any additional setup after loading the view, typically from a nib.
        
        var pinch = UIPinchGestureRecognizer(target: self, action: "pinchAction:")
        self.collectionView.addGestureRecognizer(pinch)
    }
    
    func pinchAction(pinch : UIPinchGestureRecognizer) {
        println("hello")
      
        
        if pinch.state == UIGestureRecognizerState.Ended {
            println("ended")
            println(pinch.velocity)
            self.collectionView.performBatchUpdates({ () -> Void in
                if pinch.velocity > 0 {
                    self.flowlayout.itemSize = CGSize(width: self.flowlayout.itemSize.width * 2, height: self.flowlayout.itemSize.height * 2)
                } else {
                    self.flowlayout.itemSize = CGSize(width: self.flowlayout.itemSize.width * 0.5, height: self.flowlayout.itemSize.height * 0.5)
                }
                }, completion: nil )
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as UICollectionViewCell
        return cell
    }


}

