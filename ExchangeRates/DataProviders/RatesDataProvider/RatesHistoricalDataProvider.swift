//
//  RatesHistoricalDataProvider.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
import Combine
protocol RatesHistoricalDataProviderProtocol{
    func fetchTimeseries(by base: String, from symbols: String, startDate: String, endDate: String) ->AnyPublisher<[RateHistoricalModel],Error>
}

class RatesHistoricalnDataProvider : RatesHistoricalDataProviderProtocol{
    private let ratesStore : RateStore
    init(ratesStore: RateStore = RateStore()) {
        self.ratesStore = ratesStore
    }
    func fetchTimeseries(by base: String, from symbols: String, startDate: String, endDate: String) -> AnyPublisher<[RateHistoricalModel],Error> {
        return Future { promisse in
            self.ratesStore.fetchTimeseries(by: base, from: symbols, startDate: startDate, endDate: endDate) { result, error in
                DispatchQueue.main.async {
                    if let error{
                        return promisse(.failure(error))
                    }
                    guard let rates = result?.rates else {
                        return
                    }
                    let ratesHistorical = rates.flatMap({(key,rates)-> [RateHistoricalModel] in
                        return rates.map{RateHistoricalModel(symbol: $0, period: key.toDate(), endRate: $1)}
                        
                    })
                    return promisse(.success(ratesHistorical))
                }
            }
            
        }.eraseToAnyPublisher()
    }
}
