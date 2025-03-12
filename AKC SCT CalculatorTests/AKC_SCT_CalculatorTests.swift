//
//  AKC_SCT_CalculatorTests.swift
//  AKC SCT CalculatorTests
//
//  Created by FRANK GILMER on 3/11/25.
//

import XCTest
@testable import AKC_SCT_Calculator  // Replace 'YourAppName' with your actual project name

class AKC_SCT_CalculatorTests: XCTestCase {
    
    func testConvertToYards() {
        let view = ContentView()
        XCTAssertEqual(view.convertToYards(300), 100)
        XCTAssertEqual(view.convertToYards(150), 150)
        XCTAssertEqual(view.convertToYards(0), 0)
    }
}
