//
//  RatesFluctuactionDataProvider.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
import Combine
protocol RatesFluctuactionDataProviderProtocol{
    func fetchFluctuation(by base: String, from symbols: [String], startDate: String, endDate: String) ->AnyPublisher<[RateFluctuationModel],Error>
}

class RatesFluctuactionDataProvider : RatesFluctuactionDataProviderProtocol{
    private let rateStore : RateStore
    init(rateStore: RateStore = RateStore() ) {
        self.rateStore = rateStore
    }
    func fetchFluctuation(by base: String, from symbols: [String], startDate: String, endDate: String) -> AnyPublisher<[RateFluctuationModel],Error> {
        return Future { promisse in
            self.rateStore.fetchFluctuation(by: base, from: symbols, startDate: startDate, endDate: endDate) { result, error in
                if let error {
                    return promisse(.failure(error))
                }
                guard let rates = result?.rates else {
                    return
                }
                let ratesFluctuation = rates.map({(symbol,fluctuation)-> RateFluctuationModel in
                    return RateFluctuationModel(symbol: symbol, change: fluctuation.change, changePct: fluctuation.changePct, endRate: fluctuation.endRate)
                    
                })
                return promisse(.success(ratesFluctuation))
                
            }
        }.eraseToAnyPublisher()
    }
    
   
    
  
    
}
