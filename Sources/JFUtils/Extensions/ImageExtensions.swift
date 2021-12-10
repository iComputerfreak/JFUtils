//
//  File.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

import SwiftUI

#if canImport(UIKit)

import UIKit

public extension Image {
    /// Creates an Image View using the given image, or the default image, if the first didn't exist.
    /// - Parameter name: The image to use for the view
    /// - Parameter defaultImage: The fallback image name, to use when the image `name` didn't exist
    init(_ name: String, defaultImage: String) {
        if let img = UIImage(named: name) {
            self.init(uiImage: img)
        } else {
            self.init(defaultImage)
        }
    }
    
    /// Creates an Image View using the given image, or a default icon, if the first didn't exist.
    /// - Parameter name: The image to use for the view
    /// - Parameter defaultImage: The fallback icon name, to use when the image `name` didn't exist
    init(_ name: String, defaultSystemImage: String) {
        if let img = UIImage(named: name) {
            self.init(uiImage: img)
        } else {
            self.init(systemName: defaultSystemImage)
        }
    }
    
    /// Creates an Image View using the given image, or a default image, if the first didn't exist.
    /// - Parameter name: The image to use for the view
    /// - Parameter defaultImage: The fallback image name, to use when the image `name` didn't exist
    init(uiImage: UIImage?, defaultImage: String) {
        if let image = uiImage {
            self.init(uiImage: image)
        } else {
            self.init(defaultImage)
        }
    }
    
    /// Creates an Image View using the given image, or a default icon, if the first didn't exist.
    /// - Parameter name: The image to use for the view
    /// - Parameter defaultImage: The fallback icon name, to use when the image `name` didn't exist
    init(uiImage: UIImage?, defaultSystemImage: String) {
        if let image = uiImage {
            self.init(uiImage: image)
        } else {
            self.init(systemName: defaultSystemImage)
        }
    }
}

#endif
