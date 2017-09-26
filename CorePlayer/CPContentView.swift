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
    
    func contentsLayout(_ view: UXView)
    
    #if os(iOS)
    func contentsTouchesBegan(_ touches: Set<NSObject>, withEvent event: UIEvent?)
    func contentsTouchesMoved(_ touches: Set<NSObject>, withEvent event: UIEvent?)
    func contentsTouchesEnded(_ touches: Set<NSObject>, withEvent event: UIEvent?)
    func contentsTouchesCancelled(_ touches: Set<NSObject>!, withEvent event: UIEvent?)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        layoutManager?.contentsTouchesBegan(touches, withEvent: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        layoutManager?.contentsTouchesMoved(touches, withEvent: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        layoutManager?.contentsTouchesEnded(touches, withEvent: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        layoutManager?.contentsTouchesCancelled(touches, withEvent: event)
    }
    
    #else
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        layoutManager?.contentsLayout(self)
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        super.mouseDown(with: theEvent)
        layoutManager?.contentsMouseDown(theEvent: theEvent)
    }
    
    override func rightMouseDown(with theEvent: NSEvent) {
        super.rightMouseDown(with: theEvent)
        layoutManager?.contentsRightMouseDown(theEvent: theEvent)
    }
    
    override func otherMouseDown(with theEvent: NSEvent) {
        super.otherMouseDown(with: theEvent)
        layoutManager?.contentsOtherMouseDown(theEvent: theEvent)
    }
    
    override func mouseUp(with theEvent: NSEvent) {
        super.mouseUp(with: theEvent)
        layoutManager?.contentsMouseUp(theEvent: theEvent)
    }
    
    override func rightMouseUp(with theEvent: NSEvent) {
        super.rightMouseUp(with: theEvent)
        layoutManager?.contentsRightMouseUp(theEvent: theEvent)
    }
    
    override func otherMouseUp(with theEvent: NSEvent) {
        super.otherMouseUp(with: theEvent)
        layoutManager?.contentsOtherMouseUp(theEvent: theEvent)
    }
    
    override func mouseMoved(with theEvent: NSEvent) {
        super.mouseMoved(with: theEvent)
        layoutManager?.contentsMouseMoved(theEvent: theEvent)
    }
    
    override func mouseDragged(with theEvent: NSEvent) {
        super.mouseDragged(with: theEvent)
        layoutManager?.contentsMouseDragged(theEvent: theEvent)
    }
    
    override func scrollWheel(with theEvent: NSEvent) {
        super.scrollWheel(with: theEvent)
        layoutManager?.contentsScrollWheel(theEvent: theEvent)
    }
    
    override func rightMouseDragged(with theEvent: NSEvent) {
        super.rightMouseDragged(with: theEvent)
        layoutManager?.contentsRightMouseDragged(theEvent: theEvent)
    }
    
    override func otherMouseDragged(with theEvent: NSEvent) {
        super.otherMouseDragged(with: theEvent)
        layoutManager?.contentsOtherMouseDragged(theEvent: theEvent)
    }
    
    override func mouseEntered(with theEvent: NSEvent) {
        super.mouseEntered(with: theEvent)
        layoutManager?.contentsMouseEntered(theEvent: theEvent)
    }
    
    override func mouseExited(with theEvent: NSEvent) {
        super.mouseExited(with: theEvent)
        layoutManager?.contentsMouseExited(theEvent: theEvent)
    }
    
    override func keyDown(with theEvent: NSEvent) {
        super.keyDown(with: theEvent)
        layoutManager?.contentsKeyDown(theEvent: theEvent)
    }
    
    override func keyUp(with theEvent: NSEvent) {
        super.keyUp(with: theEvent)
        layoutManager?.contentsKeyUp(theEvent: theEvent)
    }
    #endif
}


