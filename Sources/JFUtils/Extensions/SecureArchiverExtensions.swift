//
//  File.swift
//  
//
//  Created by Jonas Frey on 28.05.23.
//

import Foundation

public extension NSSecureUnarchiveFromDataTransformer {
    static var name: NSValueTransformerName { .init(rawValue: String(describing: Self.self)) }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            Self(),
            forName: Self.name
        )
    }
}
