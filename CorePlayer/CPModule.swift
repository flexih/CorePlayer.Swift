//
//  CPModule.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import Foundation

@objc open class CPModule: NSObject, CPModuleDelegate {
    
    open var moduleID: Int = 0
    open weak var moduleManager: CPModuleManager?
    open weak var moduleDelegate: CorePlayerFeature?
    
    open func moduleType() -> ModuleType {
        return .feature
    }

    open func initModule() {
        
    }
    
    open func deinitModule() {
        
    }
}
