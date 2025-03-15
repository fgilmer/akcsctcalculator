//
//  SCTCalculatorTests.swift
//  Agility SCT Calculator
//
//  Created by FRANK GILMER on 3/13/25.
//

import XCTest
@testable import Agility_SCT_Calculator

class SCTCalculatorTests: XCTestCase {
    var calculator: SCTCalculator!

    override func setUp() {
        super.setUp()
        calculator = SCTCalculator()
    }

    // MARK: - convertToYards() Tests
    func testConvertToYards_AboveThreshold() {
        XCTAssertEqual(calculator.convertToYards(300), 100)
    }

    func testConvertToYards_BelowThreshold() {
        XCTAssertEqual(calculator.convertToYards(200), 200)
    }

    // MARK: - calculateYardsPerSecond() Tests
    func testCalculateYardsPerSecond_ValidInputs() {
        let computedYards = [200, 220, 250, 275, 260]
        let result = calculator.calculateYardsPerSecond(level: .excellentMasters, classType: .standard, computedYards: computedYards)
        XCTAssertEqual(result.count, 5)
    }

    func testCalculateYardsPerSecond_InvalidLength() {
        let result = calculator.calculateYardsPerSecond(level: .novice, classType: .jumpers, computedYards: [100, 200])
        XCTAssertEqual(result, [0, 0])
    }

    // MARK: - getBaseYPS() Tests
    func testGetBaseYPS_ValidInputs() {
        let result = calculator.getBaseYPS(level: .excellentMasters, classType: .standard)
        XCTAssertEqual(result, [2.50, 2.70, 2.85, 3.10, 2.90])
    }

    func testGetBaseYPS_InvalidInputs() {
        let result = calculator.getBaseYPS(level: nil, classType: nil)
        XCTAssertEqual(result, [0, 0, 0, 0, 0])
    }

    // MARK: - calculateComputedYards() Tests
    func testCalculateComputedYards_ExcellentMasters_Valid() {
        let result = calculator.calculateComputedYards(level: .excellentMasters, smallDogMeasurement: 300, bigDogMeasurement: 600)
        XCTAssertEqual(result, [100, 100, 150, 200, 200])
    }

    func testCalculateComputedYards_ExcellentMasters_MissingSmallDogMeasurement() {
        let result = calculator.calculateComputedYards(level: .excellentMasters, smallDogMeasurement: nil, bigDogMeasurement: 600)
        XCTAssertEqual(result, [0, 0, 0, 0, 0])
    }

    func testCalculateComputedYards_OpenLevel() {
        let result = calculator.calculateComputedYards(level: .open, smallDogMeasurement: nil, bigDogMeasurement: 450)
        XCTAssertEqual(result, [150, 150, 150, 150, 150])
    }

    func testCalculateComputedYards_InvalidBigDogMeasurement() {
        let result = calculator.calculateComputedYards(level: .novice, smallDogMeasurement: nil, bigDogMeasurement: -10)
        XCTAssertEqual(result, [0, 0, 0, 0, 0])
    }

    // MARK: - checkComputedYards() Tests
    func testCheckComputedYards_ExcellentMasters_MissingMeasurements() {
        let result = calculator.checkComputedYards(level: .excellentMasters, classType: .standard, computedYards: [0, 0, 0, 0, 0])
        XCTAssertEqual(result, ["Both Dog Measurements are required"])
    }

    func testCheckComputedYards_BigDogMissing() {
        let result = calculator.checkComputedYards(level: .open, classType: .standard, computedYards: [100, 100, 100, 0, 100])
        XCTAssertEqual(result, ["Big Dog Measurement required"])
    }

    func testCheckComputedYards_SmallDogExceedsMax() {
        let result = calculator.checkComputedYards(level: .excellentMasters, classType: .standard, computedYards: [200, 200, 0, 180, 0])
        XCTAssertEqual(result, ["Small Dog Measurement max is 186 yards"])
    }

    func testCheckComputedYards_BigDogExceedsMax() {
        let result = calculator.checkComputedYards(level: .excellentMasters, classType: .standard, computedYards: [150, 150, 0, 200, 0])
        XCTAssertEqual(result, ["Big Dog Measurement max is 195 yards"])
    }

    func testCheckComputedYards_BothDogsExceedMax() {
        let result = calculator.checkComputedYards(level: .excellentMasters, classType: .jumpers, computedYards: [180, 180, 0, 190, 0])
        XCTAssertEqual(result, ["Small Dog Measurement max is 175 yards", "Big Dog Measurement max is 183 yards"])
    }

    func testCheckComputedYards_ValidDifference_NoWarnings() {
        let result = calculator.checkComputedYards(level: .excellentMasters, classType: .standard, computedYards: [170, 170, 0, 180, 0])
        XCTAssertTrue(result.isEmpty)
    }

    func testCheckComputedYards_InvalidDifference() {
        let result = calculator.checkComputedYards(level: .excellentMasters, classType: .standard, computedYards: [180, 180, 180, 180, 180])
        XCTAssertEqual(result, ["Typical difference is 7 to 14 yards"])
    }

    func testCheckComputedYards_ShortArray_NoCrash() {
        let result = calculator.checkComputedYards(level: .excellentMasters, classType: .standard, computedYards: [100])
        XCTAssertTrue(result.isEmpty)
    }

    func testCheckComputedYards_EmptyArray_NoCrash() {
        let result = calculator.checkComputedYards(level: .excellentMasters, classType: .standard, computedYards: [])
        XCTAssertTrue(result.isEmpty)
    }
}
