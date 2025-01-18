//
//  PressureConvertCalculatorView.swift
//  Convertify
//
//  Created by HKinfoway Tech. on 15/01/25.
//

import SwiftUI

struct PressureConvertCalculatorView: View {
    @State private var input: String = "0"
    @State private var result: String = "0"
    @State private var fromUnit: String = "Pascal"
    @State private var toUnit: String = "Atmosphere"
    @State private var resultHistory: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    let units = ["Pascal", "Atmosphere", "Bar", "Torr", "Millimeter of Mercury (mmHg)", "Pound per Square Inch (psi)"]

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
                
                Text("Pressure")
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
                let convertedValue = convertPressure(inputValue, fromUnit: fromUnit, toUnit: toUnit)
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

    private func convertPressure(_ value: Double, fromUnit: String, toUnit: String) -> Double {
        switch (fromUnit, toUnit) {
        case ("Pascal", "Atmosphere"):
            return value / 101325
        case ("Pascal", "Bar"):
            return value / 100000
        case ("Pascal", "Torr"):
            return value * 0.00750062
        case ("Pascal", "Millimeter of Mercury (mmHg)"):
            return value * 0.00750062
        case ("Pascal", "Pound per Square Inch (psi)"):
            return value * 0.000145038
        case ("Atmosphere", "Pascal"):
            return value * 101325
        case ("Atmosphere", "Bar"):
            return value * 1.01325
        case ("Atmosphere", "Torr"):
            return value * 760
        case ("Atmosphere", "Millimeter of Mercury (mmHg)"):
            return value * 760
        case ("Atmosphere", "Pound per Square Inch (psi)"):
            return value * 14.696
        case ("Bar", "Pascal"):
            return value * 100000
        case ("Bar", "Atmosphere"):
            return value * 0.986923
        case ("Bar", "Torr"):
            return value * 750.062
        case ("Bar", "Millimeter of Mercury (mmHg)"):
            return value * 750.062
        case ("Bar", "Pound per Square Inch (psi)"):
            return value * 14.5038
        case ("Torr", "Pascal"):
            return value / 0.00750062
        case ("Torr", "Atmosphere"):
            return value / 760
        case ("Torr", "Bar"):
            return value / 750.062
        case ("Torr", "Millimeter of Mercury (mmHg)"):
            return value
        case ("Torr", "Pound per Square Inch (psi)"):
            return value * 0.0193368
        case ("Millimeter of Mercury (mmHg)", "Pascal"):
            return value / 0.00750062
        case ("Millimeter of Mercury (mmHg)", "Atmosphere"):
            return value / 760
        case ("Millimeter of Mercury (mmHg)", "Bar"):
            return value / 750.062
        case ("Millimeter of Mercury (mmHg)", "Torr"):
            return value
        case ("Millimeter of Mercury (mmHg)", "Pound per Square Inch (psi)"):
            return value * 0.0193368
        case ("Pound per Square Inch (psi)", "Pascal"):
            return value / 0.000145038
        case ("Pound per Square Inch (psi)", "Atmosphere"):
            return value / 14.696
        case ("Pound per Square Inch (psi)", "Bar"):
            return value / 14.5038
        case ("Pound per Square Inch (psi)", "Torr"):
            return value / 0.0193368
        case ("Pound per Square Inch (psi)", "Millimeter of Mercury (mmHg)"):
            return value / 0.0193368
        default:
            return value
        }
    }
}
