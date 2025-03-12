import SwiftUI

struct ContentView: View {
    @State private var excellentSmallDogMeasurement = ""
    @State private var excellentBigDogMeasurement = ""
    @State private var openMeasurement = ""
    @State private var noviceMeasurement = ""
    @State private var selectedLevel = "Excellent/Masters"
    @State private var selectedClassType = "Standard"
    @State private var computedYards = Array(repeating: 0, count: 5)
    
    let levels = ["Excellent/Masters", "Open", "Novice"]
    let classTypes = ["Standard", "Jumpers with Weaves"]
    let regularValues = [8, 12, 16, 20, 24]
    let preferredValues = [4, 8, 12, 16, 20]
    
    func calculateSCTs() {
        switch selectedLevel {
        case "Excellent/Masters":
            if let smallDogValue = Int(excellentSmallDogMeasurement),
               let bigDogValue = Int(excellentBigDogMeasurement),
               smallDogValue > 0, bigDogValue > 0 {
                
                let adjustedSmall = smallDogValue > 220 ? smallDogValue / 3 : smallDogValue
                let adjustedBig = bigDogValue > 220 ? bigDogValue / 3 : bigDogValue
                let averageValue = (adjustedSmall + adjustedBig) / 2
                
                computedYards = [adjustedSmall, adjustedSmall, averageValue, adjustedBig, adjustedBig]
            }
        case "Open":
            if let openValue = Int(openMeasurement), openValue > 0 {
                let adjustedOpenValue = openValue > 220 ? openValue / 3 : openValue
                computedYards = Array(repeating: adjustedOpenValue, count: 5)
            }
        case "Novice":
            if let noviceValue = Int(noviceMeasurement), noviceValue > 0 {
                let adjustedNoviceValue = noviceValue > 220 ? noviceValue / 3 : noviceValue
                computedYards = Array(repeating: adjustedNoviceValue, count: 5)
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
                        TextField("Excellent/Masters Small Dog Measurement", text: $excellentSmallDogMeasurement)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        TextField("Excellent/Masters Big Dog Measurement", text: $excellentBigDogMeasurement)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    } else if selectedLevel == "Open" {
                        TextField("Open Measurement", text: $openMeasurement)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    } else if selectedLevel == "Novice" {
                        TextField("Novice Measurement", text: $noviceMeasurement)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
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
