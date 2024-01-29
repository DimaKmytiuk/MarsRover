//
//  Binding+Extension.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 29.01.2024.
//

import SwiftUI
import Combine

extension Binding {
    static func bindTo<T: AnyObject>(_ value: T, keyPath: ReferenceWritableKeyPath<T, Value>) -> Binding<Value> {
        return Binding(
            get: { value[keyPath: keyPath] },
            set: { value[keyPath: keyPath] = $0 })
    }
}

extension Binding {
    var value: Value { self.wrappedValue }
}
