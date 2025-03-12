import SwiftUI

struct ContentView: View {
    @State private var courseDistanceFeet = ""
    @State private var excellentYPSMin = ""
    @State private var excellentYPSMax = ""
    @State private var openYPS = ""
    @State private var noviceYPS = ""
    @State private var selectedCategory = "Excellent/Masters"
    
    let categories = ["Excellent/Masters", "Open", "Novice"]
    
    var computedSCTs: [String] {
        guard let distanceFeet = Double(courseDistanceFeet), distanceFeet > 0 else { return [] }
        let distanceYards = distanceFeet / 3.0
        
        var scts: [String] = []
        
        switch selectedCategory {
        case "Excellent/Masters":
            if let minYPS = Double(excellentYPSMin), minYPS > 0,
               let maxYPS = Double(excellentYPSMax), maxYPS > 0 {
                scts.append("Excellent SCT (Min Speed): \(String(format: "%.2f", distanceYards / minYPS)) sec")
                scts.append("Excellent SCT (Max Speed): \(String(format: "%.2f", distanceYards / maxYPS)) sec")
            }
        case "Open":
            if let openSpeed = Double(openYPS), openSpeed > 0 {
                scts.append("Open SCT: \(String(format: "%.2f", distanceYards / openSpeed)) sec")
            }
        case "Novice":
            if let noviceSpeed = Double(noviceYPS), noviceSpeed > 0 {
                scts.append("Novice SCT: \(String(format: "%.2f", distanceYards / noviceSpeed)) sec")
            }
        default:
            break
        }
        
        return scts
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Course Distance (Feet)", text: $courseDistanceFeet)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(categories, id: \..self) { category in
                        Text(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if selectedCategory == "Excellent/Masters" {
                    TextField("Excellent/Masters Min YPS", text: $excellentYPSMin)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    TextField("Excellent/Masters Max YPS", text: $excellentYPSMax)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
                
                if selectedCategory == "Open" {
                    TextField("Open YPS", text: $openYPS)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
                
                if selectedCategory == "Novice" {
                    TextField("Novice YPS", text: $noviceYPS)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
                
                List(computedSCTs, id: \..self) { sct in
                    Text(sct)
                }
                .frame(height: 200)
                
                Spacer()
            }
            .padding()
            .navigationTitle("AKC SCT Calculator")
        }
    }
}
