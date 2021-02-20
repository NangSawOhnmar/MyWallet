//
//  ExchangeRateClient.swift
//  MyWallet
//
//  Created by nang saw on 20/02/2021.
//

import Foundation

class ExchangeRateClient {
    
    enum Endpoints {
        static let base = "https://api.exchangeratesapi.io/latest"
        
        case convertExchangeBasedOnCountry(String)
        
        var stringValue: String {
            switch self {
            case .convertExchangeBasedOnCountry(let countryCode): return Endpoints.base + "?base=\(countryCode)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func requestExchangeRates(country: String, completionHandler: @escaping([Rate],Error?) -> Void) {
        let _ = taskForGETRequest(url: Endpoints.convertExchangeBasedOnCountry(country).url, response: ExchangeResponse.self) { (response,error) in
            guard let data = response else {
                completionHandler([],error)
                return
            }
                    
            var currencyList = [Currency]()
            let currecy = Currency()
            currencyList = currecy.loadEveryCountryWithCurrency()
            var exchangelist: [Rate] = []
                    
            for list in currencyList{
            let rate = data.rates.filter({$0.key == list.currencyCode})
                exchangelist.append(Rate(currencyCode: list.currencyCode ?? "",currencyName: list.currencyName ?? "",countryCode: list.countryCode ?? "",countryName: list.countryName ?? "",amount: rate.values.first ?? 0.0, lastUpdateDate: data.date))
            }
            completionHandler(exchangelist, nil)
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping(ResponseType?,Error?) -> Void) -> URLSessionTask{
        let task = URLSession.shared.dataTask(with: url) { data,response,error in
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil,error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject,nil)
                }
            }catch{
                do{
                    let errorResponse = try decoder.decode(ExchangeErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil,errorResponse)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(nil,error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
}
