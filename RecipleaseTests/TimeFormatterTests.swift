//
//  TimeFormatterTests.swift
//  RecipleaseTests
//
//  Created by Lilian Grasset on 24/07/2023.
//

import XCTest
@testable import Reciplease

final class TimeFormatterTests: XCTestCase {
    
    func testLessThanAnHour() {
        let timeInMinutes = 25
        
        let formatted = TimeFormatter.format(timeInMinutes)
        
        XCTAssertEqual(formatted, "25m")
    }

    func testExactlyTwoHours() {
        let timeInMinutes = 120
        
        let formatted = TimeFormatter.format(timeInMinutes)
        
        XCTAssertEqual(formatted, "2h")
    }
    
    func test3Hours26minutes() {
        let timeInMinutes = 206
        
        let formatted = TimeFormatter.format(timeInMinutes)
        
        XCTAssertEqual(formatted, "3h26")
    }
}
