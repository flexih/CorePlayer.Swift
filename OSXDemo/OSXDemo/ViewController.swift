//
//  ViewController.swift
//  OSXDemo
//
//  Created by flexih on 12/8/15.
//  Copyright © 2015 flexih. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let corePlayer = CorePlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        corePlayer.moduleManager().initModules([EventModule.self])
        corePlayer.view().translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(corePlayer.view())

        NSLayoutConstraint.init(item: corePlayer.view(), attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint.init(item: corePlayer.view(), attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint.init(item: corePlayer.view(), attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint.init(item: corePlayer.view(), attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0).active = true

        corePlayer.playURL(NSURL(string: "http://devimages.apple.com/samplecode/adDemo/ad.m3u8")!)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

