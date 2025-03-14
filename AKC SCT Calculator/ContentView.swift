//
//  ContentView.swift
//  AKC SCT Calculator ContentView
//
//  Created by FRANK GILMER on 3/11/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = SCTViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Picker("Select Level", selection: $viewModel.selectedLevel) {
                    ForEach(Level.allCases, id: \.self) { level in
                        Text(level.rawValue).tag(level)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Picker("Select Class Type", selection: $viewModel.selectedClassType) {
                    ForEach(ClassType.allCases, id: \.self) { classType in
                        Text(classType.rawValue).tag(classType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if viewModel.selectedLevel == .excellentMasters {
                    MeasurementInput(title: "Small Dog Measurement", value: $viewModel.smallDogMeasurement)
                }
                
                MeasurementInput(title: "Big Dog Measurement", value: $viewModel.bigDogMeasurement)
                
                Button(action: viewModel.calculateSCTs) {
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
                    computedYards: viewModel.computedYards,
                    regularValues: [8, 12, 16, 20, 24],
                    preferredValues: [4, 8, 12, 16, 20],
                    regularYPS: viewModel.regularYPS
                )
                .frame(height: 200)
                
                if !viewModel.warningMessages.isEmpty {
                    WarningOutput(warnings: viewModel.warningMessages)
                }
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
        VStack(alignment: .leading, spacing: 0) {
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
