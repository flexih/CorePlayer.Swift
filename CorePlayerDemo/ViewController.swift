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
    
    var corePlayer: CorePlayer = {
        let cp = CorePlayer()
        cp.moduleManager().initModules([ModuleView.self, ProgressView.self])
        return cp
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        corePlayer.view().frame = self.view.bounds
        corePlayer.view().autoresizingMask = UIViewAutoresizing.flexibleWidth.union(UIViewAutoresizing.flexibleHeight)
        view.addSubview(corePlayer.view())
      
        corePlayer.playURL(URL(string: "http://devimages.apple.com/samplecode/adDemo/ad.m3u8")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        corePlayer.stop()
    }
}

