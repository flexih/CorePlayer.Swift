//
//  CPModule.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import Foundation

@objc public class CPModule: NSObject, CPModuleDelegate {
    
    public var moduleID: Int = 0
    public weak var moduleManager: CPModuleManager?
    public weak var moduleDelegate: CorePlayerFeature?
    
    public func moduleType() -> ModuleType {
        return .Feature
    }

    public func initModule() {
        
    }
    
    public func deinitModule() {
        
    }
}
