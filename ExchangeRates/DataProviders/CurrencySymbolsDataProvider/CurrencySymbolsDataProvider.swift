//
//  CurrencySymbolsDataProvider.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
protocol CurrencySymbolsDataProviderDelegate : DataProviderManagerDelegate{
    func success(model:CurrentSymbolsObject)
}
class CurrencySymbolsDataProvider : DataProviderManager<CurrencySymbolsDataProviderDelegate, CurrentSymbolsObject>{
    private let currencyStore : CurrencyStore
    init(currencyStore: CurrencyStore = CurrencyStore()) {
        self.currencyStore = currencyStore
    }
    func fetchSymbols(){
        Task.init{
            do {
                let model = try await currencyStore.fetchSymbols()
                delegate?.success(model: model)
            }catch{
                delegate?.errorData(delegate, error: error)
            }
        }
    }
}
