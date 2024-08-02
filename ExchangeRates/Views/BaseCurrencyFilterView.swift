//
//  BaseCurrencyFilterView.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 01/08/24.
//

import SwiftUI


protocol BaseCurrencyFilterViewDelegate{
    func didSelected(baseCurrency:String)
}

struct BaseCurrencyFilterView: View {
    @StateObject var viewmodel = ViewModel()
    @State private var selectedFilter :String?
    @State private var searchText = ""
    
    @Environment(\.dismiss) var dismiss
    var delegate : BaseCurrencyFilterViewDelegate?
    
    var searchResult : [CurrencySymbolModel]{
        if searchText.isEmpty{
            return viewmodel.currencySymbols
        }else {
            return viewmodel.currencySymbols.filter{ text in
                text.symbol.contains(searchText.uppercased()) || text.fullname.uppercased().contains(searchText.uppercased())
            }
        }
    }
    var body: some View {
        NavigationView{
            listCurrencyView
        }.onAppear{
            viewmodel.doFetchCurrencySymbols()
        }
    }
    private var listCurrencyView : some View{
        List(searchResult,id: \.symbol,selection: $selectedFilter){ item in
            HStack{
                Text(item.symbol).font(.system(size: 14,weight: .bold))
                Text("-").font(.system(size: 14,weight: .semibold))
                Text(item.fullname).font(.system(size: 14,weight: .semibold))
            }
            
        }.searchable(text: $searchText)
            .navigationTitle("Filtrar Moedas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button(action: {
                    if let selectedFilter{
                        delegate?.didSelected(baseCurrency:selectedFilter)
                    }
                    dismiss()
                    
                }, label: {
                    Text("OK").fontWeight(.bold)
                })
            }
    }
    
}

#Preview {
    BaseCurrencyFilterView()
}
