//
//  SCTCalculator.swift
//  Agility SCT Calculator Calculations
//
//  Created by FRANK GILMER on 3/13/25.
//
// MARK: - Enum Definitions
enum Level: String, CaseIterable {
    case excellentMasters = "Excellent/Masters"
    case open = "Open"
    case novice = "Novice"
}

enum ClassType: String, CaseIterable {
    case standard = "Standard"
    case jumpers = "Jumpers with Weaves"
}

// MARK: - SCT Calculator
class SCTCalculator {
    // use input value as yards if less than 220
    func convertToYards(_ value: Int) -> Int {
        value > 220 ? value / 3 : value
    }
    
    func calculateYardsPerSecond(level: Level, classType: ClassType, computedYards: [Int]) -> [Int] {
        let ypsValues = getBaseYPS(level: level, classType: classType)
        
        guard ypsValues.count == computedYards.count else {
            return Array(repeating: 0, count: computedYards.count)
        }
        
        return zip(ypsValues, computedYards).map { yps, yards in
            var roundedYPS = Int((Double(yards) / yps).rounded())
            if classType == .standard, level == .open || level == .novice {
                roundedYPS += 5
            }
            return roundedYPS
        }
    }
    
    func getBaseYPS(level: Level?, classType: ClassType?) -> [Double] {
        let baseYPS: [Level: [ClassType: [Double]]] = [
            .excellentMasters: [
                .standard: [2.50, 2.70, 2.85, 3.10, 2.90],
                .jumpers: [3.05, 3.25, 3.50, 3.75, 3.55]
            ],
            .open: [
                .standard: [2.25, 2.35, 2.50, 2.65, 2.55],
                .jumpers: [2.80, 3.00, 3.25, 3.50, 3.30]
            ],
            .novice: [
                .standard: [1.85, 2.00, 2.15, 2.25, 2.20],
                .jumpers: [2.30, 2.50, 2.75, 3.00, 2.80]
            ]
        ]
        
        // Ensure unknown levels and class types return default
        guard let validLevel = level, let validClassType = classType, let ypsValues = baseYPS[validLevel]?[validClassType] else {
            return Array(repeating: 0, count: 5)
        }
        
        return ypsValues
    }

    
    func calculateComputedYards(level: Level, smallDogMeasurement: Int?, bigDogMeasurement: Int?) -> [Int] {
        guard let big = bigDogMeasurement, big > 0 else {
            return Array(repeating: 0, count: 5)
        }
        let adjustedBig = convertToYards(big)
        
        if level == .excellentMasters {
            guard let small = smallDogMeasurement, small > 0 else {
                return Array(repeating: 0, count: 5)
            }
            let adjustedSmall = convertToYards(small)
            let average = (adjustedSmall + adjustedBig) / 2
            return [adjustedSmall, adjustedSmall, average, adjustedBig, adjustedBig]
        }
        
        // For Open/Novice, use only big dog measurement
        return Array(repeating: adjustedBig, count: 5)
    }
    
    func checkComputedYards(level: Level, classType: ClassType, computedYards: [Int]) -> [String] {
        guard computedYards.count > 3 else { return [] }

        let classLimits: [ClassType: (smallDogMax: Int, largeDogMax: Int, minDiff: Int, maxDiff: Int)] = [
            .standard: (186, 195, 7, 14),
            .jumpers: (175, 183, 8, 16)
        ]

        guard let limits = classLimits[classType] else { return [] }
        
        var warnings = [String]()

        if level == .excellentMasters && (computedYards[0] == 0 || computedYards[3] == 0) {
            warnings.append("Both Dog Measurements are required")
        } else if computedYards[3] == 0 {
            warnings.append("Big Dog Measurement required")
        }
        // Return if any errors to this point the rest are informational
        if !warnings.isEmpty {
                    return warnings
        }
        
        // Only check small dog measurement for Excellent Masters
        if level == .excellentMasters, computedYards[0] > limits.smallDogMax {
            warnings.append("Small Dog Measurement max is \(limits.smallDogMax) yards")
        }

        if computedYards[3] > limits.largeDogMax {
            warnings.append("Large Dog Measurement max is \(limits.largeDogMax) yards")
        }

        // Return if any errors to this point the rest are informational
        if !warnings.isEmpty {
                    return warnings
        }
        
        // Check measurement difference if no warnings exist
        if level == .excellentMasters {
            let measurementDiff = computedYards[3] - computedYards[0]
            if measurementDiff < limits.minDiff || measurementDiff > limits.maxDiff {
                warnings.append("Typical difference is \(limits.minDiff) to \(limits.maxDiff) yards")
            }
        }

        return warnings
    }
}
