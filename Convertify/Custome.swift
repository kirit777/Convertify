//
//  Custome.swift
//  Convertify
//
//  Created by HKinfoway Tech. on 15/01/25.
//
import SwiftUI

extension Color {
    // Initialize color with hex string, e.g. "#A7C7E7" or "A7C7E7"
    init(hex: String) {
        let hexString = hex.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
