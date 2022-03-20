//
//  ComparableExtensions.swift
//  
//
//  Created by Jonas Frey on 20.03.22.
//

import Foundation

public extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        if self < range.lowerBound {
            return range.lowerBound
        } else if self > range.upperBound {
            return range.upperBound
        }
        return self
    }
}
