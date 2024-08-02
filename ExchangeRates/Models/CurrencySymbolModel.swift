//
//  CurrencySymbolModel.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 02/08/24.
//

import Foundation
struct CurrencySymbolModel : Identifiable{
    let id = UUID()
    var symbol : String
    var fullname :String
}
