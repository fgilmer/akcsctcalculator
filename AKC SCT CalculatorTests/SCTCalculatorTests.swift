//
//  SCTCalculatorTests.swift
//  AKC SCT Calculator
//
//  Created by FRANK GILMER on 3/13/25.
//

import XCTest
@testable import AKC_SCT_Calculator

class SCTCalculatorTests: XCTestCase {
    var calculator: SCTCalculator!
    
    override func setUp() {
        super.setUp()
        calculator = SCTCalculator()
    }
    
    // MARK: - convertToYards(_:) Tests
    func testConvertToYards_AboveThreshold() {
        XCTAssertEqual(calculator.convertToYards(300), 100)
        XCTAssertEqual(calculator.convertToYards(600), 200)
    }
    
    func testConvertToYards_BelowThreshold() {
        XCTAssertEqual(calculator.convertToYards(150), 150)
        XCTAssertEqual(calculator.convertToYards(220), 220)
    }
    
    // MARK: - calculateYardsPerSecond(_:) Tests
    func testCalculateYardsPerSecond_ValidInputs() {
        let computedYards = [100, 120, 140, 160, 180]
        let result = calculator.calculateYardsPerSecond(level: .open, classType: .standard, computedYards: computedYards)
        XCTAssertEqual(result.count, 5)
    }
    
    func testCalculateYardsPerSecond_ArrayLengthMismatch() {
        let computedYards = [100, 120] // Mismatch with expected length (5)
        let result = calculator.calculateYardsPerSecond(level: .open, classType: .standard, computedYards: computedYards)
        XCTAssertEqual(result, [0, 0]) // Expect zeroed out array
    }
    
    // MARK: - getBaseYPS(_:) Tests
    func testGetBaseYPS_ValidLevelsAndClasses() {
        let expectedStandard = [2.50, 2.70, 2.85, 3.10, 2.90]
        let expectedJumpers = [3.05, 3.25, 3.50, 3.75, 3.55]

        XCTAssertEqual(calculator.getBaseYPS(level: .excellentMasters, classType: .standard), expectedStandard)
        XCTAssertEqual(calculator.getBaseYPS(level: .excellentMasters, classType: .jumpers), expectedJumpers)
    }

    func testGetBaseYPS_InvalidLevel_ReturnsDefault() {
        let result = calculator.getBaseYPS(level: Level(rawValue: "InvalidLevel"), classType: .standard)
        XCTAssertEqual(result, [0, 0, 0, 0, 0])
    }

    func testGetBaseYPS_InvalidClassType_ReturnsDefault() {
        let result = calculator.getBaseYPS(level: .novice, classType: ClassType(rawValue: "InvalidClass"))
        XCTAssertEqual(result, [0, 0, 0, 0, 0])
    }

    func testGetBaseYPS_InvalidInputs() {
        let yps = calculator.getBaseYPS(level: .excellentMasters, classType: .jumpers)
        XCTAssertEqual(yps.count, 5) // Ensures 5 elements always returned
    }
    
    // MARK: - calculateComputedYards(_:) Tests
    func testCalculateComputedYards_ExcellentMasters_ValidInputs() {
        let result = calculator.calculateComputedYards(level: .excellentMasters, smallDogMeasurement: 300, bigDogMeasurement: 600)
        XCTAssertEqual(result, [100, 100, 150, 200, 200])
    }
    
    func testCalculateComputedYards_OpenNovice_ValidInputs() {
        let result = calculator.calculateComputedYards(level: .open, smallDogMeasurement: nil, bigDogMeasurement: 600)
        XCTAssertEqual(result, [200, 200, 200, 200, 200])
    }
    
    func testCalculateComputedYards_MissingBigDogMeasurement() {
        let result = calculator.calculateComputedYards(level: .novice, smallDogMeasurement: 300, bigDogMeasurement: nil)
        XCTAssertEqual(result, [0, 0, 0, 0, 0])
    }
    
    func testCalculateComputedYards_MissingSmallDogMeasurementForExcellentMasters() {
        let result = calculator.calculateComputedYards(level: .excellentMasters, smallDogMeasurement: nil, bigDogMeasurement: 600)
        XCTAssertEqual(result, [0, 0, 0, 0, 0])
    }
    
    // MARK: - checkComputedYards(_:) Tests
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

