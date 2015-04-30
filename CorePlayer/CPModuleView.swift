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
    
public class CPModuleView: UXView, CPModuleViewDelegate {
    
    public var moduleID: Int = 0
    public weak var moduleManager: CPModuleManager?
    public weak var moduleDelegate: CorePlayerFeature?
    
    public func moduleType() -> ModuleType {
        return .View
    }
    
    public func viewIndex() -> NSInteger {
        return 0
    }
    
    public func layoutView() {
        
    }
    
    public func willShow() {
        #if os(iOS)
            alpha = 1
        #endif
    }
    
    public func willHide() {
        #if os(iOS)
            alpha = 0
        #endif
    }
    
    public func initModule() {
        
    }
    
    public func deinitModule() {
        
    }
}
