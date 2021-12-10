//
//  SwiftUIExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

import SwiftUI

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension Binding {
    /// Creates a get-only Binding
    /// - Parameter get: The getter of the binding
    init(get: @escaping () -> Value) {
        self.init(get: get, set: { _ in })
    }
}
