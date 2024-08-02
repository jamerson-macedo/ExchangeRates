//
//  CurrencySelectionFilterView.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 01/08/24.
//

import SwiftUI

protocol MulticurrenciesfilterViewDelegate{
    func didSelecteds(_ currencies :[String])
}

struct CurrencySelectionFilterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @StateObject var viewmodel = ViewModel()
    @State private var selection : [String] = []
    
    var delegate : MulticurrenciesfilterViewDelegate?
    
    var searchResult : [CurrencySymbolModel]{
        if searchText.isEmpty{
            return viewmodel.CurrencySymbols
        }else {
            return viewmodel.CurrencySymbols.filter{ text in
                text.symbol.contains(searchText.uppercased()) || text.fullname.uppercased().contains(searchText.uppercased())
            }
        }
    }
    var body: some View {
        NavigationView
        {
            listCurrencyView
        }.onAppear{
            viewmodel.doFetchCurrencySymbols()
        }
    }
    private var listCurrencyView : some View{
        List(searchResult,id: \.symbol){ item in
            Button{
                if selection.contains(item.symbol){
                    selection.removeAll { value in
                        value == item.symbol
                    }
                }
                else {
                    selection.append(item.symbol)
                }
                
            }label: {
                HStack{
                    Text(item.symbol).font(.system(size: 14,weight: .bold))
                    Text("-").font(.system(size: 14,weight: .semibold))
                    Text(item.fullname).font(.system(size: 14,weight: .semibold))
                    Spacer()
                    Image(systemName: "checkmark").opacity(selection.contains(item.symbol) ? 1.0 : 0.0)
                }
            }.foregroundColor(.primary)
            
        }.searchable(text: $searchText)
            .navigationTitle("Filtrar Moedas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button(action: {
                    delegate?.didSelecteds(selection)
                    dismiss()
                    
                }, label: {
                    Text(selection.isEmpty ? "Cancelar" : "Ok").fontWeight(.bold)
                })
            }
    }
}

#Preview {
    CurrencySelectionFilterView()
}
