//
//  GenericStore.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation

protocol GenericStoreProtocol{
    var error : Error{set get}
    typealias completion<T> = (_ result:T,_ failure :Error?) -> Void // o retorno do erro e do result
}
class GenericStoreRequest : GenericStoreProtocol{
    var error = NSError(domain: "", code: 901,userInfo: [NSLocalizedDescriptionKey:"Error getting information" ]) as Error
    func request<T:Codable>(urlRequqest:URLRequest,completion : @escaping completion<T?>){
        let task = URLSession.shared.dataTask(with: urlRequqest){ (data,response,error) in
            guard let data = data else{
                print(data)
                completion(nil,self.error)
                return
            }
            if let error {
                print(error)
                completion(nil,error)
            }
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                print(object)
                completion(object,nil)
            }catch{
                completion(nil,error)
            }
            
        }
        task.resume()
        
    }
    
}
