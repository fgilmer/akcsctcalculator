//
//  ContentView.swift
//  AKC SCT Calculator ContentView
//
//  Created by FRANK GILMER on 3/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var smallDogMeasurement = ""
    @State private var bigDogMeasurement = ""
    @State private var selectedLevel: Level = .excellentMasters
    @State private var selectedClassType: ClassType = .standard
    @State private var computedYards = Array(repeating: 0, count: 5)
    @State private var regularYPS = Array(repeating: 0, count: 5)
    @State private var warningMessages = [String]()

    let regularValues = [8, 12, 16, 20, 24]
    let preferredValues = [4, 8, 12, 16, 20]
    let calculator = SCTCalculator()
    
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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // 🔹 Picker for Level Enum
                Picker("Select Level", selection: $selectedLevel) {
                    ForEach(Level.allCases, id: \.self) { level in
                        Text(level.rawValue).tag(level)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // 🔹 Picker for ClassType Enum
                Picker("Select Class Type", selection: $selectedClassType) {
                    ForEach(ClassType.allCases, id: \.self) { classType in
                        Text(classType.rawValue).tag(classType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // 🔹 Show Small Dog Measurement only for Excellent/Masters
                if selectedLevel == .excellentMasters {
                    MeasurementInput(title: "Small Dog Measurement", value: $smallDogMeasurement)
                }
                
                MeasurementInput(title: "Big Dog Measurement", value: $bigDogMeasurement)
                
                Button(action: calculateSCTs) {
                    Text("Calculate SCTs")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                TableView(
                    computedYards: computedYards,
                    regularValues: regularValues,
                    preferredValues: preferredValues,
                    regularYPS: regularYPS
                )
                .frame(height: 250)
                
                WarningOutput(warnings: warningMessages)
            }
            .padding()
            .navigationTitle("AKC SCT Calculator")
        }
    }
}

struct MeasurementInput: View {
    let title: String
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            TextField(title, text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
        }
        .padding(.horizontal)
    }
}

struct TableView: View {
    let computedYards: [Int]
    let regularValues: [Int]
    let preferredValues: [Int]
    let regularYPS: [Int]
    
    var body: some View {
        VStack {
            HStack {
                Text("YDS").bold().frame(width: 60)
                Text("Regular").bold().frame(width: 80)
                Spacer()
                Text("Preferred").bold().frame(width: 80)
            }
            Divider()
            
            ForEach(0..<5, id: \..self) { index in
                HStack {
                    Text("\(computedYards[index])").frame(width: 60)
                    Text("\(regularValues[index])").frame(width: 80)
                    Text("\(regularYPS[index])").frame(width: 80)
                    Text("\(preferredValues[index])").frame(width: 80)
                    Text("\(regularYPS[index] + 5)").frame(width: 80)
                }
            }
        }
        .padding()
        .border(Color.gray, width: 1)
    }
}

struct WarningOutput: View {
    let warnings: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(warnings.indices, id: \.self) { index in
                HStack {
                    Text(warnings[index]) // Use direct string access
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                }
                .background(Color.yellow.opacity(0.2)) // Adds light background for visibility
                .cornerRadius(5)
                
                if index < warnings.count - 1 { // Prevents extra divider at the end
                    Divider()
                }
            }
        }
        .padding()
        .border(Color.gray, width: 1)
        .frame(maxWidth: 350) // Restricts table width
    }
}
