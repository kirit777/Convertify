//
//  MainDisplatView.swift
//  Convertify
//
//  Created by HKinfoway Tech. on 15/01/25.
//

import SwiftUI

struct MainDisplatView: View {
    var type:String
    var body: some View {
        ZStack{
            switch type {
                case  "Length":
                    LengthConvertCalculatorView()
                case  "Weight":
                    WeightConvertCalculatorView()
                case  "Temperature":
                    TemperatureConvertCalculatorView()
                case  "Volume":
                    VolumeConvertCalculatorView()
                case  "Currency":
                    CurrencyConvertCalculatorView()
                case  "Area":
                    AreaConvertCalculatorView()
                case  "Speed":
                    SpeedConvertCalculatorView()
                case  "Time":
                    TimeConvertCalculatorView()
                case  "Angle":
                    AngleConvertCalculatorView()
                case  "Energy":
                    EnergyConvertCalculatorView()
                case  "Power":
                    PowerConvertCalculatorView()
                case "Pressure" :
                    PressureConvertCalculatorView()
                case "Frequency" :
                    FrequencyConvertCalculatorView()
                default:
                    LengthConvertCalculatorView()
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarBackButtonHidden(true)
        
    }
}

//#Preview {
//    MainDisplatView()
//}
