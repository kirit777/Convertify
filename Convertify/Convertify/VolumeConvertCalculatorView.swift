//
//  VolumeConvertCalculatorView.swift
//  Convertify
//
//  Created by HKinfoway Tech. on 15/01/25.
//

import SwiftUI

struct VolumeConvertCalculatorView: View {
    @State private var input: String = "0"
    @State private var result: String = "0"
    @State private var fromUnit: String = "Liters"
    @State private var toUnit: String = "Gallons"
    @State private var resultHistory: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    let units = ["Liters", "Milliliters", "Gallons", "Cubic Meters", "Cubic Inches", "Cubic Feet", "Quarts", "Pints"]

    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Circle().fill(Color.gray.opacity(0.2)))
                }
                
                Spacer()
                
                Text("Volume")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal)
            
            
            Spacer()
            // Display Section
            VStack {
                VStack(alignment: .trailing, spacing: 10) {
                    // Result history is reversed for bottom-to-top stacking
                    ForEach(resultHistory.reversed(), id: \.self) { result in
                        Text(result)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(input)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                    Text("Converted: \(result) \(toUnit)")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 100, alignment: .bottomTrailing)
                .background(Color.white.opacity(0.1))
            }

            Spacer()

            // Conversion Units
            HStack {
                Picker("From Unit", selection: $fromUnit) {
                    ForEach(units, id: \.self) { unit in
                        Text(unit)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 150)

                Text("to")

                Picker("To Unit", selection: $toUnit) {
                    ForEach(units, id: \.self) { unit in
                        Text(unit)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 150)
            }
            .padding()

            // Number and Operation Buttons
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    createButton("7")
                    createButton("8")
                    createButton("9")
                    createOperationButton("C")
                }
                HStack(spacing: 12) {
                    createButton("4")
                    createButton("5")
                    createButton("6")
                    createOperationButton("0")
                }
                HStack(spacing: 12) {
                    createButton("1")
                    createButton("2")
                    createButton("3")
                    createOperationButton(".")
                }
                HStack(spacing: 12) {
                    createOperationButton("=")
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
        .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    private func createButton(_ label: String) -> some View {
        Button(action: {
            buttonTapped(label)
        }) {
            Text(label)
                .font(.title2)
                .frame(maxWidth: .infinity, maxHeight: 70)
                .background(Color(UIColor.systemGray5))
                .foregroundColor(.black)
                .cornerRadius(10)
        }
    }

    @ViewBuilder
    private func createOperationButton(_ label: String) -> some View {
        Button(action: {
            buttonTapped(label)
        }) {
            Text(label)
                .font(.title2)
                .frame(width: 70, height: 70)
                .background(label == "=" ? Color.green.opacity(0.8) : Color.orange.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }

    private func buttonTapped(_ label: String) {
        switch label {
        case "C":
            input = "0"
            result = "0"
            resultHistory.removeAll()
        case "=":
            if let inputValue = Double(input) {
                let convertedValue = convertVolume(inputValue, fromUnit: fromUnit, toUnit: toUnit)
                result = String(format: "%.4f", convertedValue)
                resultHistory.append("\(input) \(fromUnit) = \(result) \(toUnit)")
            }
        default:
            if input == "0" {
                input = label
            } else {
                input += label
            }
        }
    }

    private func convertVolume(_ value: Double, fromUnit: String, toUnit: String) -> Double {
        let conversionFactors: [String: [String: Double]] = [
            "Liters": ["Milliliters": 1000, "Gallons": 0.264172, "Cubic Meters": 0.001, "Cubic Inches": 61.0237, "Cubic Feet": 0.0353147, "Quarts": 1.05669, "Pints": 2.11338],
            "Milliliters": ["Liters": 0.001, "Gallons": 0.000264172, "Cubic Meters": 1e-6, "Cubic Inches": 0.0610237, "Cubic Feet": 3.53147e-5, "Quarts": 0.00105669, "Pints": 0.00211338],
            "Gallons": ["Liters": 3.78541, "Milliliters": 3785.41, "Cubic Meters": 0.00378541, "Cubic Inches": 231, "Cubic Feet": 0.133681, "Quarts": 4, "Pints": 8],
            "Cubic Meters": ["Liters": 1000, "Milliliters": 1000000, "Gallons": 264.172, "Cubic Inches": 61023.7, "Cubic Feet": 35.3147, "Quarts": 1056.69, "Pints": 2113.38],
            "Cubic Inches": ["Liters": 0.0163871, "Milliliters": 16.3871, "Gallons": 0.004329, "Cubic Meters": 1.63871e-5, "Cubic Feet": 0.0005787, "Quarts": 0.034632, "Pints": 0.069264],
            "Cubic Feet": ["Liters": 28.3168, "Milliliters": 28316.8, "Gallons": 7.48052, "Cubic Meters": 0.0283168, "Cubic Inches": 1728, "Quarts": 29.9221, "Pints": 59.8442],
            "Quarts": ["Liters": 0.946353, "Milliliters": 946.353, "Gallons": 0.25, "Cubic Meters": 0.000946353, "Cubic Inches": 57.75, "Cubic Feet": 0.033552, "Pints": 2],
            "Pints": ["Liters": 0.473176, "Milliliters": 473.176, "Gallons": 0.125, "Cubic Meters": 0.000473176, "Cubic Inches": 28.875, "Cubic Feet": 0.016776, "Quarts": 0.5]
        ]
        
        if let factor = conversionFactors[fromUnit]?[toUnit] {
            return value * factor
        }
        return value
    }
}
