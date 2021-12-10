//
//  FormatterExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

import Foundation

public extension NumberFormatter {
    func string(from value: Double) -> String? {
        return self.string(from: NSNumber(value: value))
    }
    
    func string(from value: Int) -> String? {
        return self.string(from: NSNumber(value: value))
    }
    
    func string(from value: Float) -> String? {
        return self.string(from: NSNumber(value: value))
    }
}
