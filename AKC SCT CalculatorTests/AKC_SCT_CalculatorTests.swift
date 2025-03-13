//
//  AKC_SCT_CalculatorTests.swift
//  AKC SCT CalculatorTests
//
//  Created by FRANK GILMER on 3/11/25.
//

import XCTest
@testable import AKC_SCT_Calculator

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
        XCTAssertEqual(calculator.calculateComputedYards(level: .excellentMasters, smallDogMeasurement: nil, bigDogMeasurement: 600), [0, 0, 0, 0, 0])
        XCTAssertEqual(calculator.calculateComputedYards(level: .excellentMasters, smallDogMeasurement: nil, bigDogMeasurement: nil), [0, 0, 0, 0, 0])
        XCTAssertEqual(calculator.calculateComputedYards(level: .excellentMasters, smallDogMeasurement: 300, bigDogMeasurement: 600), [100, 100, 150, 200, 200])
        XCTAssertEqual(calculator.calculateComputedYards(level: .open, smallDogMeasurement: nil, bigDogMeasurement: 600), [200, 200, 200, 200, 200])
        XCTAssertEqual(calculator.calculateComputedYards(level: .novice, smallDogMeasurement: nil, bigDogMeasurement: 300), [100, 100, 100, 100, 100])
    }
    
    func testCalculateYardsPerSecond() {
        XCTAssertEqual(calculator.calculateYardsPerSecond(level: .excellentMasters, classType: .standard, computedYards: [179, 179, 185, 190, 190]), [72, 66, 65, 61, 66])
        XCTAssertEqual(calculator.calculateYardsPerSecond(level: .open, classType: .standard, computedYards: [190, 190, 190, 190, 190]), [89, 86, 81, 77, 80])
        XCTAssertEqual(calculator.calculateYardsPerSecond(level: .novice, classType: .standard, computedYards: [190, 190, 190, 190, 190]), [108, 100, 93, 89, 91])
        XCTAssertEqual(calculator.calculateYardsPerSecond(level: .excellentMasters, classType: .jumpers, computedYards: [168, 168, 175, 182, 182]), [55, 52, 50, 49, 51])
    }
    
    func testCheckComputedYards_StandardClass_ExceedsLimits() {
        let computedYards = [0, 190, 0, 200, 0] // Exceeds both small (186) & large (195)
        let warnings = calculator.checkComputedYards(level: .excellentMasters, classType: .standard, computedYards: computedYards)
        
        XCTAssertEqual(warnings.count, 2)
        XCTAssertTrue(warnings.contains("Small Dog Measurement max is 186"))
        XCTAssertTrue(warnings.contains("Large Dog Measurement max is 195"))
    }

    func testCheckComputedYards_JumpersClass_ExceedsLimits() {
        let computedYards = [0, 180, 0, 190, 0] // Exceeds both small (175) & large (183)
        let warnings = calculator.checkComputedYards(level: .excellentMasters, classType: .jumpers, computedYards: computedYards)
        
        XCTAssertEqual(warnings.count, 2)
        XCTAssertTrue(warnings.contains("Small Dog Measurement max is 175"))
        XCTAssertTrue(warnings.contains("Large Dog Measurement max is 183"))
    }

    func testCheckComputedYards_ValidMeasurements_NoWarnings() {
        let computedYards = [0, 160, 0, 180, 0] // Below limits
        let warnings = calculator.checkComputedYards(level: .excellentMasters, classType: .standard, computedYards: computedYards)
        
        XCTAssertTrue(warnings.isEmpty)
    }

    func testCheckComputedYards_InsufficientComputedYards_NoCrash() {
        let computedYards = [0, 170] // Less than 4 elements
        let warnings = calculator.checkComputedYards(level: .excellentMasters, classType: .standard, computedYards: computedYards)
        
        XCTAssertTrue(warnings.isEmpty)
    }

    func testCheckComputedYards_EmptyComputedYards_NoCrash() {
        let computedYards: [Int] = []
        let warnings = calculator.checkComputedYards(level: .excellentMasters, classType: .standard, computedYards: computedYards)
        
        XCTAssertTrue(warnings.isEmpty)
    }
}
