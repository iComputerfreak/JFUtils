//
//  SequenceExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

public extension Sequence {
    /// Returns the sequence, sorted by the given `KeyPath`
    /// - Returns: The sorted sequence
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}

public extension Sequence where Element: Hashable {
    /// Returns a sequence with all duplicates removed
    /// - Returns: The sequence with all duplicates removed, i.e. the resulting sequence will not have any elements that are equal to each other
    func duplicatesRemoved() -> [Element] {
        return Array(Set(self))
    }
    
    /// Returns a sequence with all duplicate elements removed
    /// To determine whether two elements are duplicates, the function compares the values at the given `KeyPath`
    /// - Parameter key: The `KeyPath` used to determine if two elements are equal
    /// - Returns: The sequence without any duplicates. The values at the given `KeyPath`s of any two elements from the return value are unequal
    func duplicatesRemoved<Value: Equatable>(key keyPath: KeyPath<Element, Value>) -> [Element] {
        return self.duplicatesRemoved { (element1, element2) -> Bool in
            element1[keyPath: keyPath] == element2[keyPath: keyPath]
        }
    }
    
    /// Returns a sequece with all duplicate elements removed
    /// To determine whether two elements are duplicates, the function uses the given closure.
    /// - Parameter isEqual: The closure used to determine if two elements are equal
    /// - Returns: The sequence without any duplicates. Executing the closure with any two elements from the return value will return false.
    func duplicatesRemoved(using isEqual: (Element, Element) -> Bool) -> [Element] {
        var uniques: [Element] = []
        for element in self {
            if !uniques.contains(where: { isEqual($0, element) }) {
                uniques.append(element)
            }
        }
        return uniques
    }
}
