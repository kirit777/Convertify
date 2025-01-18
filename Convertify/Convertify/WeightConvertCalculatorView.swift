//
//  WeightConvertCalculatorView.swift
//  Convertify
//
//  Created by HKinfoway Tech. on 15/01/25.
//

import SwiftUI

struct WeightConvertCalculatorView: View {
    @State private var input: String = "0"
    @State private var result: String = "0"
    @State private var fromUnit: String = "Kilograms"
    @State private var toUnit: String = "Pounds"
    @State private var resultHistory: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    let units = ["Kilograms", "Grams", "Pounds", "Ounces", "Stones", "Tons"]
    
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
                
                Text("Weight")
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
                let convertedValue = convertWeight(inputValue, fromUnit: fromUnit, toUnit: toUnit)
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

    private func convertWeight(_ value: Double, fromUnit: String, toUnit: String) -> Double {
        let conversionFactors: [String: [String: Double]] = [
            "Kilograms": ["Grams": 1000, "Pounds": 2.20462, "Ounces": 35.274, "Stones": 0.157473, "Tons": 0.00110231],
            "Grams": ["Kilograms": 0.001, "Pounds": 0.00220462, "Ounces": 0.035274, "Stones": 0.000157473, "Tons": 1e-6],
            "Pounds": ["Kilograms": 0.453592, "Grams": 453.592, "Ounces": 16, "Stones": 0.0714286, "Tons": 0.000453592],
            "Ounces": ["Kilograms": 0.0283495, "Grams": 28.3495, "Pounds": 0.0625, "Stones": 0.00446429, "Tons": 2.83495e-5],
            "Stones": ["Kilograms": 6.35029, "Grams": 6350.29, "Pounds": 14, "Ounces": 224, "Tons": 0.00635029],
            "Tons": ["Kilograms": 907.185, "Grams": 907185, "Pounds": 2000, "Ounces": 32000, "Stones": 157.473]
        ]
        
        if let factor = conversionFactors[fromUnit]?[toUnit] {
            return value * factor
        }
        return value
    }
}
#Preview {
    WeightConvertCalculatorView()
}
