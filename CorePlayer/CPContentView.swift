//
//  CPContentView.swift
//  CorePlayer
//
//  Created by flexih on 4/21/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

protocol CPContentLayoutManager: NSObjectProtocol {
    
    func contentsLayout(view: UXView)
    
    #if os(iOS)
    func contentsTouchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?)
    func contentsTouchesMoved(touches: Set<NSObject>, withEvent event: UIEvent?)
    func contentsTouchesEnded(touches: Set<NSObject>, withEvent event: UIEvent?)
    func contentsTouchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent?)
    #else
    func contentsMouseDown(theEvent: NSEvent)
    func contentsRightMouseDown(theEvent: NSEvent)
    func contentsOtherMouseDown(theEvent: NSEvent)
    func contentsMouseUp(theEvent: NSEvent)
    func contentsRightMouseUp(theEvent: NSEvent)
    func contentsOtherMouseUp(theEvent: NSEvent)
    func contentsMouseMoved(theEvent: NSEvent)
    func contentsMouseDragged(theEvent: NSEvent)
    func contentsScrollWheel(theEvent: NSEvent)
    func contentsRightMouseDragged(theEvent: NSEvent)
    func contentsOtherMouseDragged(theEvent: NSEvent)
    func contentsMouseEntered(theEvent: NSEvent)
    func contentsMouseExited(theEvent: NSEvent)
    func contentsKeyDown(theEvent: NSEvent)
    func contentsKeyUp(theEvent: NSEvent)
    #endif
}

class CPContentView: UXView {
    
    weak var layoutManager: CPContentLayoutManager?
    
    #if os(iOS)
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutManager?.contentsLayout(self)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        layoutManager?.contentsTouchesBegan(touches, withEvent: event)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        layoutManager?.contentsTouchesMoved(touches, withEvent: event)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        layoutManager?.contentsTouchesEnded(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        layoutManager?.contentsTouchesCancelled(touches, withEvent: event)
    }
    
    #else
    override func resizeSubviewsWithOldSize(oldSize: NSSize) {
        super.resizeSubviewsWithOldSize(oldSize)
        layoutManager?.contentsLayout(self)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        layoutManager?.contentsMouseDown(theEvent)
    }
    
    override func rightMouseDown(theEvent: NSEvent) {
        super.rightMouseDown(theEvent)
        layoutManager?.contentsRightMouseDown(theEvent)
    }
    
    override func otherMouseDown(theEvent: NSEvent) {
        super.otherMouseDown(theEvent)
        layoutManager?.contentsOtherMouseDown(theEvent)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        super.mouseUp(theEvent)
        layoutManager?.contentsMouseUp(theEvent)
    }
    
    override func rightMouseUp(theEvent: NSEvent) {
        super.rightMouseUp(theEvent)
        layoutManager?.contentsRightMouseUp(theEvent)
    }
    
    override func otherMouseUp(theEvent: NSEvent) {
        super.otherMouseUp(theEvent)
        layoutManager?.contentsOtherMouseUp(theEvent)
    }
    
    override func mouseMoved(theEvent: NSEvent) {
        super.mouseMoved(theEvent)
        layoutManager?.contentsMouseMoved(theEvent)
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        super.mouseDragged(theEvent)
        layoutManager?.contentsMouseDragged(theEvent)
    }
    
    override func scrollWheel(theEvent: NSEvent) {
        super.scrollWheel(theEvent)
        layoutManager?.contentsScrollWheel(theEvent)
    }
    
    override func rightMouseDragged(theEvent: NSEvent) {
        super.rightMouseDragged(theEvent)
        layoutManager?.contentsRightMouseDragged(theEvent)
    }
    
    override func otherMouseDragged(theEvent: NSEvent) {
        super.otherMouseDragged(theEvent)
        layoutManager?.contentsOtherMouseDragged(theEvent)
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        super.mouseEntered(theEvent)
        layoutManager?.contentsMouseEntered(theEvent)
    }
    
    override func mouseExited(theEvent: NSEvent) {
        super.mouseExited(theEvent)
        layoutManager?.contentsMouseExited(theEvent)
    }
    
    override func keyDown(theEvent: NSEvent) {
        super.keyDown(theEvent)
        layoutManager?.contentsKeyDown(theEvent)
    }
    
    override func keyUp(theEvent: NSEvent) {
        super.keyUp(theEvent)
        layoutManager?.contentsKeyUp(theEvent)
    }
    #endif
}


