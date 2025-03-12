import SwiftUI

struct ContentView: View {
    @State internal var excellentSmallDogMeasurement = ""
    @State internal var excellentBigDogMeasurement = ""
    @State internal var openMeasurement = ""
    @State internal var noviceMeasurement = ""
    @State internal var selectedLevel = "Excellent/Masters"
    @State private var selectedClassType = "Standard"
    @State internal var computedYards = Array(repeating: 0, count: 5)
    
    let levels = ["Excellent/Masters", "Open", "Novice"]
    let classTypes = ["Standard", "Jumpers with Weaves"]
    let regularValues = [8, 12, 16, 20, 24]
    let preferredValues = [4, 8, 12, 16, 20]
    
    func convertToYards(_ value: Int) -> Int { value > 220 ? value / 3 : value }
    
    func calculateSCTs() {
        switch selectedLevel {
        case "Excellent/Masters":
            if let smallDogValue = Int(excellentSmallDogMeasurement),
               let bigDogValue = Int(excellentBigDogMeasurement),
               smallDogValue > 0, bigDogValue > 0 {
                
                let adjustedSmall = convertToYards(smallDogValue)
                let adjustedBig = convertToYards(bigDogValue)
                let averageValue = (adjustedSmall + adjustedBig) / 2
                
                computedYards = [adjustedSmall, adjustedSmall, averageValue, adjustedBig, adjustedBig]
            }
        case "Open":
            if let openValue = Int(openMeasurement), openValue > 0 {
                computedYards = Array(repeating: convertToYards(openValue), count: 5)
            }
        case "Novice":
            if let noviceValue = Int(noviceMeasurement), noviceValue > 0 {
                computedYards = Array(repeating: convertToYards(noviceValue), count: 5)
            }
        default:
            computedYards = Array(repeating: 0, count: 5)
        }
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
                
                Group {
                    if selectedLevel == "Excellent/Masters" {
                        MeasurementInput(title: "Small Dog Measurement", value: $excellentSmallDogMeasurement)
                        MeasurementInput(title: "Big Dog Measurement", value: $excellentBigDogMeasurement)
                    } else if selectedLevel == "Open" {
                        MeasurementInput(title: "Open Measurement", value: $openMeasurement)
                    } else if selectedLevel == "Novice" {
                        MeasurementInput(title: "Novice Measurement", value: $noviceMeasurement)
                    }
                }
                
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
        TextField(title, text: $value)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
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
