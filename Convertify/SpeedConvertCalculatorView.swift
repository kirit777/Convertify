//
//  SpeedConvertCalculatorView.swift
//  Convertify
//
//  Created by HKinfoway Tech. on 15/01/25.
//

import SwiftUI

struct SpeedConvertCalculatorView: View {
    @State private var input: String = "0"
    @State private var result: String = "0"
    @State private var fromUnit: String = "m/s"
    @State private var toUnit: String = "km/h"
    @State private var resultHistory: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    let units = ["m/s", "km/h", "mph", "ft/s"]

    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.black)
                        .padding(10)
                       // .background(Circle().fill(Color.gray.opacity(0.2)))
                }
                
                Spacer()
                
                Text("Speed")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(20)
            .shadow(radius: 10)
            
            
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
                let convertedValue = convertSpeed(inputValue, fromUnit: fromUnit, toUnit: toUnit)
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

    private func convertSpeed(_ value: Double, fromUnit: String, toUnit: String) -> Double {
        switch (fromUnit, toUnit) {
        case ("m/s", "km/h"):
            return value * 3.6
        case ("m/s", "mph"):
            return value * 2.23694
        case ("m/s", "ft/s"):
            return value * 3.28084
        case ("km/h", "m/s"):
            return value / 3.6
        case ("km/h", "mph"):
            return value / 1.60934
        case ("km/h", "ft/s"):
            return value * 0.911344
        case ("mph", "m/s"):
            return value / 2.23694
        case ("mph", "km/h"):
            return value * 1.60934
        case ("mph", "ft/s"):
            return value * 1.46667
        case ("ft/s", "m/s"):
            return value / 3.28084
        case ("ft/s", "km/h"):
            return value / 0.911344
        case ("ft/s", "mph"):
            return value / 1.46667
        default:
            return value
        }
    }
}
