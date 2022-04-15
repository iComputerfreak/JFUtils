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
}

extension Array where Element == String {
    func joined(separator: Character) -> String {
        self.joined(separator: String(separator))
    }
}

