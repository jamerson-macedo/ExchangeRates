//
//  RatesRouter.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 29/07/24.
//

import Foundation

enum RatesRouter{
    case fluctuation(base:String,symbols : [String], startDate : String, endDate:String)
    case timeSeries(base:String,symbols : [String], startDate : String, endDate:String)
    
    var path:String {
        switch self{
        case.fluctuation:
            return RateApi.fluctuation
        case .timeSeries:
            return RateApi.timeseries
        }
    }
    func asUrlRequest() throws ->URLRequest?{
        guard var url = URL(string: RateApi.baseUrl) else {return nil}
        
        switch self{
        case .fluctuation( let base, let symbols , let startDate, let endDate):
            url.append(queryItems: [URLQueryItem(name: "base", value: base),
                                    URLQueryItem(name:"symbols", value: symbols.joined(separator: ",")),
                                    URLQueryItem(name: "start_date", value: startDate),
                                    URLQueryItem(name: "end_date", value: endDate)
                                ])
        case .timeSeries(let base, let symbols , let startDate, let endDate):
            url.append(queryItems: [URLQueryItem(name: "base", value: base),
                                    URLQueryItem(name:"symbols", value: symbols.joined(separator: ",")),
                                    URLQueryItem(name: "start_ate", value: startDate),
                                    URLQueryItem(name: "end_date", value: endDate)
                                ])
        }
        var request = URLRequest(url: url.appendingPathComponent(path),timeoutInterval: Double.infinity)
        request.httpMethod = HttpMethod.get.rawValue
        request.addValue(RateApi.apiKey, forHTTPHeaderField: "apikey")
        return request
    }
}
