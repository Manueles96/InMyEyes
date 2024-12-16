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
    @State private var impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    let simulations = ["Protanopia", "Deuteranopia", "Tritanopia", "Achromatopsia", "Protanomaly", "Deuteranomaly"]
    let onApply: () -> Void
    let onCancel: () -> Void
    
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var hexValues: [String] = ["", "", "", "", ""]
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Colors section with adjusted height
            HStack(spacing: 0) {
                // Left side colors with label
                VStack(spacing: 0) {
                    // Color squares
                    ForEach(0..<palette.count, id: \.self) { index in
                        palette[index]
                            .frame(height: UIScreen.main.bounds.height / 7.5)
                            .overlay(
                                Text(hexForColor(palette[index]))
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .bold()
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Original color \(index + 1): \(hexForColor(palette[index]))")
                    }
                    
                    // Label for left palette
                    Text("Your Palette")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding(.top, 8)
                }
                .frame(width: UIScreen.main.bounds.width / 2)
                .accessibilityLabel("Original palette")
                
                // Right side colors with label
                VStack(spacing: 0) {
                    // Simulated color squares
                    ForEach(0..<palette.count, id: \.self) { index in
                        simulatedColor(palette[index])
                            .frame(height: UIScreen.main.bounds.height / 7.5)
                            .overlay(
                                Text(hexForColor(simulatedColor(palette[index])))
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .bold()
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Simulated color \(index + 1): \(hexForColor(simulatedColor(palette[index])))")
                    }
                    
                    // Label for right palette
                    Text("Simulation")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding(.top, 8)
                }
                .frame(width: UIScreen.main.bounds.width / 2)
                .accessibilityLabel("Simulated palette for \(selectedSimulation)")
                .id(selectedSimulation)
            }
            
            Spacer()
            
            // Controls section
            VStack(spacing: 16) {
                Menu {
                    ForEach(simulations, id: \.self) { simulation in
                        Button(action: {
                            impactFeedback.impactOccurred() // Add haptic feedback

                            selectedSimulation = simulation
                        }) {
                            Text(simulation)
                                .font(.headline)
                                .foregroundColor(simulation == selectedSimulation ? .blue : .primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 8)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedSimulation)
                            .font(.title3)
                            .bold()
                        Image(systemName: "chevron.down")
                            .font(.title3)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(30)
                }
                .accessibilityLabel("Color blindness type")
                .accessibilityHint("Double tap to select color blindness type. Currently selected: \(selectedSimulation)")

                .padding(.horizontal, 60)
                .padding(.bottom, 20)
                
                HStack {
                    Button(action: {
                        impactFeedback.impactOccurred() // Add haptic feedback
                        onCancel()
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                    }
                    .accessibilityLabel("Cancel")
                    .accessibilityHint("Double tap to cancel and keep original colors")
                    
                    Spacer()
                    
                    Button(action: {
                        impactFeedback.impactOccurred() // Add haptic feedback
                        // Apply simulated colors
                        for i in 0..<palette.count {
                            let simulatedColor = simulatedColor(palette[i])
                            palette[i] = simulatedColor
                        }
                        onApply()
                    }) {
                        Text("Apply")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    .accessibilityLabel("Apply simulated colors")
                    .accessibilityHint("Double tap to apply the simulated color palette")
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 0)
        }
        
        .padding(.horizontal)
        .padding(.bottom, 0)
        // Use dynamic background color based on color scheme
        .background(colorScheme == .dark ? Color.black : Color.white)
        .onAppear {
            updateHexValues()
        }
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
        guard let components = uiColor.cgColor.components, components.count >= 3 else {
            return "#FFFFFF"
        }
        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}

#Preview {
    ColorBlindnessSimulationView(
        palette: .constant([.red, .green, .blue, .yellow]),
        selectedSimulation: .constant("Protanopia"),
        onApply: {},
        onCancel: {}
    )
}
