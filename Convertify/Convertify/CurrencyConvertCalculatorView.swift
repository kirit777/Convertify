//
//  CurrencyConvertCalculatorView.swift
//  Convertify
//
//  Created by HKinfoway Tech. on 15/01/25.
//

import SwiftUI

struct CurrencyConvertCalculatorView: View {
    @State private var input: String = "0"
    @State private var result: String = "0"
    @State private var fromCurrency: String = "USD"
    @State private var toCurrency: String = "INR"
    @State private var resultHistory: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    let currencies = ["USD", "INR", "EUR", "GBP", "AUD", "CAD", "JPY", "CNY"]

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
                
                Text("Currency")
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
                    Text("Converted: \(result) \(toCurrency)")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 100, alignment: .bottomTrailing)
                .background(Color.white.opacity(0.1))
            }

            Spacer()

            // Conversion Currencies
            HStack {
                Picker("From Currency", selection: $fromCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 150)

                Text("to")

                Picker("To Currency", selection: $toCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency)
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
                let convertedValue = convertCurrency(inputValue, fromCurrency: fromCurrency, toCurrency: toCurrency)
                result = String(format: "%.4f", convertedValue)
                resultHistory.append("\(input) \(fromCurrency) = \(result) \(toCurrency)")
            }
        default:
            if input == "0" {
                input = label
            } else {
                input += label
            }
        }
    }

    private func convertCurrency(_ value: Double, fromCurrency: String, toCurrency: String) -> Double {
        // Example currency rates (You can fetch live rates from a service like Open Exchange Rates API)
        let exchangeRates: [String: [String: Double]] = [
            "USD": ["INR": 74.5, "EUR": 0.85, "GBP": 0.75, "AUD": 1.35, "CAD": 1.25, "JPY": 110.0, "CNY": 6.45],
            "INR": ["USD": 0.013, "EUR": 0.011, "GBP": 0.010, "AUD": 0.018, "CAD": 0.017, "JPY": 1.48, "CNY": 0.087],
            "EUR": ["USD": 1.18, "INR": 88.5, "GBP": 0.88, "AUD": 1.59, "CAD": 1.47, "JPY": 129.5, "CNY": 7.55],
            // Add other currencies here
        ]
        
        guard let ratesFromCurrency = exchangeRates[fromCurrency],
              let conversionRate = ratesFromCurrency[toCurrency] else {
            return value // If no conversion rate is found, return the same value
        }
        
        return value * conversionRate
    }
}
