//
//  Event.swift
//  messenger
//
//  Created by Zarif Safiullin on 07/11/15.
//  Copyright © 2015 Zaph. All rights reserved.
//

/// An object that has some tear-down logic
public protocol Disposable {
    func dispose()
}


/// An event provides a mechanism for raising notifications, together with some
/// associated data. Multiple function handlers can be added, with each being invoked,
/// with the event data, when the event is raised.
public class Event<T> {
    
    public typealias EventHandler = T -> ()
    
    private var eventHandlers = [Invocable]()
    
    public init() {
    }
    
    /// Raises the event, invoking all handlers
    public func raise(data: T) {
        for handler in self.eventHandlers {
            handler.invoke(data)
        }
    }
    
    /// Adds the given handler
    public func addHandler<U: AnyObject>(target: U, handler: (U) -> EventHandler) -> Disposable {
        let wrapper = EventHandlerWrapper(target: target, handler: handler, event: self)
        eventHandlers.append(wrapper)
        return wrapper
    }
}

// MARK:- Private

// A protocol for a type that can be invoked
private protocol Invocable: class {
    func invoke(data: Any)
}

// takes a reference to a handler, as a class method, allowing
// a weak reference to the owning type.
// see: http://oleb.net/blog/2014/07/swift-instance-methods-curried-functions/
private class EventHandlerWrapper<T: AnyObject, U> : Invocable, Disposable {
    weak var target: T?
    let handler: T -> U -> ()
    let event: Event<U>
    
    init(target: T?, handler: T -> U -> (), event: Event<U>){
        self.target = target
        self.handler = handler
        self.event = event;
    }
    
    func invoke(data: Any) -> () {
        if let t = target {
            handler(t)(data as! U)
        }
    }
    
    func dispose() {
        event.eventHandlers = event.eventHandlers.filter { $0 !== self }
    }
}