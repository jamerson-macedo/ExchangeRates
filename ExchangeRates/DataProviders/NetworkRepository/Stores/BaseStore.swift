//
//  RatesHistoricalObject.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation

// Classe base para armazenamento de dados
class BaseStore {
    
    // Erro padrão para problemas ao obter informações
    let error = NSError(domain: "", code: 901, userInfo: [NSLocalizedDescriptionKey: "Error getting information"]) as Error
    
    // Estrutura para resultado de taxas
    struct RateResult<Rates: Codable>: Codable {
        
        var base: String? // Moeda base
        var success: Bool = false // Sucesso da operação
        var rates: Rates? // Taxas
        
        // Inicializador para decodificação dos dados
        init(data: Data?, response: URLResponse?) throws {
            guard let data = data, let response = response as? HTTPURLResponse
            else {
                throw NSError(domain: "", code: 901, userInfo: [NSLocalizedDescriptionKey: "Error getting information"]) as Error
            }
            
            if let url = response.url?.absoluteString, let json = String(data: data, encoding: .utf8) {
                print("\(response.statusCode): \(url)")
                print("\(json)")
            }
            
            self = try JSONDecoder().decode(RateResult.self, from: data)
        }
    }
    
    // Estrutura para resultado de símbolos de moeda
    struct SymbolResult: Codable {
        var base: String? // Moeda base
        var success: Bool = false // Sucesso da operação
        var symbols: CurrentSymbolsObject? // Símbolos de moeda
        
        // Inicializador para decodificação dos dados
        init(data: Data?, response: URLResponse?) throws {
            guard let data = data, let response = response as? HTTPURLResponse
            else {
                throw NSError(domain: "", code: 901, userInfo: [NSLocalizedDescriptionKey: "Error getting information"]) as Error
            }
            
            if let url = response.url?.absoluteString, let json = String(data: data, encoding: .utf8) {
                print("\(response.statusCode): \(url)")
                print("\(json)")
            }
            
            self = try JSONDecoder().decode(SymbolResult.self, from: data)
        }
    }

}
