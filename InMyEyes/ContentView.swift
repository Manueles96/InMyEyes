//
//  ContentView.swift
//  InMyEyes
//
//  Created by Manuele Esposito on 09/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedColors: [Color] = [.purple, .blue, .green, .yellow, .red]
    @State private var selectedSimulation = "Protanopia"
    @State private var showColorPicker = false
    @State private var selectedColorIndex: Int?
    @State private var hexValues: [String] = ["", "", "", "", ""]

    var body: some View {
        ColorBlindnessSimulationView(
            palette: $selectedColors,
            selectedSimulation: $selectedSimulation,
            showColorPicker: $showColorPicker,
            selectedColorIndex: $selectedColorIndex,
            hexValues: $hexValues
        )
    }
}

#Preview {
    ContentView()
}


