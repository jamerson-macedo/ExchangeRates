//
//  CurrencySymbolsDataProvider.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
import Combine

protocol CurrencySymbolsDataProviderProtocol{
    func fetchSymbols()-> AnyPublisher<[CurrencySymbolModel],Error>
}
class CurrencySymbolsDataProvider : CurrencySymbolsDataProviderProtocol{
    
    private let currencyStore : CurrencyStore
    
    init(currencyStore: CurrencyStore = CurrencyStore()) {
        self.currencyStore = currencyStore
    }
    func fetchSymbols() -> AnyPublisher<[CurrencySymbolModel],Error> {
        return Future{ promisse in
            self.currencyStore.fetchSymbols { result, error in
                DispatchQueue.main.async {
                    if let error {
                        return promisse(.failure(error))
                    }
                    guard let symbols = result?.symbols else {
                        return
                    }
                    let currencySymbols = symbols.map ({(key,value)-> CurrencySymbolModel in
                    return CurrencySymbolModel(symbol: key, fullname: value)
                    })
                    return promisse(.success(currencySymbols))
                }
            }
            
        }.eraseToAnyPublisher()
    }
   
}
