//
//  ColorPickerDemo.swift
//  InMyEyes
//
//  Created by Manuele Esposito on 09/12/24.
//

import SwiftUI

struct VerticalPalettePicker: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedColors: [Color]
    @Binding var shouldUpdateHexValues: Bool  // Add this binding
    @State private var hexValues: [String] = ["", "", "", "", ""]
    @State private var selectedColorIndex: Int?
    @State private var showColorPicker: Bool = false
    @State private var lockedColors: [Bool] = Array(repeating: false, count: 5)
    @State private var paletteHistory: [[Color]] = []
    @State private var currentHistoryIndex: Int = -1
    @State private var impactFeedback = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        VStack(spacing: 0) {
            // Your palette rows section
            ForEach(0..<selectedColors.count, id: \.self) { index in
                PaletteRowView(
                    selectedColors: $selectedColors,
                    hexValues: $hexValues,
                    lockedColors: $lockedColors,
                    showColorPicker: $showColorPicker,
                    selectedColorIndex: $selectedColorIndex,
                    index: index
                )
                
                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Color \(index + 1): \(hexValues[index])")
                                .accessibilityHint(lockedColors[index] ? "Color is locked. Double tap to unlock" : "Double tap to edit color")
                                .accessibilityAddTraits(.isButton)

                .onTapGesture {
                    if !lockedColors[index] {
                        impactFeedback.impactOccurred() // Add haptic feedback
                        selectedColorIndex = index
                        showColorPicker = true
                    }
                }
            }
            
            // Navigation controls
            HStack(spacing: 20) {
                // Back arrow
                Button(action: {
                    if currentHistoryIndex > 0 {
                        impactFeedback.impactOccurred() // Add haptic feedback
                        currentHistoryIndex -= 1
                        selectedColors = paletteHistory[currentHistoryIndex]
                        updateHexValues()
                    }
                }) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(currentHistoryIndex > 0 ? .blue : .gray)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                .accessibilityLabel("Previous palette")
                                .accessibilityHint("Double tap to go back to previous color palette")

                .disabled(currentHistoryIndex <= 0)
                
                // Generate button
                Button(action: {
                    impactFeedback.impactOccurred() // Add haptic feedback

                                        // Create a new array with random colors
                                        var newColors = selectedColors
                                        for i in 0..<newColors.count where !lockedColors[i] {
                                            newColors[i] = Color(
                                                red: Double.random(in: 0...1),
                                                green: Double.random(in: 0...1),
                                                blue: Double.random(in: 0...1)
                                            )
                                        }
                                        // Update selectedColors with the new array
                                        selectedColors = newColors
                                        // Update hex values
                                        updateHexValues()
                                        // Add to history
                                        if currentHistoryIndex < paletteHistory.count - 1 {
                                            paletteHistory.removeLast(paletteHistory.count - currentHistoryIndex - 1)
                    }
                    paletteHistory.append(newColors)
                    currentHistoryIndex = paletteHistory.count - 1
                }) {
                    Text("Generate")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                .accessibilityLabel("Generate new colors")
                                .accessibilityHint("Double tap to generate a new color palette")

                
               
                
                // Forward arrow
                Button(action: {
                                    if currentHistoryIndex < paletteHistory.count - 1 {
                                        impactFeedback.impactOccurred()
                                        currentHistoryIndex += 1
                                        let nextColors = paletteHistory[currentHistoryIndex]
                                        selectedColors = nextColors  // Apply next colors from history
                                        updateHexValues()

                    }
                }) {
                    Image(systemName: "arrow.uturn.forward")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(currentHistoryIndex < paletteHistory.count - 1 ? .blue : .gray)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                .accessibilityLabel("Next palette")
                                .accessibilityHint("Double tap to go to next color palette")
                .disabled(currentHistoryIndex >= paletteHistory.count - 1)
            }
            .padding()
        }
        .sheet(isPresented: $showColorPicker) {
            ColorPickerView(
                title: "Edit Color \(selectedColorIndex ?? 0 + 1)",
                selectedColor: selectedColors[selectedColorIndex ?? 0],
                didSelectColor: { color in
                    if let selectedIndex = selectedColorIndex {
                        selectedColors[selectedIndex] = color
                        hexValues[selectedIndex] = colorToHex(color)
                    }
                }
            )
            .padding(.top, 8)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .interactiveDismissDisabled(false)
            .presentationDetents([.height(640)])
            .overlay(
                alignment: .top,
                content: {
                    Rectangle()
                        .fill(colorScheme == .dark ? Color.black : Color.white)
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                }
            )
            .overlay(
                alignment: .topTrailing,
                content: {
                    Button(action: {
                        showColorPicker = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(colorScheme == .dark ? .white : .gray.opacity(0.8))
                    }
                    .font(.system(size: 16, weight: .bold))
                    .padding(.all, 8)
                    .background(Circle().fill(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.2)))
                    .padding()
                }
            )
        }
        .onChange(of: selectedColors) { oldValue, newValue in
                    // Only update history when colors change and it's not from navigation
                    if oldValue != newValue && !paletteHistory.contains(where: { $0 == newValue }) {
                        updateHexValues()
                        if currentHistoryIndex < paletteHistory.count - 1 {
                            paletteHistory.removeLast(paletteHistory.count - currentHistoryIndex - 1)
                        }
                        paletteHistory.append(newValue)
                        currentHistoryIndex = paletteHistory.count - 1
                    }
                }
                .onAppear {
                    if paletteHistory.isEmpty {
                        paletteHistory.append(selectedColors)
                        currentHistoryIndex = 0
                    }
                    updateHexValues()
        }
    }


    
    

    // Function to convert Color to Hex
    func colorToHex(_ color: Color) -> String {
        let uiColor = UIColor(color)
        guard let components = uiColor.cgColor.components, components.count >= 3
        else {
            return "#FFFFFF"  // Default to white if conversion fails
        }
        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)

        return String(format: "#%02X%02X%02X", red, green, blue)
    }

    // Function to update all hex values
    func updateHexValues() {
        for i in 0..<selectedColors.count {
            hexValues[i] = colorToHex(selectedColors[i])
        }
    }

    // Function to generate random colors for unlocked slots
    func generateRandomColors() {
        for i in 0..<selectedColors.count {
            if !lockedColors[i] {
                let randomColor = Color(
                    red: Double.random(in: 0...1),
                    green: Double.random(in: 0...1),
                    blue: Double.random(in: 0...1)
                )
                selectedColors[i] = randomColor
                hexValues[i] = colorToHex(randomColor)
            }
        }
    }
}

struct ColorPickerView: UIViewControllerRepresentable {
    private let delegate: ColorPickerDelegate
    private let pickerTitle: String
    private let selectedColor: UIColor

    init(
        title: String, selectedColor: Color,
        didSelectColor: @escaping ((Color) -> Void)
    ) {
        self.pickerTitle = title
        self.selectedColor = UIColor(selectedColor)
        self.delegate = ColorPickerDelegate(didSelectColor)
    }

    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let colorPickerController = UIColorPickerViewController()
        colorPickerController.delegate = delegate
        colorPickerController.title = pickerTitle
        colorPickerController.selectedColor = selectedColor
        return colorPickerController
    }

    func updateUIViewController(
        _ uiViewController: UIColorPickerViewController, context: Context
    ) {}
}

class ColorPickerDelegate: NSObject, UIColorPickerViewControllerDelegate {
    var didSelectColor: ((Color) -> Void)

    init(_ didSelectColor: @escaping ((Color) -> Void)) {
        self.didSelectColor = didSelectColor
    }

    func colorPickerViewController(
        _ viewController: UIColorPickerViewController, didSelect color: UIColor,
        continuously: Bool
    ) {
        let selectedUIColor = viewController.selectedColor
        didSelectColor(Color(uiColor: selectedUIColor))
    }

    func colorPickerViewControllerDidFinish(
        _ viewController: UIColorPickerViewController
    ) {
        print("Dismiss color picker")
    }
}

#Preview {
    VerticalPalettePicker(
        selectedColors: .constant([.purple, .blue, .green, .yellow, .red]),
        shouldUpdateHexValues: .constant(false))
        }



