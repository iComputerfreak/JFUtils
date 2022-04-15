//
//  RangeExtensions.swift
//  
//
//  Created by Jonas Frey on 20.03.22.
//

import Foundation

public extension Range {
    /// Returns the intersection of this range with the other range
    /// - Parameter other: The other range
    /// - Returns: The intersection range, or an empty range if the two ranges do not overlap
    func intersection(_ other: Range<Bound>) -> Range<Bound> {
        // If the other range is completely before or after this range, return an empty result
        // |--------|               <- other
        //             |-------|    <- self
        guard self.overlaps(other) else {
            // Return an empty range (no intersection)
            return self.lowerBound..<self.lowerBound
        }
        // If the other range lies completely in this range
        //    |-----|               <- other
        // |-----------|            <- self
        if other.lowerBound >= self.lowerBound && other.upperBound <= self.upperBound {
            return other
        }
        // If this range lies completely in the other range
        // |-----------|            <- other
        //    |-----|               <- self
        if self.lowerBound >= other.lowerBound && self.upperBound <= other.upperBound {
            return self
        }
        // If the other range overlaps in the beginning
        // |--------|               <- other
        //       |-----------|      <- self
        if other.upperBound <= self.upperBound {
            return self.lowerBound..<other.upperBound
        }
        // If the other range overlaps in the beginning
        //       |-----------|      <- other
        // |--------|               <- self
        if other.lowerBound >= self.lowerBound {
            return other.lowerBound..<self.upperBound
        }
        // Some edgecase, we did not cover
        fatalError("Uncovered edgecase.")
    }
}
