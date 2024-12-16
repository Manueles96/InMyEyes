//
//  PaletteRowView.swift
//  InMyEyes
//
//  Created by Manuele Esposito on 10/12/24.
//

import SwiftUI

struct PaletteRowView: View {
    @Binding var selectedColors: [Color]
    @Binding var hexValues: [String]
    @Binding var lockedColors: [Bool]
    @Binding var showColorPicker: Bool
    @Binding var selectedColorIndex: Int?
    @State private var impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    let index: Int

    var body: some View {
        ZStack {
            selectedColors[index]
                .frame(height: UIScreen.main.bounds.height / 6.6)  // Divide screen into 5 parts
                .overlay(
                    VStack {
                        Text(hexValues[index])
                            .font(.headline)
                            .foregroundColor(lockedColors[index] ? .black : .white)
                            .bold()
                            .padding(.bottom, 10)
                            .padding(.leading, 20) // Add left padding
                                                  //  Spacer() // Push text to the left
                        
                    },
                    alignment: .leading
                )
                

            VStack {
                Spacer()
                HStack {
                    Spacer()

                    // Lock/Unlock Button
                    Button(action: {
                        impactFeedback.impactOccurred() // Add haptic feedback
                        lockedColors[index].toggle()
                    }) {
                        Image(systemName: lockedColors[index] ? "lock.fill" : "lock.open")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }

                    // Copy Hex Button
                    Button(action: {
                        impactFeedback.impactOccurred() // Add haptic feedback
                        UIPasteboard.general.string = hexValues[index]  // Copy to clipboard
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 8)
                }
                .padding()
            }
        }
    }
}

#Preview {
    PaletteRowView(
        selectedColors: .constant([.red]),
        hexValues: .constant(["#7E1974", "#FFFFFF"]),
        lockedColors: .constant([false, false]),
        showColorPicker: .constant(false),
        selectedColorIndex: .constant(0),
        index: 0
    )
}
