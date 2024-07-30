//
//  CurrencyRouter.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 29/07/24.
//

import Foundation
enum CurrencyRouter {
    case symbols
    var path : String{
        switch self{
        case .symbols : return RateApi.symbols
        }
    }
    
    func asUrlRequest() throws ->URLRequest?{
        guard let url = URL(string: RateApi.baseUrl) else {return nil}
        
        switch self{
        case .symbols :
            var request = URLRequest(url: url.appendingPathComponent(path), timeoutInterval: Double.infinity)
            request.httpMethod = HttpMethod.get.rawValue
            request.addValue(RateApi.apiKey, forHTTPHeaderField:"apikey")
            return request
        }
    }
}
