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
public extension Color {
    /// The system's background color
    static let systemBackground = Color(UIColor.systemBackground)
}

public extension UIColor {
    /// Returns the red, green, blue, and alpha components of this color
    var components: [CGFloat] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return [red, green, blue, alpha]
    }
}

#endif
