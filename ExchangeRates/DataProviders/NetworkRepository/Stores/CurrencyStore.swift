//
//  CurrencyStore.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
protocol CurrencyStoreProtocol: GenericStoreProtocol{
    func fetchSymbols(completion: @escaping completion<CurrentSymbolsObject?>)
}

class CurrencyStore : GenericStoreRequest,CurrencyStoreProtocol{
    func fetchSymbols(completion: @escaping completion<CurrentSymbolsObject?>) {
        guard let urlRequest = CurrencyRouter.symbols.asUrlRequest() else {
            return completion(nil,error)
        }
        request(urlRequqest: urlRequest, completion: completion)
    }
    
   
    
    
}
