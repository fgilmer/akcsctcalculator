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
    @State private var selectedLevel = "Excellent/Masters"
    @State private var selectedClassType = "Standard"
    @State private var computedYards = Array(repeating: 0, count: 5)
    
    let levels = ["Excellent/Masters", "Open", "Novice"]
    let classTypes = ["Standard", "Jumpers with Weaves"]
    let regularValues = [8, 12, 16, 20, 24]
    let preferredValues = [4, 8, 12, 16, 20]
    let calculator = SCTCalculator()
    
    func calculateSCTs() {
        computedYards = calculator.calculateComputedYards(
            level: selectedLevel,
            smallDogMeasurement: Int(smallDogMeasurement),
            bigDogMeasurement: Int(bigDogMeasurement)
        )
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Picker("Select Level", selection: $selectedLevel) {
                    ForEach(levels, id: \..self) { Text($0) }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Picker("Select Class Type", selection: $selectedClassType) {
                    ForEach(classTypes, id: \..self) { Text($0) }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if selectedLevel == "Excellent/Masters" {
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
                
                TableView(computedYards: computedYards, regularValues: regularValues, preferredValues: preferredValues)
                    .frame(height: 250)
                
                Spacer()
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
                    Spacer()
                    Text("\(preferredValues[index])").frame(width: 80)
                }
            }
        }
        .padding()
        .border(Color.gray, width: 1)
    }
}
