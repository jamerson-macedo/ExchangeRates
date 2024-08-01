//
//  CurrencySelectionFilterView.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 01/08/24.
//

import SwiftUI

class CurrencySelectionFilterViewModel :ObservableObject{
    @Published var symbols :[Symbol] = [
        Symbol(symbol: "BRL", fullname: "Brazilian real"),
        Symbol(symbol: "EUR", fullname: "Euro"),
        Symbol(symbol: "JPY", fullname: "Japanese Yen"),
    ]
}

struct CurrencySelectionFilterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @StateObject var viewmodel = CurrencySelectionFilterViewModel()
    @State private var selection : [String] = []
    
    var searchResult : [Symbol]{
        if searchText.isEmpty{
            return viewmodel.symbols
        }else {
            return viewmodel.symbols.filter{ text in
                text.symbol.contains(searchText.uppercased()) || text.fullname.uppercased().contains(searchText.uppercased())
            }
        }
    }
    var body: some View {
        NavigationView
        {
            listCurrencyView
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
                    dismiss()
                    
                }, label: {
                    Text("OK").fontWeight(.bold)
                })
            }
    }
}

#Preview {
    CurrencySelectionFilterView()
}
