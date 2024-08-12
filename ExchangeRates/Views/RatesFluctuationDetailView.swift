//
//  RatesFluctuationDetailsView.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 31/07/24.
//

import SwiftUI
import Charts
struct RatesFluctuationDetailView: View {
    @StateObject var viewmodel = ViewModel()
    @State var baseCurrency : String
    @State var rateFluctuation : RateFluctuationModel
    
    @State private var isPresentedCurrencyFilter = false
    var body: some View {
        ScrollView(showsIndicators:false){
            valuesView
            graphicChatView
            comparationView
        }.padding(.leading,8)
            .padding(.trailing,8)
            .navigationTitle(viewmodel.title)
            .onAppear{
                viewmodel.startStateView(baseCurrency: baseCurrency, rateFluctuation: rateFluctuation, timeRange: .today)
            }
    
    }
    private var valuesView : some View{
        HStack(alignment:.center){
            Text(viewmodel.endRate.formater(decimalPlaces: 4)).font(.system(size: 28,weight: .bold))
            Text(viewmodel.changePct.toPercentage(with: true))
                .font(.system(size: 18,weight: .semibold))
                .foregroundStyle(viewmodel.changePct.color)
                .background(viewmodel.changePct.color).opacity(0.2)
            Text(viewmodel.changeDescription).font(.system(size: 18,weight: .semibold))
                .foregroundStyle(viewmodel.change.color)
            Spacer()
        }.padding(.all,8)
    }
    private var graphicChatView :some View{
        VStack{
            periodFilterView
            lineChartView
            
        }.padding(.top,8)
            .padding(.bottom,8)
    }
    private var periodFilterView:some View{
        HStack(spacing:16){
            Button(action: {
                viewmodel.doFetchData(from: .today)
            }, label: {
                Text("1 Dia").font(.system(size: 14,weight: .bold))
                    .foregroundColor(viewmodel.timeRange == .today ? .blue : .gray).underline(viewmodel.timeRange == .today)
                
            }
            )
            Button(action: {
                viewmodel.doFetchData(from: .thisWeek)

            }, label: {
                Text("7 Dias").font(.system(size: 14,weight: .bold))
                    .foregroundColor(viewmodel.timeRange == .thisWeek ? .blue : .gray)
                    .underline(viewmodel.timeRange == .thisWeek)
            }
            )
            Button(action: {
                viewmodel.doFetchData(from: .thisMonth)

            }, label: {
                Text("1 Mês").font(.system(size: 14,weight: .bold))
                    .foregroundColor(viewmodel.timeRange == .thisMonth ? .blue : .gray).underline(viewmodel.timeRange == .thisMonth)
                
            }
            )
            Button(action: {
                viewmodel.doFetchData(from: .thisSemester)
            }, label: {
                Text("6 Meses").font(.system(size: 14,weight: .bold))
                    .foregroundColor(viewmodel.timeRange == .thisSemester ? .blue : .gray).underline(viewmodel.timeRange == .thisSemester)
                
            }
            )
            Button(action: {
                viewmodel.doFetchData(from: .thisYear)
            }, label: {
                Text("1 Ano").font(.system(size: 14,weight: .bold))
                    .foregroundColor(viewmodel.timeRange == .thisYear ? .blue : .gray)
                    .underline(viewmodel.timeRange == .thisYear)
            }
            )
        }
    }
    private var lineChartView : some View{
        Chart(viewmodel.ratesHistorical){ item in
            LineMark(x: .value("Time", item.period), y: .value("Rates", item.endRate)).interpolationMethod(.catmullRom)
            
            if !viewmodel.hasRates{
                RuleMark(y: .value("Conversão zero", 0)).annotation(position: .overlay,alignment:.center){
                    Text("Sem valores nesse periodo").font(.footnote).padding().background(Color(UIColor.systemBackground))
                }
            }
        }.chartYAxis{
            AxisMarks(position: .leading){ rates in
                AxisGridLine()
                AxisValueLabel(rates.as(Double.self)?.formater(decimalPlaces: 3) ?? 0.0.formater(decimalPlaces: 3))
                
            }
        }
        .chartXAxis{
            AxisMarks(preset: .aligned,values: .stride(by: viewmodel.xAxisStride,count: viewmodel.xAxisStrideCount)){ date in
                AxisGridLine()
                AxisValueLabel(viewmodel.xAxislabelFormatSTyle(for: date.as(Date.self) ?? Date()))
            }
        }
        .chartYScale(domain: viewmodel.yAxisMin...viewmodel.yAxisMax)
        .frame(height: 260)
        .padding(.trailing,18)
       
       

    }
    private var comparationView : some View{
        VStack(spacing:8){
            comparationButtonView
            comparationScrollView
            Spacer()
        }.padding(.top,8)
            .padding(.bottom,8)
    }
    private var comparationButtonView : some View{
        Button(action: {
            isPresentedCurrencyFilter.toggle()
        }, label: {
            Image(systemName: "magnifyingglass")
            Text("Comparar com").font(.system(size: 16))
        }).fullScreenCover(isPresented: $isPresentedCurrencyFilter){
            BaseCurrencyFilterView(delegate :self)
        }
        .opacity(viewmodel.ratesFluctuation.count == 0 ? 0 : 1)
        
    }
    private var comparationScrollView: some View{
        ScrollView(.horizontal,showsIndicators: false){
            LazyHGrid(rows: [GridItem(.flexible())],alignment: .center){
                ForEach(viewmodel.ratesFluctuation){ fluctuation in
                    Button{
                        viewmodel.doComparation(with: fluctuation)
                    }label: {
                        VStack(alignment: .leading,spacing: 4){
                            Text("\(fluctuation.symbol) / \(baseCurrency)").font(.system(size: 14)).foregroundStyle(Color.black)
                            Text(fluctuation.endRate.formater(decimalPlaces: 4)).font(.system(size: 14,weight: .semibold)).foregroundStyle(Color.black)
                            HStack(alignment: .bottom,spacing: 60){
                                Text(fluctuation.symbol).font(.system(size: 12,weight: .semibold)).foregroundStyle(Color.gray)
                                Text(fluctuation.changePct.toPercentage()).font(.system(size: 14,weight: .semibold)).foregroundStyle(fluctuation.changePct.color).frame(maxWidth: .infinity,alignment: .trailing)
                            }
                            
                        }.padding(.horizontal,16)
                            . padding(.vertical,8)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10).stroke(.gray,lineWidth: 1)
                        }
                    }
                }
            }
        }
    }
}

extension RatesFluctuationDetailView :BaseCurrencyFilterViewDelegate{
    func didSelected(baseCurrency: String) {
        viewmodel.doFilter(by: baseCurrency)
    }
    
    
}

#Preview {
    RatesFluctuationDetailView(baseCurrency: "BRL", rateFluctuation: RateFluctuationModel(symbol: "EUR", change: -0.0003, changePct: 0.1651, endRate: 0.181353))
}
