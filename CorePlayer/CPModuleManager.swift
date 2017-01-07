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

open class CPModuleManager: NSObject, CPModuleDelegate {
    
    open var moduleID: Int = 0
    open weak var moduleManager: CPModuleManager?
    open weak var moduleDelegate: CorePlayerFeature?
    
    open func moduleType() -> ModuleType {
        return .feature
    }
    
    var moduleIndex: Int = 0
    open var modules: Array<CPModuleDelegate> = []
    
    open func initModule() {
        
    }
    
    open func deinitModule() {
        for module in modules {
            module.deinitModule()
        }
        
        modules.removeAll(keepingCapacity: true)
    }
    
    open func initModules(_ moduleClasses: Array<CPModuleDelegate.Type>) {
        addModules(moduleClasses)
    }
    
    open func addModules(_ moduleClasses: Array<CPModuleDelegate.Type>) {
        var newModules: Array<CPModuleDelegate> = []
        
        for mclass in moduleClasses {
            if let otype: NSObject.Type = mclass as? NSObject.Type {
                if let module: CPModuleDelegate = otype.init() as? CPModuleDelegate {
                    registerModule(module)
                    newModules.append(module)
                }
            }
        }
        
        sortModules(&modules)
        sortModules(&newModules)
        
        for module in newModules {
            module.initModule()
        }
    }
    
    func sortModules(_ modules: inout Array<CPModuleDelegate>) {
        modules.sort { objc1, objc2 in
            let type1 = (objc1.moduleType() as ModuleType).rawValue
            let type2 = (objc2.moduleType() as ModuleType).rawValue
            
            if type1 != type2 {
                return type1 > type2
                
            } else if type1 == ModuleType.feature.rawValue {
                return false
                
            } else {
                let viewIndex1 = (objc1 as! CPModuleViewDelegate).viewIndex()
                let viewIndex2 = (objc2 as! CPModuleViewDelegate).viewIndex()
                
                return viewIndex2 > viewIndex1
            }
        }
    }
    
    func registerModule(_ module: CPModuleDelegate) {
        module.moduleID = moduleIndex
        moduleIndex += 1
        module.moduleDelegate = moduleDelegate
        module.moduleManager = self
        modules.append(module)
    }
    
    open func delModules(_ moduleClasses: Array<CPModuleDelegate.Type>) {
        for mclass in moduleClasses {
            for (i, module) in modules.enumerated() {
                if module.isMember(of: mclass as AnyClass) {
                    if module.moduleType() == .view {
                        (module as! UXView).removeFromSuperview()
                    }
                    
                    module.deinitModule()
                    modules.remove(at: i)
                    break
                }
            }
        }
    }
    
    open func moduleWithClass(_ moduleClass: CPModuleDelegate.Type) -> CPModuleDelegate? {
        for module in modules {
            if module.isMember(of: moduleClass as AnyClass) {
                return module
            }
        }
        
        return nil
    }
    
    open func willPlay() {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.willPlay)) {
                module.willPlay!()
            }
        }
    }
    
    open func startPlay() {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.startPlay)) {
                module.startPlay!()
            }
        }
    }
    
    open func cancelPlay() {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.cancelPlay)) {
                module.cancelPlay!()
            }
        }
        
    }
    
    open func willPend() {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.willPend)) {
                module.willPend!()
            }
        }
    }
    
    open func endPend() {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.endPend)) {
                module.endPend!()
            }
        }
    }
    
    open func willPause() {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.willPause)) {
                module.willPause!()
            }
        }
    }
    
    open func endPause() {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.endPause)) {
                module.endPause!()
            }
        }
    }
    
    open func appResign() {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.appResign)) {
                module.appResign!()
            }
        }
    }
    
    open func appActive() {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.appActive)) {
                module.appActive!()
            }
        }
    }
    
    /**
    *called by Core Player when frame changes
    */
    open func layoutView() {
        for module in modules {
            if module.responds(to: #selector(CPModuleViewDelegate.layoutView)) {
                let vodule = module as! CPModuleViewDelegate
                vodule.layoutView()
            }
        }
    }
    
    open func endPlayCode(_ state: CPState) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.endPlayCode(_:))) {
                module.endPlayCode!(state)
            }
        }
    }
    open func endSection(_ cp: CPURL) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.endSection(_:))) {
                module.endSection!(cp)
            }
        }
    }
    
    open func startSection(_ cp: CPURL) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.startSection(_:))) {
                module.startSection!(cp)
            }
        }
    }
    
    open func willSection(_ cp: CPURL) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.willSection(_:))) {
                module.willSection!(cp)
            }
        }
    }
    
    open func airplayShift(_ on: Bool) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.airplayShift(_:))) {
                module.airplayShift!(on)
            }
        }
    }
    
    open func startSeek(_ time: TimeInterval) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.startSeek(_:))) {
                module.startSeek!(time)
            }
        }
    }
    
    open func seekTo(_ time: TimeInterval) {
        for module in modules {
            if module.responds(to: #selector(CorePlayerFeature.seekTo(_:))) {
                module.seekTo!(time)
            }
        }
    }
    
    open func endSeek(_ time: TimeInterval, isEnd end:Bool) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.endSeek(_:isEnd:))) {
                module.endSeek!(time, isEnd: end)
            }
        }
    }
    
    open func durationAvailable(_ duration: TimeInterval) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.durationAvailable(_:))) {
                module.durationAvailable!(duration)
            }
        }
    }
    
    open func played(_ duration: TimeInterval) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.played(_:))) {
                module.played!(duration)
            }
        }
    }
    
    open func playable(_ duration: TimeInterval) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.playable(_:))) {
                module.playable!(duration)
            }
        }
    }
    
    open func error(_ err: CPError) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.error(_:))) {
                module.error!(err)
            }
        }
    }
    
    open func interrupt(_ reason: InterruptionReason) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.interrupt(_:))) {
                module.interrupt!(reason)
            }
        }
    }
    
    open func presentationSize(_ size: CGSize) {
        for module in modules {
            if module.responds(to: #selector(CPModuleDelegate.presentationSize(_:))) {
                module.presentationSize!(size)
            }
        }
    }
    
    #if os(iOS)
    
    open func touchesBegan(_ touches: Set<NSObject>, withEvent event: UIEvent?) {
        
    }
    
    open func touchesEnded(_ touches: Set<NSObject>, withEvent event: UIEvent?) {
        
    }
    
    open func touchesMoved(_ touches: Set<NSObject>, withEvent event: UIEvent?) {
        
    }
    
    open func touchesCancelled(_ touches: Set<NSObject>!, withEvent event: UIEvent?) {
        
    }
    
    #else
    
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
    
    #endif
}
