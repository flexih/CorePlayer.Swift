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
        corePlayer!.moduleManager()?.initModules([ModuleView.self])
        
        corePlayer!.view().frame = self.view.bounds
        corePlayer!.view().autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        view.addSubview(corePlayer!.view())
      
        corePlayer!.playURL(NSURL(string: "http://123.125.86.20/vkp.tc.qq.com/j0016umw57z.p201.1.mp4?sdtfrom=v1000&type=mp4&vkey=BFEBAB06E35F969421FB065009347367697D5AF19DA218F37BC06F04CD09696A09F56B64ECA987A12FAFF35C9988B57EB2D9161D04413E38D08D2516DACE4360C8DAEA7435CC1948E614DADBC2A3CBD5FE4305C4A1620533&level=0&platform=11&br=127&fmt=shd&sp=0&guid=A34AB4CD299BDA0B7352BE9FE21D94A102023F27")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

