//
//  Observable.swift
//  messenger
//
//  Created by Zarif Safiullin on 07/11/15.
//  Copyright © 2015 Zaph. All rights reserved.
//

class Observable<T> {
    
    let didChange = Event<(T, T)>()
    private var value: T
    
    init(_ initialValue: T) {
        value = initialValue
    }
    
    func set(newValue: T) {
        let oldValue = value
        value = newValue
        didChange.raise(oldValue, newValue)
    }
    
    func get() -> T {
        return value
    }
}