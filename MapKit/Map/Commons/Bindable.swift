//  
//  Bindable.swift
//  Map
//
//  Created by Adonay on 21/05/24.
//

import Foundation

public class Bindable<T> {
    public typealias Listener = (T) -> ()
    
    // MARK: - Properties
    public var listeners: [Listener] = []
    
    // MARK: - Constructors
    public init(_ v: T) {
        value = v
    }
    
    // MARK: - Bind
    public func bind(_ listener: @escaping Listener) {
        self.listeners.append(listener)
    }
    
    // MARK: - Trigger
    public var value: T {
        didSet {
            DispatchQueue.main.async {
                self.listeners.forEach { $0(self.value) }
            }
        }
    }
}
