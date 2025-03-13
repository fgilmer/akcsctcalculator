//
//  SCTCalculator.swift
//  AKC SCT Calculator Calculations
//
//  Created by FRANK GILMER on 3/13/25.
//

class SCTCalculator {
    func convertToYards(_ value: Int) -> Int {
        return value > 220 ? value / 3 : value
    }
    
    func calculateComputedYards(level: String, smallDogMeasurement: Int?, bigDogMeasurement: Int?) -> [Int] {
        guard let big = bigDogMeasurement, big > 0 else {
            return Array(repeating: 0, count: 5)
        }
        
        switch level {
        case "Excellent/Masters":
            guard let small = smallDogMeasurement, small > 0 else {
                return Array(repeating: 0, count: 5)
            }
            let adjustedSmall = convertToYards(small)
            let adjustedBig = convertToYards(big)
            let average = (adjustedSmall + adjustedBig) / 2
            return [adjustedSmall, adjustedSmall, average, adjustedBig, adjustedBig]
        case "Open", "Novice":
            return Array(repeating: convertToYards(big), count: 5)
        default:
            return Array(repeating: 0, count: 5)
        }
    }
}

