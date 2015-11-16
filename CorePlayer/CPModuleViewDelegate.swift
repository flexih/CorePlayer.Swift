//
//  CPModuleViewDelegate.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import Foundation

@objc public protocol CPModuleViewDelegate: CPModuleDelegate {
    
    func viewIndex() -> Int
    func layoutView()
    func willShow()
    func willHide()
}
