//
//  SCTViewModel.swift
//  AKC SCT Calculator
//
//  Created by FRANK GILMER on 3/13/25.
//

import SwiftUI

class SCTViewModel: ObservableObject {
    @Published var smallDogMeasurement: String = ""
    @Published var bigDogMeasurement: String = ""
    @Published var selectedLevel: Level = .excellentMasters
    @Published var selectedClassType: ClassType = .standard
    @Published var computedYards: [Int] = Array(repeating: 0, count: 5)
    @Published var regularYPS: [Int] = Array(repeating: 0, count: 5)
    @Published var warningMessages: [String] = []

    private let calculator = SCTCalculator()
    
    func calculateSCTs() {
        computedYards = calculator.calculateComputedYards(
            level: selectedLevel,
            smallDogMeasurement: Int(smallDogMeasurement),
            bigDogMeasurement: Int(bigDogMeasurement)
        )
        
        regularYPS = calculator.calculateYardsPerSecond(
            level: selectedLevel,
            classType: selectedClassType,
            computedYards: computedYards
        )
        
        warningMessages = calculator.checkComputedYards(
            level: selectedLevel,
            classType: selectedClassType,
            computedYards: computedYards
        )
    }
}
