//
//  ViewController.swift
//  CorePlayer
//
//  Created by flexih on 4/14/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var corePlayer: CorePlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        corePlayer = CorePlayer()
        corePlayer!.moduleManager().initModules([ModuleView.self])
        
        corePlayer!.view().frame = self.view.bounds
        corePlayer!.view().autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        view.addSubview(corePlayer!.view())
      
        corePlayer!.playURL(NSURL(string: "http://devimages.apple.com/samplecode/adDemo/ad.m3u8")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

