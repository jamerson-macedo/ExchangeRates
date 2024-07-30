//
//  RateFluctuationObject.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
    // type alias ele renomeia as coisa
typealias RateFluctuationObject = [String: FluctuationObject]

struct FluctuationObject : Codable{
    let change : Double
    let changePct : Double
    let endRate : Double
    
    enum CodingKeys : String, CodingKey{
        case change
        case changePct = "change_pct"
        case endRate = "end_rate"
        
        
    }
    
    
}
