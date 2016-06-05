//
//  CorePlayer+Internal.swift
//  CorePlayerDemo
//
//  Created by flexih on 6/2/16.
//  Copyright © 2016 flexih. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

extension CorePlayer: ContentLayoutManager {
    
    func contentsLayout(view: UXView) {
        if let v = view.subviews.first as? PlayerView {
            v.frame = view.bounds
        }
        
        moduleManager.layoutView()
    }
    
    #if os(iOS)
    
    func contentsTouchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        moduleManager.touchesBegan(touches, withEvent: event)
    }
    
    func contentsTouchesMoved(touches: Set<NSObject>, withEvent event: UIEvent?) {
        moduleManager.touchesMoved(touches, withEvent: event)
    }
    
    func contentsTouchesEnded(touches: Set<NSObject>, withEvent event: UIEvent?) {
        moduleManager.touchesEnded(touches, withEvent: event)
    }
    
    func contentsTouchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent?) {
        moduleManager.touchesCancelled(touches, withEvent: event)
    }
    
    #else
    
    func contentsMouseDown(theEvent: NSEvent) {
        moduleManager.mouseDown(theEvent)
    }
    
    func contentsRightMouseDown(theEvent: NSEvent) {
        moduleManager.rightMouseDown(theEvent)
    }
    
    func contentsOtherMouseDown(theEvent: NSEvent) {
        moduleManager.otherMouseDown(theEvent)
    }
    
    func contentsMouseUp(theEvent: NSEvent) {
        moduleManager.mouseUp(theEvent)
    }
    
    func contentsRightMouseUp(theEvent: NSEvent) {
        moduleManager.rightMouseUp(theEvent)
    }
    
    func contentsOtherMouseUp(theEvent: NSEvent) {
        moduleManager.otherMouseUp(theEvent)
    }
    
    func contentsMouseMoved(theEvent: NSEvent) {
        moduleManager.mouseMoved(theEvent)
    }
    
    func contentsMouseDragged(theEvent: NSEvent) {
        moduleManager.mouseDragged(theEvent)
    }
    
    func contentsScrollWheel(theEvent: NSEvent) {
        moduleManager.scrollWheel(theEvent)
    }
    
    func contentsRightMouseDragged(theEvent: NSEvent) {
        moduleManager.rightMouseDragged(theEvent)
    }
    
    func contentsOtherMouseDragged(theEvent: NSEvent) {
        moduleManager.otherMouseDragged(theEvent)
    }
    
    func contentsMouseEntered(theEvent: NSEvent) {
        moduleManager.mouseEntered(theEvent)
    }
    
    func contentsMouseExited(theEvent: NSEvent) {
        moduleManager.mouseExited(theEvent)
    }
    
    func contentsKeyDown(theEvent: NSEvent) {
        moduleManager.keyDown(theEvent)
    }
    
    func contentsKeyUp(theEvent: NSEvent) {
        moduleManager.keyUp(theEvent)
    }
    
    #endif
}

#if os(iOS)
    
extension CorePlayer: InterruptionDelegate {
    
    public func interrupt(reason: InterruptionReason) {
        moduleManager.interrupt(reason)
    }
}
    
#endif
