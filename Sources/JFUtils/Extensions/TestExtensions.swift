//
//  File.swift
//  
//
//  Created by Jonas Frey on 28.05.23.
//

import XCTest

public extension XCUIElement {
    /// Taps at the coordinates of this element without checking for hittability.
    func forceTap() {
        coordinate(withNormalizedOffset: .init(dx: 0.5, dy: 0.5)).tap()
    }
    
    @discardableResult
    /// Waits for this element to exist or the given timeout to expire.
    /// - Parameter timeout: The timeout in seconds
    /// - Returns: The element
    /// - Throws: An XCTAssert error if the element does not exist after `timeout` seconds
    func wait(_ timeout: TimeInterval = 5) -> XCUIElement {
        if !exists {
            XCTAssertTrue(waitForExistence(timeout: timeout))
        }
        return self
    }
    
    /// Waits for this element to become hittable or the given timeout to expire.
    /// - Parameters:
    ///   - app: The `XCUIApplication`
    ///   - timeout: The timeout in seconds
    /// - Returns: This element
    func waitForHittable(_ app: XCUIApplication, timeout: TimeInterval = 5.0) -> XCUIElement {
        var waited: TimeInterval = 0
        while waited < timeout {
            guard !isHittable else {
                return self
            }
            // We should not actually go into background. We just use this function to wait
            XCTAssertFalse(app.wait(for: .runningBackground, timeout: 0.5))
            waited += 0.5
        }
        return self
    }
}

public extension XCUIElementQuery {
    /// Returns the first `XCUIElement` where the given key begins with the given prefix.
    func first(where key: String = "label", hasPrefix prefix: String) -> XCUIElement {
        matching(NSPredicate(format: "%K BEGINSWITH %@", key, prefix)).firstMatch
    }
}
