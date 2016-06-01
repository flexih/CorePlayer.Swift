//
//  CPModuleViewDelegate.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import Foundation

public protocol ModuleViewDelegate: ModuleDelegate {
    
    var moduelIndex: Int { get set }
    var moduleShow: Bool { get set }

    /**
     When player's view layout, do custom layout
     */
    func layoutView()
    func willShow()
    func willHide()
}

extension ModuleViewDelegate where Self: UXView {

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

}
