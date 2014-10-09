//
//  ViewController.swift
//  PushPopnLock
//
//  Created by Bradley Johnson on 10/9/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        println(self.navigationController?.viewControllers.count)
//        self.navigationItem.titleView = UIView(frame: CGRect(x: 20, y: 20, width: 50, height: 50))
//        self.navigationItem.titleView?.backgroundColor = UIColor.purpleColor()
        var barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "cameraPressed")
        self.navigationItem.rightBarButtonItem = barButton
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        
        let newVC = self.storyboard?.instantiateViewControllerWithIdentifier("BUTTON_VC") as ViewController
        newVC.view.backgroundColor = UIColor.redColor()
        newVC.countLabel.text = "sdofijsdoifj"
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

