//
//  SCTViewModelTests.swift
//  AKC SCT Calculator
//
//  Created by FRANK GILMER on 3/13/25.
//

import XCTest
@testable import AKC_SCT_Calculator

class SCTViewModelTests: XCTestCase {
    var viewModel: SCTViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SCTViewModel()
    }

    func testCalculateSCTs_ExcellentMasters_ValidInputs() {
        viewModel.selectedLevel = .excellentMasters
        viewModel.selectedClassType = .standard
        viewModel.smallDogMeasurement = "300"
        viewModel.bigDogMeasurement = "600"
        
        viewModel.calculateSCTs()

        XCTAssertEqual(viewModel.computedYards, [100, 100, 150, 200, 200])
        XCTAssertFalse(viewModel.warningMessages.isEmpty)
    }

    func testCalculateSCTs_Open_NoSmallDogRequired() {
        viewModel.selectedLevel = .open
        viewModel.selectedClassType = .standard
        viewModel.bigDogMeasurement = "600"
        viewModel.smallDogMeasurement = ""  // Should be ignored
        
        viewModel.calculateSCTs()

        XCTAssertEqual(viewModel.computedYards, [200, 200, 200, 200, 200])
        XCTAssertFalse(viewModel.warningMessages.isEmpty)
    }

    func testCalculateSCTs_InvalidInputs_ReturnsZeros() {
        viewModel.selectedLevel = .novice
        viewModel.selectedClassType = .jumpers
        viewModel.smallDogMeasurement = "0"
        viewModel.bigDogMeasurement = "-10"
        
        viewModel.calculateSCTs()

        XCTAssertEqual(viewModel.computedYards, [0, 0, 0, 0, 0])
        XCTAssertTrue(viewModel.warningMessages.isEmpty)
    }
}
