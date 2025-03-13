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
    
    func calculateYardsPerSecond(level: String, classType: String, computedYards: [Int]) -> [Int] {
        var ypsValues = getBaseYPS(level: level, classType: classType)
        var sctValues = [Int]()
        for (index,item) in ypsValues.enumerated() {
            var roundedYPS = Int((Double(computedYards[index]) / item).rounded())
            // Add table count for Novice and Open Standard
            if (classType == "Standard" && (level == "Open" || level == "Novice")) {
                roundedYPS += 5
            }
            sctValues.append(roundedYPS)
        }
        return sctValues
    }
    
    func getBaseYPS(level: String, classType: String) -> [Double] {
        var ypsValues = [Double]()
        switch level {
        case "Excellent/Masters":
            if (classType == "Standard") {
                ypsValues = [2.50, 2.70, 2.85, 3.10, 2.90]
            } else {
                ypsValues = [3.05, 3.25, 3.50, 3.75, 3.55]
            }
        case "Open":
            if (classType == "Standard") {
                ypsValues = [2.25, 2.35, 2.50, 2.65, 2.55]
            } else {
                ypsValues = [2.80, 3.00, 3.25, 3.50, 3.30]
            }
        case "Novice":
            if (classType == "Standard") {
                ypsValues = [1.85, 2.00, 2.15, 2.25, 2.20]
            } else {
                ypsValues = [2.30, 2.50, 2.75, 3.00, 2.80]
            }
        default:
            return Array(repeating: 0, count: 5)
        }
        return ypsValues
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

