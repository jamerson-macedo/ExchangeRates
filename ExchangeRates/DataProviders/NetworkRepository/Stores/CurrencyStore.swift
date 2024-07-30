//
//  CurrencyStore.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
protocol CurrencyStoreProtocol{
    func fetchSymbols() async throws ->CurrentSymbolsObject
}

class CurrencyStore :BaseStore, CurrencyStoreProtocol{
    func fetchSymbols() async throws -> CurrentSymbolsObject {
        guard let url = try CurrencyRouter.symbols.asUrlRequest() else {throw error}
        let (data,response) = try await URLSession.shared.data(for: url)
        guard let symbols = try SymbolResult(data: data, response: response).symbols else {throw error}
        return symbols
    }
    
    
}
