//
//  DataProviderManager.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
protocol DataProviderManagerDelegate{
    func success(model:Any)
    func errorData(_ provider:DataProviderManagerDelegate?,error:Error)
}

extension DataProviderManagerDelegate{
    func success(model:Any){
        preconditionFailure("this method must be overriden") // tem que implementar esse metodo
    }
    func errorData(_ provider:DataProviderManagerDelegate?,error:Error){
        print(error.localizedDescription)
    }
}
class DataProviderManager<T,S> {
    var delegate : T?
    var model : S?
}
