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

        view.addSubview(corePlayer.view())
        
        corePlayer.view().translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.init(item: corePlayer.view(), attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint.init(item: corePlayer.view(), attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint.init(item: corePlayer.view(), attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint.init(item: corePlayer.view(), attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0).active = true

        corePlayer.playURL(NSURL(string: "http://pl.youku.com/playlist/m3u8?vid=351720339&type=mp4&ts=1449583723&keyframe=0&ep=eiaQE0yFVckC5iLZjj8bYnrrIHcOXP0P9xiHgdFhCdQgSO68&sid=8449583723166125f9d01&token=4063&ctype=12&ev=1&oip=1875120204")!)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

