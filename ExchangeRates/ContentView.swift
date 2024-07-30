//
//  ContentView.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 29/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: {
                doFetchData()
            }, label: {
                Text("Request")
            })
        }
        .padding()
    }
    private func doFetchData(){
        let rateFluctuationDataProvider = RatesFluctuactionDataProvider()
        rateFluctuationDataProvider.delegate = self
        rateFluctuationDataProvider.fetchFluctuation(by: "BRL", from: ["USD","EUR"], startDate: "2024-1-11", endDate: "2024-2-11")
        
        
        let rateSymbolDataProvider = CurrencySymbolsDataProvider()
        rateSymbolDataProvider.delegate = self
        rateSymbolDataProvider.fetchSymbols()
        
        let rateHistoricalProvider = RatesHistoricalnDataProvider()
        rateHistoricalProvider.delegate = self
        rateHistoricalProvider.fetchTimeseries(by: "BRL", from: ["USD","EUR"], startDate: "2024-1-11", endDate: "2024-2-11")
    }
    
}

extension ContentView :RatesFluctuactionDataProviderDelegate{
    func success(model: RateFluctuationObject) {
        print("RatesModel: \(model)")
    }
    
    
}
extension ContentView :CurrencySymbolsDataProviderDelegate{
    func success(model: CurrentSymbolsObject) {
        print("RatesSymbol : \(model)")
    }
    
}
extension ContentView:RatesHistoricalDataProviderDelegate{
    func success(model: RatesHistoricalObject) {
        print("Historical: \(model)")
    }
    
    
}
#Preview {
    ContentView()
}
