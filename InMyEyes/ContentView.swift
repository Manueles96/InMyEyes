//
//  ContentView.swift
//  InMyEyes
//
//  Created by Manuele Esposito on 09/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedColors: [Color] = [.purple, .blue, .green, .yellow, .red]
    @State private var showSimulation = false
    @State private var selectedSimulation = "Protanopia"
    @State private var shouldUpdateHexValues = false
    @State private var impactFeedback = UIImpactFeedbackGenerator(style: .medium)


    var body: some View {
        NavigationView {
            ZStack {
                // Pass selectedColors binding to VerticalPalettePicker
                VerticalPalettePicker(selectedColors: $selectedColors,
                                      shouldUpdateHexValues: $shouldUpdateHexValues)
            }
            .padding(.top, 30)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("InMyEyes")
                        .font(.largeTitle)
                        .bold()
                        .padding(.leading)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        impactFeedback.impactOccurred() // Add haptic feedback
                        showSimulation = true
                    }) {
                        Image(systemName: "eye")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .accessibilityLabel("Compare your palette with different type of color blindness")
                                    .accessibilityHint("Double tap to go to comparison")
                }
            }
        }
        .sheet(isPresented: $showSimulation) {
            ColorBlindnessSimulationView(
                palette: $selectedColors,
                selectedSimulation: $selectedSimulation,
                onApply: {
                    shouldUpdateHexValues = true  // Trigger hex update
                    showSimulation = false
                },
                onCancel: {
                    showSimulation = false
                }
            )
        }
    }
}




#Preview {
    ContentView()
}

