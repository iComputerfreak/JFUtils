//
//  SequenceExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

public extension Sequence {
    @inlinable
    func sorted<Value>(
        on transform: (Element) throws -> Value,
        by areInIncreasingOrder: (Value, Value) throws -> Bool,
        isExpensiveTransform: Bool = false
    ) rethrows -> [Element] {
        guard isExpensiveTransform else {
            return try sorted {
                try areInIncreasingOrder(transform($0), transform($1))
            }
        }
        var pairs = try map {
            try (element: $0, value: transform($0))
        }
        try pairs.sort {
            try areInIncreasingOrder($0.value, $1.value)
        }
        
        return pairs.map { $0.element }
    }
    
    @inlinable
    func min<Value>(
        on transform: (Element) throws -> Value,
        by areInIncreasingOrder: (Value, Value) throws -> Bool,
        isExpensiveTransform: Bool = false
    ) rethrows -> Element? {
        guard isExpensiveTransform else {
            return try self.min {
                try areInIncreasingOrder(transform($0), transform($1))
            }
        }
        let pairs = try map {
            try (element: $0, value: transform($0))
        }
        return try pairs.min {
            try areInIncreasingOrder($0.value, $1.value)
        }?.element
    }
    
    @inlinable
    func max<Value>(
        on transform: (Element) throws -> Value,
        by areInIncreasingOrder: (Value, Value) throws -> Bool,
        isExpensiveTransform: Bool = false
    ) rethrows -> Element? {
        guard isExpensiveTransform else {
            return try self.max {
                try areInIncreasingOrder(transform($0), transform($1))
            }
        }
        let pairs = try map {
            try (element: $0, value: transform($0))
        }
        return try pairs.max {
            try areInIncreasingOrder($0.value, $1.value)
        }?.element
    }
}

public extension MutableCollection where Self: RandomAccessCollection {
    @inlinable
    mutating func sort<Value>(
        on transform: (Element) throws -> Value,
        by areInIncreasingOrder: (Value, Value) throws -> Bool,
        isExpensiveTransform: Bool = false
    ) rethrows {
        guard isExpensiveTransform else {
            return try sort {
                try areInIncreasingOrder(transform($0), transform($1))
            }
        }
        var pairs = try map {
            try (element: $0, value: transform($0))
        }
        try pairs.sort {
            try areInIncreasingOrder($0.value, $1.value)
        }
        
        for (i, j) in zip(indices, pairs.indices) {
            self[i] = pairs[j].element
        }
    }
}


public extension Sequence where Element: Hashable {
    /// Returns a sequence with all duplicates removed
    /// - Returns: The sequence with all duplicates removed, i.e. the resulting sequence will not have any elements that are equal to each other
    func removingDuplicates() -> [Element] {
        return Array(Set(self))
    }
    
    /// Removes all duplicate elements from this sequence
    mutating func removeDuplicates() {
        self = self.removingDuplicates() as! Self
    }
}

public extension Sequence {
    /// Returns a sequence with all duplicate elements removed, keeping the first instance of each duplicates pair
    /// To determine whether two elements are duplicates, the function compares the values at the given `KeyPath`
    /// - Parameter key: The `KeyPath` used to determine if two elements are equal
    /// - Returns: The sequence without any duplicates. The values at the given `KeyPath`s of any two elements from the return value are inequal
    func removingDuplicates<Value: Equatable>(key keyPath: KeyPath<Element, Value>) -> [Element] {
        return self.removingDuplicates { (element1, element2) -> Bool in
            element1[keyPath: keyPath] == element2[keyPath: keyPath]
        }
    }
    
    /// Removes all duplicate elements from this sequence, keeping the first instance of each duplicates pair
    /// To determine whether two elements are duplicates, the function compares the values at the given `KeyPath`
    /// - Parameter key: The `KeyPath` used to determine if two elements are equal
    /// - Returns: The sequence without any duplicates. The values at the given `KeyPath`s of any two elements from the return value are inequal
    mutating func removeDuplicates<Value: Equatable>(key keyPath: KeyPath<Element, Value>) {
        self = self.removingDuplicates(key: keyPath) as! Self
    }
    
    /// Returns a sequece with all duplicate elements removed, keeping the first instance of each duplicates pair
    /// To determine whether two elements are duplicates, the function uses the given closure.
    /// - Parameter isEqual: The closure used to determine if two elements are equal
    /// - Returns: The sequence without any duplicates. Executing the `isEqual` closure with any two elements from the return value will return false.
    func removingDuplicates(using isEqual: (Element, Element) -> Bool) -> [Element] {
        var uniques: [Element] = []
        for element in self {
            if !uniques.contains(where: { isEqual($0, element) }) {
                uniques.append(element)
            }
        }
        return uniques
    }
    
    /// Removes all duplicate elements from this sequence, keeping the first instance of each duplicates pair
    /// To determine whether two elements are duplicates, the function uses the given closure.
    /// - Parameter isEqual: The closure used to determine if two elements are equal
    /// - Returns: The sequence without any duplicates. Executing the `isEqual` closure with any two elements from the return value will return false.
    mutating func removeDuplicates(using isEqual: (Element, Element) -> Bool) {
        self = self.removingDuplicates(using: isEqual) as! Self
    }
}

public extension Sequence {
    func first<T: Equatable>(where keyPath: KeyPath<Element, T>, equals other: T) -> Element? {
        return first { element in
            element[keyPath: keyPath] == other
        }
    }
}

public extension Collection {
    func firstIndex<T: Equatable>(where keyPath: KeyPath<Element, T>, equals other: T) -> Index? {
        return firstIndex { element in
            element[keyPath: keyPath] == other
        }
    }
}

public extension Array {
    func last<T: Equatable>(where keyPath: KeyPath<Element, T>, equals other: T) -> Element? {
        return last { element in
            element[keyPath: keyPath] == other
        }
    }

    func lastIndex<T: Equatable>(where keyPath: KeyPath<Element, T>, equals other: T) -> Index? {
        return lastIndex { element in
            element[keyPath: keyPath] == other
        }
    }
}

// MARK: - filter
public extension Sequence {
    mutating func filter(where keyPath: KeyPath<Element, Bool>) -> [Self.Element] {
        self.filter(where: keyPath, isEqualTo: true)
    }
    
    mutating func filter<T: Equatable>(where keyPath: KeyPath<Element, T>, isEqualTo other: T) -> [Self.Element] {
        self.filter(by: keyPath, where: { $0 == other})
    }
    
    mutating func filter<T: Equatable>(where keyPath: KeyPath<Element, T>, isNotEqualTo other: T) -> [Self.Element] {
        self.filter(by: keyPath, where: { $0 != other})
    }
    
    mutating func filter<T>(by keyPath: KeyPath<Element, T>, where isIncluded: (T) -> Bool) -> [Self.Element] {
        self.filter { element in
            isIncluded(element[keyPath: keyPath])
        }
    }
}
