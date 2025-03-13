//
//  AKC_SCT_CalculatorTests.swift
//  AKC SCT CalculatorTests
//
//  Created by FRANK GILMER on 3/11/25.
//

import XCTest
@testable import AKC_SCT_Calculator  // Replace 'YourAppName' with your actual project name

class AKC_SCT_CalculatorTests: XCTestCase {
    var calculator: SCTCalculator!
    
    override func setUp() {
        super.setUp()
        calculator = SCTCalculator()
    }
    
    func testConvertToYards() {
        XCTAssertEqual(calculator.convertToYards(300), 100)
        XCTAssertEqual(calculator.convertToYards(150), 150)
        XCTAssertEqual(calculator.convertToYards(0), 0)
    }
    
    func testCalculateComputedYards() {
        XCTAssertEqual(calculator.calculateComputedYards(level: "Excellent/Masters", smallDogMeasurement: nil, bigDogMeasurement: 600), [0, 0, 0, 0, 0])
        XCTAssertEqual(calculator.calculateComputedYards(level: "Excellent/Masters", smallDogMeasurement: nil, bigDogMeasurement: nil), [0, 0, 0, 0, 0])
        XCTAssertEqual(calculator.calculateComputedYards(level: "Excellent/Masters", smallDogMeasurement: 300, bigDogMeasurement: 600), [100, 100, 150, 200, 200])
        XCTAssertEqual(calculator.calculateComputedYards(level: "Open", smallDogMeasurement: nil, bigDogMeasurement: 600), [200, 200, 200, 200, 200])
        XCTAssertEqual(calculator.calculateComputedYards(level: "Novice", smallDogMeasurement: nil, bigDogMeasurement: 300), [100, 100, 100, 100, 100])
    }
    
    func testCalculateYardsPerSecond() {
        XCTAssertEqual(calculator.calculateYardsPerSecond(level: "Excellent/Masters", classType: "Standard", computedYards: [179, 179, 185, 190, 190]), [72, 66, 65, 61, 66])
        XCTAssertEqual(calculator.calculateYardsPerSecond(level: "Open", classType: "Standard", computedYards: [190, 190, 190, 190, 190]), [89, 86, 81, 77, 80])
        XCTAssertEqual(calculator.calculateYardsPerSecond(level: "Novice", classType: "Standard", computedYards: [190, 190, 190, 190, 190]), [108, 100, 93, 89, 91])
        XCTAssertEqual(calculator.calculateYardsPerSecond(level: "Excellent/Masters", classType: "Jumpers with Weaves", computedYards: [168, 168, 175, 182, 182]), [55, 52, 50, 49, 51])
    }
}
