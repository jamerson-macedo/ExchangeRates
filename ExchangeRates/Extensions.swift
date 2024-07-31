//
//  Extensions.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 31/07/24.
//

import Foundation
import SwiftUI
extension Double {
    func formater(decimalPlaces:Int, with changeSymbol : Bool = false) -> String{
        let numberFormater = NumberFormatter()
        numberFormater.numberStyle = .decimal
        numberFormater.roundingMode = .halfUp
        numberFormater.minimumFractionDigits = (decimalPlaces > 2) ? decimalPlaces : 2
        numberFormater.maximumFractionDigits = (decimalPlaces > 2) ? decimalPlaces : 2
        numberFormater.locale = Locale(identifier: "pt_BR")
        guard let value = numberFormater.string(from: NSNumber(value: self)) else {return String(self)}
        if changeSymbol{
            if self.sign == .minus{
                return  "\(value)"
            }else {
                return  "+\(value)"

            }
        }
        return value.replacingOccurrences(of: "-", with: "")
    }
    func toPercentage(with changeSymbol : Bool = false) ->String{
        let value = formater(decimalPlaces: 2)
        if changeSymbol{
            if self.sign == .minus{
                return "\u{2193} \(value)%"
            }else {
                return "\u{2191} \(value)%"
            }
        }
        return "\(value)%"
    }
    var color :Color{
        if self.sign == .minus{
            return .red
        }else {
            return .green
        }
    }
}
