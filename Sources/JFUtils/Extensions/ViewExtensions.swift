//
//  ViewExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

import SwiftUI

@available(macOS 10.15, *)
public extension View {
    /// Applies a workaround that prevents the list rows from staying selected
    func fixHighlighting() -> some View {
        // Workaround so that the list items don't stay selected after going back from the detail
        // FUTURE: Remove
        ZStack {
            Button("", action: {})
            self
        }
    }
    
    /// Conditionally hides the view
    /// - Parameter condition: The condition, whether to hide the view
    /// - Returns: A type-erased view, that may be hidden
    func hidden(condition: Bool) -> some View {
        if condition {
            return AnyView(self.hidden())
        } else {
            return AnyView(self)
        }
    }
    
    /// Creates a closure, returning self
    ///
    /// Used e.g. when providing a single View as label where the argument requires a closure, not a View
    func closure() -> (() -> Self) {
        return { self }
    }
}
