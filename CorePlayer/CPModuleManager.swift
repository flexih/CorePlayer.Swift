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

public class CPModuleManager: NSObject, CPModuleDelegate {
    
    public var moduleID: Int = 0
    public weak var moduleManager: CPModuleManager?
    public weak var moduleDelegate: CorePlayerFeature?
    
    public func moduleType() -> ModuleType {
        return .Feature
    }
    
    var moduleIndex: Int = 0
    var modules: Array<CPModuleDelegate> = []
    
    public func initModule() {
        
    }
    
    public func deinitModule() {
        for module in modules {
            module.deinitModule()
        }
        
        modules.removeAll(keepCapacity: true)
    }
    
    public func initModules(moduleClasses: Array<CPModuleDelegate.Type>) {
        addModules(moduleClasses)
    }
    
    public func addModules(moduleClasses: Array<CPModuleDelegate.Type>) {
        var newModules: Array<CPModuleDelegate> = []
        
        for mclass in moduleClasses {
            if let ctype: AnyObject.Type = mclass as AnyClass {
                let otype: NSObject.Type = ctype as! NSObject.Type
                let module: CPModuleDelegate? = otype.init() as? CPModuleDelegate
                if module != nil {
                    registerModule(module!)
                    newModules.append(module!)
                }
            }
        }
        
        sortModules(&modules)
        sortModules(&newModules)
        
        for module in newModules {
            module.initModule()
        }
    }
    
    func sortModules(inout modules: Array<CPModuleDelegate>) {
        modules.sortInPlace { (objc1, objc2) -> Bool in
            let type1 = (objc1.moduleType() as ModuleType).rawValue
            let type2 = (objc2.moduleType() as ModuleType).rawValue
            
            if type1 != type2 {
                return type1 > type2
                
            } else if type1 == ModuleType.Feature.rawValue {
                return false
                
            } else {
                let viewIndex1 = (objc1 as! CPModuleViewDelegate).viewIndex()
                let viewIndex2 = (objc2 as! CPModuleViewDelegate).viewIndex()
                
                return viewIndex2 > viewIndex1
            }
        }
    }
    
    func registerModule(module: CPModuleDelegate) {
        module.moduleID = moduleIndex++
        module.moduleDelegate = moduleDelegate
        module.moduleManager = self
        modules.append(module)
    }
    
    public func delModules(moduleClasses: Array<CPModuleDelegate.Type>) {
        for mclass in moduleClasses {
            for (i, module) in modules.enumerate() {
                if module.isMemberOfClass(mclass as AnyClass) {
                    if module.moduleType() == .View {
                        (module as! UXView).removeFromSuperview()
                    }
                    
                    module.deinitModule()
                    modules.removeAtIndex(i)
                    break
                }
            }
        }
    }
    
    public func moduleWithClass(moduleClass: CPModuleDelegate.Type) -> CPModuleDelegate? {
        for module in modules {
            if module.isMemberOfClass(moduleClass as AnyClass) {
                return module
            }
        }
        
        return nil
    }
    
    public func willPlay() {
        for module in modules {
            if module.respondsToSelector("willPlay") {
                module.willPlay!()
            }
        }
    }
    
    public func startPlay() {
        for module in modules {
            if module.respondsToSelector("startPlay") {
                module.startPlay!()
            }
        }
    }
    
    public func cancelPlay() {
        for module in modules {
            if module.respondsToSelector("cancelPlay") {
                module.cancelPlay!()
            }
        }
        
    }
    
    public func willPend() {
        for module in modules {
            if module.respondsToSelector("willPend") {
                module.willPend!()
            }
        }
    }
    
    public func endPend() {
        for module in modules {
            if module.respondsToSelector("endPend") {
                module.endPend!()
            }
        }
    }
    
    public func willPause() {
        for module in modules {
            if module.respondsToSelector("willPause") {
                module.willPause!()
            }
        }
    }
    
    public func endPause() {
        for module in modules {
            if module.respondsToSelector("endPause") {
                module.endPause!()
            }
        }
    }
    
    public func appResign() {
        for module in modules {
            if module.respondsToSelector("appResign") {
                module.appResign!()
            }
        }
    }
    
    public func appActive() {
        for module in modules {
            if module.respondsToSelector("appActive") {
                module.appActive!()
            }
        }
    }
    
    /**
    *called by Core Player when frame changes
    */
    public func layoutView() {
        for module in modules {
            if module.respondsToSelector("layoutView") {
                let vodule = module as! CPModuleViewDelegate
                vodule.layoutView()
            }
        }
    }
    
    public func endPlayCode(errCode: Int) {
        for module in modules {
            if module.respondsToSelector("endPlayCode:") {
                module.endPlayCode!(errCode)
            }
        }
    }
    public func endSection(cp: CPUrl) {
        for module in modules {
            if module.respondsToSelector("endSection:") {
                module.endSection!(cp)
            }
        }
    }
    
    public func startSection(cp: CPUrl) {
        for module in modules {
            if module.respondsToSelector("startSection:") {
                module.startSection!(cp)
            }
        }
    }
    
    public func willSection(cp: CPUrl) {
        for module in modules {
            if module.respondsToSelector("willSection:") {
                module.willSection!(cp)
            }
        }
    }
    
    public func airplayShift(on: Bool) {
        for module in modules {
            if module.respondsToSelector("airplayShift:") {
                module.airplayShift!(on)
            }
        }
    }
    
    public func startSeek(time: NSTimeInterval) {
        for module in modules {
            if module.respondsToSelector("startSeek:") {
                module.startSeek!(time)
            }
        }
    }
    
    public func seekTo(time: NSTimeInterval) {
        for module in modules {
            if module.respondsToSelector("seekTo:") {
                module.seekTo!(time)
            }
        }
    }
    
    public func endSeek(time: NSTimeInterval, isEnd end:Bool) {
        for module in modules {
            if module.respondsToSelector("endSeek:isEnd:") {
                module.endSeek!(time, isEnd: end)
            }
        }
    }
    
    public func durationAvailable(duration: NSTimeInterval) {
        for module in modules {
            if module.respondsToSelector("durationAvailable:") {
                module.durationAvailable!(duration)
            }
        }
    }
    
    public func played(duration: NSTimeInterval) {
        for module in modules {
            if module.respondsToSelector("played:") {
                module.played!(duration)
            }
        }
    }
    
    public func playable(duration: NSTimeInterval) {
        for module in modules {
            if module.respondsToSelector("playable:") {
                module.playable!(duration)
            }
        }
    }
    
    public func error(err: Int) {
        for module in modules {
            if module.respondsToSelector("error:") {
                module.error!(err)
            }
        }
    }
    
    public func interrupt(reason: InterruptionReason) {
        for module in modules {
            if module.respondsToSelector("interrupt:") {
                module.interrupt!(reason)
            }
        }
    }
    
    public func presentationSize(size: CGSize) {
        for module in modules {
            if module.respondsToSelector("presentationSize:") {
                module.presentationSize!(size)
            }
        }
    }
    
    #if os(iOS)
    
    func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        
    }
    
    func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent?) {
        
    }
    
    func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent?) {
        
    }
    
    func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent?) {
        
    }
    
    #else
    
    func mouseDown(theEvent: NSEvent) {
        
    }
    
    func rightMouseDown(theEvent: NSEvent) {
        
    }
    
    func otherMouseDown(theEvent: NSEvent) {
        
    }
    
    func mouseUp(theEvent: NSEvent) {
        
    }
    
    func rightMouseUp(theEvent: NSEvent) {
        
    }
    
    func otherMouseUp(theEvent: NSEvent) {
        
    }
    
    func mouseMoved(theEvent: NSEvent) {
        
    }
    
    func mouseDragged(theEvent: NSEvent) {
        
    }
    
    func scrollWheel(theEvent: NSEvent) {
        
    }
    
    func rightMouseDragged(theEvent: NSEvent) {
        
    }
    
    func otherMouseDragged(theEvent: NSEvent) {
        
    }
    
    func mouseEntered(theEvent: NSEvent) {
        
    }
    
    func mouseExited(theEvent: NSEvent) {
        
    }
    
    func keyDown(theEvent: NSEvent) {
        
    }
    
    func keyUp(theEvent: NSEvent) {
        
    }
    
    #endif
}