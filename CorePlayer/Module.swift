//
//  CPModule.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import Foundation

public class Module: ModuleDelegate {
    
    public weak var moduleManager: ModuleManager?
    public weak var moduleDelegate: CorePlayerFeature?

    public func initModule() {
    }
    
    public func deinitModule() {
    }

}
