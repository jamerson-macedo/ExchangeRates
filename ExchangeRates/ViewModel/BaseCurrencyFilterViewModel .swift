//
//  BaseCurrencyFilterViewModel .swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 02/08/24.
//

import Foundation
import Combine
import SwiftUI
extension BaseCurrencyFilterView{
    @MainActor class ViewModel : ObservableObject{
        
        enum ViewState {
            case start
            case loading
            case success
            case failure
        }
        
        @Published var currencySymbols = [CurrencySymbolModel]()
        @Published var searchResults = [CurrencySymbolModel]()
        
        private var cancelables = Set<AnyCancellable>()
        
        private let dataProvider : CurrencySymbolsDataProvider?
        
        @Published var viewState :ViewState = .start
        
        
        init(dataProvider: CurrencySymbolsDataProvider = CurrencySymbolsDataProvider()) {
            self.dataProvider = dataProvider
        }
        func doFetchCurrencySymbols(){
            viewState = .loading
            dataProvider?.fetchSymbols().receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.viewState = .success
                case .failure(_):
                    self.viewState = .failure
                }
            }, receiveValue: { currencies in
                withAnimation {
                    self.currencySymbols = currencies.sorted{$0.symbol < $1.symbol}
                    self.searchResults = self.currencySymbols
                }
            }).store(in: &cancelables)
        }
    
    }
}
