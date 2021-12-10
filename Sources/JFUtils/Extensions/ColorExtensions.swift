//
//  ColorExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

import SwiftUI

#if canImport(UIKit)

import UIKit

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension Color {
    /// The system's background color
    static let systemBackground = Color(UIColor.systemBackground)
}

#endif
