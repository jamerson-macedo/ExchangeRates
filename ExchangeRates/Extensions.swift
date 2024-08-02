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

extension String {
    func toDate(dateFormat :String = "yyyy-MM-dd") -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self) ?? Date()
    }
}
extension Date{
    init(form component : Calendar.Component,value:Int){
        self = Calendar.current.date(byAdding: component, value: -value, to: Date()) ?? Date()
    }
    func formatter(dateFormat :String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR_POSIX")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from:self)
    }
    func toString(dateformater : String = "yyyy-MM-dd") ->String{
        return formatter(dateFormat: dateformater)
    }
}
extension UINavigationController{
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "",style: .plain,target: nil,action: nil)
    }
}
