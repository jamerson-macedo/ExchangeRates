//
//  MultiCurrenciesFilterViewMold.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 02/08/24.
//

import Foundation
import SwiftUI
extension CurrencySelectionFilterView{
    @MainActor class ViewModel:ObservableObject, CurrencySymbolsDataProviderDelegate{
        @Published var CurrencySymbols = [CurrencySymbolModel]()
        private let dataProvider : CurrencySymbolsDataProvider?
        init(dataProvider: CurrencySymbolsDataProvider = CurrencySymbolsDataProvider()) {
            self.dataProvider = dataProvider
            self.dataProvider?.delegate = self
        }
        func doFetchCurrencySymbols(){
            dataProvider?.fetchSymbols()
        }
        nonisolated func success(model: [CurrencySymbolModel]) {
            DispatchQueue.main.async {
                withAnimation {
                    self.CurrencySymbols = model.sorted{$0.symbol < $1.symbol}
                }
            }
         }
         
        
    }
}
