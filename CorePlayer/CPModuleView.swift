//
//  CPModuleView.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

#if os(iOS)
    import UIKit
    public typealias UXView = UIView
#else
    import AppKit
    public typealias UXView = NSView
#endif
    
open class CPModuleView: UXView, CPModuleViewDelegate {
    
    open var moduleID: Int = 0
    open weak var moduleManager: CPModuleManager?
    open weak var moduleDelegate: CorePlayerFeature?
    
    open func moduleType() -> ModuleType {
        return .view
    }
    
    /**
     View hierarchy of player's view
    */
    open func viewIndex() -> Int {
        return 0
    }
    
    /**
     When player's view layout, do custom layout
    */
    open func layoutView() {
        
    }
    
    open func willShow() {
        #if os(iOS)
            alpha = 1
        #endif
    }
    
    open func willHide() {
        #if os(iOS)
            alpha = 0
        #endif
    }
    
    open func initModule() {
        
    }
    
    open func deinitModule() {
        
    }
}
