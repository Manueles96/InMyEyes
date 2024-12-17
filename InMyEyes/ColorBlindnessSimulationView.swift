//
//  ColorBlindnessSimulationView.swift
//  InMyEyes
//
//  Created by Manuele Esposito on 11/12/24.
//

import SwiftUI

struct ColorBlindnessSimulationView: View {
    @Binding var palette: [Color]
    @Binding var selectedSimulation: String
    @Binding var showColorPicker: Bool
    @Binding var selectedColorIndex: Int?
    @Binding var hexValues: [String]
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    @State private var lockedColors: [Bool] = Array(repeating: false, count: 5)
    
    let simulations = ["Protanopia", "Deuteranopia", "Tritanopia", "Achromatopsia", "Protanomaly", "Deuteranomaly"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // Colors section with palettes
                HStack(spacing: 0) {
                    // Left side colors
                    VStack(spacing: 0) {
                        Color.clear.frame(height: 30)
                        // Color squares
                        ForEach(0..<palette.count, id: \.self) { index in
                            palette[index]
                                .frame(height: UIScreen.main.bounds.height / 7)
                                .overlay(
                                    HStack {
                                        Text(hexForColor(palette[index]))
                                            .font(.subheadline)
                                            .foregroundColor(lockedColors[index] ? .black : .white)
                                            .bold()
                                            .padding(.leading, 10)
                                        Spacer()
                                        // Lock and copy buttons
                                        HStack(spacing: 8) {
                                            Button(action: {
                                                impactFeedback.impactOccurred()
                                                lockedColors[index].toggle()
                                            }) {
                                                Image(systemName: lockedColors[index] ? "lock.fill" : "lock.open")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.white)
                                                    .padding(6)
                                                    .background(Color.black.opacity(0.3))
                                                    .clipShape(Circle())
                                            }
                                            Button(action: {
                                                impactFeedback.impactOccurred()
                                                UIPasteboard.general.string = hexForColor(palette[index])
                                            }) {
                                                Image(systemName: "doc.on.doc")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.white)
                                                    .padding(6)
                                                    .background(Color.black.opacity(0.3))
                                                    .clipShape(Circle())
                                            }
                                        }
                                        .padding(.trailing, 10)
                                    }
                                )
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if !lockedColors[index] {
                                        selectedColorIndex = index
                                        showColorPicker = true
                                    }
                                }
                        }
                        
                        Spacer()
                            
                        
                        Button(action: {
                                                    impactFeedback.impactOccurred()
                                                    generateRandomColors()
                                                }) {
                                                    Text("Generate")
                                                        .font(.headline)
                                                        .bold()
                                                        .foregroundColor(.white)
                                                        .padding()
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 44) // Fixed height
                                                        .background(Color.blue)
                                                        .cornerRadius(22)
                                                }
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)

                    }
                    .frame(maxWidth: UIScreen.main.bounds.width / 2, maxHeight: .infinity)
                    .accessibilityLabel("Original palette")
                    
                    // Right side simulated colors
                    VStack(spacing: 0) {
                        Color.clear.frame(height: 30)
                        // Simulated color squares
                        ForEach(0..<palette.count, id: \.self) { index in
                            simulatedColor(palette[index])
                                .frame(height: UIScreen.main.bounds.height / 7)
                                .overlay(
                                    HStack {
                                                                            Text(hexForColor(simulatedColor(palette[index])))
                                                                                .font(.subheadline)
                                                                                .foregroundColor(.white)
                                                                                .bold()
                                                                                .padding(.leading, 10)
                                                                            Spacer()
                                                                            // Add copy button
                                                                            Button(action: {
                                                                                impactFeedback.impactOccurred()
                                                                                UIPasteboard.general.string = hexForColor(simulatedColor(palette[index]))
                                                                            }) {
                                                                                Image(systemName: "doc.on.doc")
                                                                                    .font(.system(size: 14))
                                                                                    .foregroundColor(.white)
                                                                                    .padding(6)
                                                                                    .background(Color.black.opacity(0.3))
                                                                                    .clipShape(Circle())
                                                                            }
                                                                            .padding(.trailing, 10)
                                                                        }
                                                                    )
                                                            }

                        
                      
                
                
                        Spacer()
                            
                        // Simulation picker
                        Menu {
                                                    ForEach(simulations, id: \.self) { simulation in
                                                        Button(action: {
                                                            impactFeedback.impactOccurred()
                                                            selectedSimulation = simulation
                                                        }) {
                                                            HStack {
                                                                Text(simulation)
                                                                    .font(.headline)
                                                                    .foregroundColor(simulation == selectedSimulation ? .blue : .primary)
                                                                Spacer()
                                                                if simulation == selectedSimulation {
                                                                    Image(systemName: "checkmark")
                                                                        .foregroundColor(.blue)
                                                                }
                                                            }
                                                            .padding(.vertical, 8)
                                                        }
                                                    }
                                                } label: {
                                                    HStack {
                                                        Text(selectedSimulation)
                                                            .font(.headline)
                                                            .bold()
                                                        Image(systemName: "chevron.down")
                                                    }
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 44) // Match Generate button height
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(22)
                                                }
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                            }
                    .frame(maxWidth: UIScreen.main.bounds.width / 2, maxHeight: .infinity)
                                        }
                                    }
            .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Text("InMyEyes")
                                    .font(.largeTitle)
                                    .bold()
                                    .padding(.top, 20) // Move title up
                            }
                        }
                        .background(colorScheme == .dark ? Color.black : Color.white)

            // Add color picker sheet
                        .sheet(isPresented: $showColorPicker) {
                            ColorPickerView(
                                title: "",
                                selectedColor: palette[selectedColorIndex ?? 0],
                                didSelectColor: { color in
                                    if let selectedIndex = selectedColorIndex {
                                        palette[selectedIndex] = color
                                        hexValues[selectedIndex] = hexForColor(color)
                                    }
                                }
                            )
                            .overlay(alignment: .topTrailing) {
                                                Button {
                                                    impactFeedback.impactOccurred()
                                                    showColorPicker = false
                                                } label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .font(.title2)
                                                        .foregroundColor(.gray)
                                                        .padding()
                                                }
                                            }

                            .presentationDetents([.height(640)])
                            .presentationDragIndicator(.visible)
                            .background(colorScheme == .dark ? Color.black : Color.white)
                        }
                    }

    }
    
    // Add generateRandomColors function
    private func generateRandomColors() {
        for i in 0..<palette.count where !lockedColors[i] {
            palette[i] = Color(
                red: Double.random(in: 0...1),
                green: Double.random(in: 0...1),
                blue: Double.random(in: 0...1)
            )
        }
        updateHexValues()
    }

    private func updateHexValues() {
        for i in 0..<palette.count {
            hexValues[i] = hexForColor(palette[i])
        }
    }


    // Simulate a color for a given type of color blindness
    func simulatedColor(_ color: Color) -> Color {
        switch selectedSimulation {
        case "Protanopia":
            return simulateProtanopia(color)
        case "Deuteranopia":
            return simulateDeuteranopia(color)
        case "Tritanopia":
            return simulateTritanopia(color)
        case "Achromatopsia":
            return simulateAchromatopsia(color)
        case "Protanomaly":
            return simulateProtanomaly(color)
        case "Deuteranomaly":
            return simulateDeuteranomaly(color)
        default:
            return color
        }
    }

    // Example simulations (replace with accurate color blindness algorithms)
    func simulateProtanopia(_ color: Color) -> Color {
        let values = getRGBValues(from: color)
        let r = values.r * 0.567 + values.g * 0.433 + values.b * 0
        let g = values.r * 0.558 + values.g * 0.442 + values.b * 0
        let b = values.r * 0 + values.g * 0.242 + values.b * 0.758
        return Color(red: r, green: g, blue: b)
    }
        
    func simulateDeuteranopia(_ color: Color) -> Color {
        let values = getRGBValues(from: color)
        let r = values.r * 0.625 + values.g * 0.375 + values.b * 0
        let g = values.r * 0.7 + values.g * 0.3 + values.b * 0
        let b = values.r * 0 + values.g * 0.3 + values.b * 0.7
        return Color(red: r, green: g, blue: b)
    }
        
    func simulateTritanopia(_ color: Color) -> Color {
        let values = getRGBValues(from: color)
        let r = values.r * 0.95 + values.g * 0.05 + values.b * 0
        let g = values.r * 0 + values.g * 0.433 + values.b * 0.567
        let b = values.r * 0 + values.g * 0.475 + values.b * 0.525
        return Color(red: r, green: g, blue: b)
    }
        
    func simulateAchromatopsia(_ color: Color) -> Color {
        let values = getRGBValues(from: color)
        let gray = (values.r + values.g + values.b) / 3.0
        return Color(red: gray, green: gray, blue: gray)
    }
        
    func simulateProtanomaly(_ color: Color) -> Color {
        let values = getRGBValues(from: color)
        let r = values.r * 0.817 + values.g * 0.183 + values.b * 0
        let g = values.r * 0.333 + values.g * 0.667 + values.b * 0
        let b = values.r * 0 + values.g * 0.125 + values.b * 0.875
        return Color(red: r, green: g, blue: b)
    }
        
    func simulateDeuteranomaly(_ color: Color) -> Color {
        let values = getRGBValues(from: color)
        let r = values.r * 0.8 + values.g * 0.2 + values.b * 0
        let g = values.r * 0.258 + values.g * 0.742 + values.b * 0
        let b = values.r * 0 + values.g * 0.142 + values.b * 0.858
        return Color(red: r, green: g, blue: b)
    }
    
    private func getRGBValues(from color: Color) -> (r: Double, g: Double, b: Double) {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (Double(red), Double(green), Double(blue))
    }
        

    // Convert Color to Hex String (for display)
    func hexForColor(_ color: Color) -> String {
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            let r = Int(red * 255)
            let g = Int(green * 255)
            let b = Int(blue * 255)
            
            return String(format: "#%02X%02X%02X", r, g, b)
        }
}

#Preview {
    ColorBlindnessSimulationView(
        palette: .constant([.red, .green, .blue, .yellow]),
        selectedSimulation: .constant("Protanopia"),
        showColorPicker: .constant(false),
        selectedColorIndex: .constant(nil),
        hexValues: .constant(["#FF0000", "#00FF00", "#0000FF", "#FFFF00"])
    )
}
