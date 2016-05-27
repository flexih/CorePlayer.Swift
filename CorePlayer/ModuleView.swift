//
//  CPModuleView.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//
    
public class CPModuleView: UXView, ModuleViewDelegate {
    
    public weak var moduleManager: ModuleManager?
//    public weak var moduleDelegate: CorePlayerFeature?

    public var moduelIndex: Int = 0
    public var moduleShow: Bool = false

    public func moduleType() -> ModuleType {
        return .View
    }
    
    public func layoutView() {
    }

    
    public func initModule() {
    }

    public func deinitModule() {
    }
}
