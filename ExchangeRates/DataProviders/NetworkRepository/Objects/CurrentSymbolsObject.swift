//
//  CurrentSymbols.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation

struct CurrentSymbolsObject :Codable{
    var base : String?
    var success:Bool = false
    var symbols : SymbolObject?
}
typealias SymbolObject = [String:String]
