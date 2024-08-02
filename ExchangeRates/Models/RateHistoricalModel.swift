//
//  RateHistoricalModel.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 02/08/24.
//

import Foundation
struct RateHistoricalModel :Identifiable{
    let id = UUID()
    let symbol : String
    let period : Date
    let endRate : Double
}
