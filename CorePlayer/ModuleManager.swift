//
//  CPModuleManager.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

public class ModuleManager {

    public weak var moduleManager: ModuleManager?
    public weak var moduleDelegate: CorePlayerFeature?

    private var modules: Array<ModuleDelegate> = []
    
    public func deinitModule() {
        for module in modules {
            module.deinitModule()
        }
        
        modules.removeAll()
    }
    
    public func initModules(modules: Array<ModuleDelegate>) {
        registerModules(modules)
    }
    
    public func registerModules(newModules: Array<ModuleDelegate>) {

        newModules.forEach {
            var module = $0
            module.moduleDelegate = moduleDelegate
            module.moduleManager = self
            modules.append(module)
        }

        modules.sortInPlace(moduleSorter)
        
        for module in newModules.sort(moduleSorter) {
            module.initModule()
        }
    }

    private func moduleSorter (lhs: ModuleDelegate, rhs: ModuleDelegate) -> Bool {
        let lType = lhs.moduleType()
        let rType = rhs.moduleType()

        if lType != rType {
            return lType.rawValue > rType.rawValue
        } else if lType == .Feature {
            return false
        } else {
            let lModuelIndex = (lhs as! ModuleViewDelegate).moduelIndex
            let rModuelIndex = (rhs as! ModuleViewDelegate).moduelIndex
            return rModuelIndex > lModuelIndex
        }
    }

    private func unregisterModule(module: ModuleDelegate) {
        for (i, m) in modules.enumerate() {
            if (m as! AnyObject) === (module as! AnyObject) {
                modules.removeAtIndex(i)
                break
            }
        }
    }
}

extension ModuleManager: ModuleDelegate {

    public func willPlay() {
        modules.forEach { $0.willPlay() }
    }

    public func startPlay() {
        modules.forEach { $0.startPlay() }
    }

    public func cancelPlay() {
        modules.forEach { $0.cancelPlay() }
    }

    public func willPend() {
        modules.forEach { $0.willPend() }
    }

    public func endPend() {
        modules.forEach { $0.endPend() }
    }

    public func willPause() {
        modules.forEach { $0.willPause() }
    }

    public func endPause() {
        modules.forEach { $0.endPause() }
    }

    public func appResign() {
        modules.forEach { $0.appResign() }
    }

    public func appActive() {
        modules.forEach { $0.appActive() }
    }
    
    public func endPlayCode(state: CPState) {
        modules.forEach { $0.endPlayCode(state) }
    }

    public func endSection(cp: CPURL) {
        modules.forEach { $0.endSection(cp) }
    }

    public func startSection(cp: CPURL) {
        modules.forEach { $0.startSection(cp) }
    }

    public func willSection(cp: CPURL) {
        modules.forEach { $0.willSection(cp) }
    }

    public func airplayShift(on: Bool) {
        modules.forEach { $0.airplayShift(on) }
    }

    public func startSeek(time: NSTimeInterval) {
        modules.forEach { $0.startSeek(time) }
    }

    public func seekTo(time: NSTimeInterval) {
        modules.forEach { $0.seekTo(time) }
    }

    public func endSeek(time: NSTimeInterval, isEnd end:Bool) {
        modules.forEach { $0.endSeek(time, isEnd: end) }
    }

    public func durationAvailable(duration: NSTimeInterval) {
        modules.forEach { $0.durationAvailable(duration) }
    }

    public func played(duration: NSTimeInterval) {
        modules.forEach { $0.played(duration) }
    }

    public func playable(duration: NSTimeInterval) {
        modules.forEach { $0.playable(duration) }
    }

    public func error(err: CPError) {
        modules.forEach { $0.error(err) }
    }

    public func interrupt(reason: InterruptionReason) {
        modules.forEach { $0.interrupt(reason) }
    }

    public func presentationSize(size: CGSize) {
        modules.forEach { $0.presentationSize(size) }
    }

    ///called when frame changes
    public func layoutView() {
        modules.forEach {
            if let m = $0 as? ModuleViewDelegate {
                m.layoutView()
            }
        }
    }
}

#if os(iOS)
extension ModuleManager {
    
    public func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
    }
    
    public func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent?) {
    }
    
    public func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent?) {
    }
    
    public func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent?) {
    }

}
#endif

#if os(OSX)
extension ModuleManager {

    public func mouseDown(theEvent: NSEvent) {
    }
    
    public func rightMouseDown(theEvent: NSEvent) {
    }
    
    public func otherMouseDown(theEvent: NSEvent) {
    }
    
    public func mouseUp(theEvent: NSEvent) {
    }
    
    public func rightMouseUp(theEvent: NSEvent) {
    }
    
    public func otherMouseUp(theEvent: NSEvent) {
    }
    
    public func mouseMoved(theEvent: NSEvent) {
    }
    
    public func mouseDragged(theEvent: NSEvent) {
    }
    
    public func scrollWheel(theEvent: NSEvent) {
    }
    
    public func rightMouseDragged(theEvent: NSEvent) {
    }
    
    public func otherMouseDragged(theEvent: NSEvent) {
    }
    
    public func mouseEntered(theEvent: NSEvent) {
    }
    
    public func mouseExited(theEvent: NSEvent) {
    }
    
    public func keyDown(theEvent: NSEvent) {
    }
    
    public func keyUp(theEvent: NSEvent) {
    }

}
#endif
