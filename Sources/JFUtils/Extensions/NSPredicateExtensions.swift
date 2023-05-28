//
//  File.swift
//  
//
//  Created by Jonas Frey on 28.05.23.
//

import Foundation

public extension NSPredicate {
    /// Returns a negated version of this predicate
    func negated() -> NSPredicate {
        NSCompoundPredicate(type: .not, subpredicates: [self])
    }
}
