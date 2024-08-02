//
//  RatesFluctuactionDataProvider.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
protocol RatesFluctuactionDataProviderDelegate:DataProviderManagerDelegate{
    func success(model:[RateFluctuationModel])
}

class RatesFluctuactionDataProvider : DataProviderManager<RatesFluctuactionDataProviderDelegate, [RateFluctuationModel]>{
    private let ratesStore : RateStore
    init(ratesStore: RateStore = RateStore()) {
        self.ratesStore = ratesStore
    }
    func fetchFluctuation(by base:String,from symbols :[String],startDate :String, endDate :String){
        Task.init{
            do {
                let model = try await ratesStore.fetchFluctuation(by: base, from: symbols, startDate: startDate, endDate: endDate)
                    delegate?.success(model: model.map({(key,value) -> RateFluctuationModel in  
                    return RateFluctuationModel(symbol: key, change: value.change, changePct: value.changePct, endRate: value.endRate)
                }))
            }catch{
                delegate?.errorData(delegate, error: error)
            }
        }
    }
}
