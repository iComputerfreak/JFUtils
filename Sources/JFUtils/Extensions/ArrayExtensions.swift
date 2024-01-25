//
//  ArrayExtensions.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

public extension Array {
    
    /// Returns `k` random elements, keeping drawn elements in the collection
    /// - Parameter k: The number of elements to return
    /// - Returns: The specified number of random elements from the collection
    func randomElements(_ k: Int) -> Self {
        var elements: Self = []
        for _ in 0..<k {
            if let element = self.randomElement() {
                elements.append(element)
            }
        }
        return elements
    }
    
    /// Sorts the array by the given `KeyPath`
    /// - Parameter keyPath: The key path to use as a sorting comparator
    mutating func sort<T: Comparable>(by keyPath: KeyPath<Element, T>) {
        self.sort { a, b in
            a[keyPath: keyPath] < b [keyPath: keyPath]
        }
    }
    
    /// Sorts the array by the given `KeyPath`s
    /// - Parameter keyPaths: The list of key paths to use for comparison
    mutating func sort<T: Comparable>(by keyPaths: [KeyPath<Element, T>]) {
        self.sort { a, b in
            for keyPath in keyPaths {
                // We return as soon as one keyPath mismatches
                if a[keyPath: keyPath] != b[keyPath: keyPath] {
                    return a[keyPath: keyPath] < b[keyPath: keyPath]
                }
            }
            // If all keyPaths match
            return true
        }
    }
}

public extension Array where Element == String {
    func joined(separator: Character) -> String {
        self.joined(separator: String(separator))
    }
}

public extension Array {
    mutating func removeAll<T: Equatable>(where keyPath: KeyPath<Element, T>, equals other: T) {
        self.removeAll { element in
            element[keyPath: keyPath] == other
        }
    }
}

