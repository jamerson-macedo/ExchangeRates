//
//  RatesFluctuationModel.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 02/08/24.
//

import Foundation

struct RateFluctuationModel :Identifiable,Equatable{
    let id = UUID()
    let symbol : String
    let change : Double
    let changePct : Double
    let endRate : Double
    
}
