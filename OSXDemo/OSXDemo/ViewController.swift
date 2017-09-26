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

        NSLayoutConstraint.init(item: corePlayer.view(), attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: corePlayer.view(), attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: corePlayer.view(), attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: corePlayer.view(), attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        corePlayer.playURL(NSURL(string: "http://devimages.apple.com/samplecode/adDemo/ad.m3u8")! as URL)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    deinit {
        corePlayer.stop()
    }
}

