//
//  TimeConvertCalculatorView.swift
//  Convertify
//
//  Created by HKinfoway Tech. on 15/01/25.
//

import SwiftUI

struct TimeConvertCalculatorView: View {
    @State private var input: String = "0"
    @State private var result: String = "0"
    @State private var fromUnit: String = "seconds"
    @State private var toUnit: String = "minutes"
    @State private var resultHistory: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    let units = ["seconds", "minutes", "hours", "days", "weeks", "months", "years"]

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
                
                Text("Time")
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
                let convertedValue = convertTime(inputValue, fromUnit: fromUnit, toUnit: toUnit)
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

    private func convertTime(_ value: Double, fromUnit: String, toUnit: String) -> Double {
        switch (fromUnit, toUnit) {
        case ("seconds", "minutes"):
            return value / 60
        case ("seconds", "hours"):
            return value / 3600
        case ("seconds", "days"):
            return value / 86400
        case ("seconds", "weeks"):
            return value / 604800
        case ("seconds", "months"):
            return value / 2592000
        case ("seconds", "years"):
            return value / 31536000
        case ("minutes", "seconds"):
            return value * 60
        case ("minutes", "hours"):
            return value / 60
        case ("minutes", "days"):
            return value / 1440
        case ("minutes", "weeks"):
            return value / 10080
        case ("minutes", "months"):
            return value / 43800
        case ("minutes", "years"):
            return value / 525600
        case ("hours", "seconds"):
            return value * 3600
        case ("hours", "minutes"):
            return value * 60
        case ("hours", "days"):
            return value / 24
        case ("hours", "weeks"):
            return value / 168
        case ("hours", "months"):
            return value / 730
        case ("hours", "years"):
            return value / 8760
        case ("days", "seconds"):
            return value * 86400
        case ("days", "minutes"):
            return value * 1440
        case ("days", "hours"):
            return value * 24
        case ("days", "weeks"):
            return value / 7
        case ("days", "months"):
            return value / 30
        case ("days", "years"):
            return value / 365
        case ("weeks", "seconds"):
            return value * 604800
        case ("weeks", "minutes"):
            return value * 10080
        case ("weeks", "hours"):
            return value * 168
        case ("weeks", "days"):
            return value * 7
        case ("weeks", "months"):
            return value / 4.345
        case ("weeks", "years"):
            return value / 52.143
        case ("months", "seconds"):
            return value * 2592000
        case ("months", "minutes"):
            return value * 43800
        case ("months", "hours"):
            return value * 730
        case ("months", "days"):
            return value * 30
        case ("months", "weeks"):
            return value * 4.345
        case ("months", "years"):
            return value / 12
        case ("years", "seconds"):
            return value * 31536000
        case ("years", "minutes"):
            return value * 525600
        case ("years", "hours"):
            return value * 8760
        case ("years", "days"):
            return value * 365
        case ("years", "weeks"):
            return value * 52.143
        case ("years", "months"):
            return value * 12
        default:
            return value
        }
    }
}
