//
//  RateStore.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
protocol RateStoreProtocol : GenericStoreProtocol{
    func fetchFluctuation(by base:String,from symbols :[String],startDate :String, endDate :String, completion : @escaping completion <RateObject<RatesFluctuationObject>?>)
    func fetchTimeseries(by base:String,from symbols :String,startDate :String, endDate :String,completion:@escaping completion<RateObject<RatesHistoricalObject>?>)
}


class RateStore :GenericStoreRequest,RateStoreProtocol{
    func fetchFluctuation(by base: String, from symbols: [String], startDate: String, endDate: String, completion: @escaping completion<RateObject<RatesFluctuationObject>?>) {
        guard let urlRequest = RatesRouter.fluctuation(base: base, symbols: symbols, startDate: startDate, endDate: endDate).asUrlRequest() else {
            return completion(nil,error)
        }
        request(urlRequqest: urlRequest, completion: completion)
    }
    
    func fetchTimeseries(by base: String, from symbols: String, startDate: String, endDate: String, completion: @escaping completion<RateObject<RatesHistoricalObject>?>) {
        guard let urlRequest = RatesRouter.timeSeries(base: base, symbols: symbols, startDate: startDate, endDate: endDate).asUrlRequest() else {
            return completion(nil,error)
        }
        request(urlRequqest: urlRequest, completion: completion)
    }
    
  
   
    
    
}
