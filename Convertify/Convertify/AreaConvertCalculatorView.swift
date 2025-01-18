//
//  AreaConvertCalculatorView.swift
//  Convertify
//
//  Created by HKinfoway Tech. on 15/01/25.
//

import SwiftUI

struct AreaConvertCalculatorView: View {
    @State private var input: String = "0"
    @State private var result: String = "0"
    @State private var fromUnit: String = "Square Meters"
    @State private var toUnit: String = "Square Kilometers"
    @State private var resultHistory: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    let units = ["Square Meters", "Square Kilometers", "Square Miles", "Square Yards", "Square Feet", "Acres", "Hectares", "Square Inches"]

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
                
                Text("Area")
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
                let convertedValue = convertArea(inputValue, fromUnit: fromUnit, toUnit: toUnit)
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

    private func convertArea(_ value: Double, fromUnit: String, toUnit: String) -> Double {
        let conversionFactors: [String: [String: Double]] = [
            "Square Meters": ["Square Kilometers": 1e-6, "Square Miles": 3.861e-7, "Square Yards": 1.19599, "Square Feet": 10.7639, "Acres": 0.000247105, "Hectares": 0.0001, "Square Inches": 1550],
            "Square Kilometers": ["Square Meters": 1e6, "Square Miles": 0.386102, "Square Yards": 1.19599e6, "Square Feet": 1.07639e7, "Acres": 247.105, "Hectares": 100, "Square Inches": 1.550003e7],
            "Square Miles": ["Square Meters": 2.59e6, "Square Kilometers": 2.58999, "Square Yards": 3.098e6, "Square Feet": 2.788e7, "Acres": 640, "Hectares": 258.9988, "Square Inches": 4.014e7],
            "Square Yards": ["Square Meters": 0.836127, "Square Kilometers": 8.361e-7, "Square Miles": 3.229e-7, "Square Feet": 9, "Acres": 0.000206612, "Hectares": 8.361e-5, "Square Inches": 1296],
            "Square Feet": ["Square Meters": 0.092903, "Square Kilometers": 9.29e-8, "Square Miles": 3.587e-8, "Square Yards": 0.111111, "Acres": 2.2957e-5, "Hectares": 9.29e-6, "Square Inches": 144],
            "Acres": ["Square Meters": 4046.86, "Square Kilometers": 0.00404686, "Square Miles": 0.0015625, "Square Yards": 4840, "Square Feet": 43560, "Hectares": 0.404686, "Square Inches": 6272640],
            "Hectares": ["Square Meters": 10000, "Square Kilometers": 0.01, "Square Miles": 0.003861, "Square Yards": 11959.9, "Square Feet": 107639, "Acres": 2.47105, "Square Inches": 1550000],
            "Square Inches": ["Square Meters": 0.00064516, "Square Kilometers": 6.4516e-10, "Square Miles": 2.491e-10, "Square Yards": 0.000771605, "Square Feet": 0.00694444, "Acres": 1.5942e-7, "Hectares": 6.4516e-8]
        ]
        
        if let factor = conversionFactors[fromUnit]?[toUnit] {
            return value * factor
        }
        return value
    }
}
