//
//  APICrypto.swift
//  CurrencyApp
//
//  Created by Zuka Papuashvili on 21.01.22.
//

import Foundation
import UIKit


final class APICrypto {
    static let shared = APICrypto()
    
    private struct Constants {
        static let apiKey = "BB35E732-FB98-44EC-B048-8D364504507A"
        static let assets = "https://rest.coinapi.io/v1/assets/"
    }
    
    private init() {}
    
    public var icons: [Icon] = []
    
    private var whenReady: ((Result<[Crypto], Error>) -> Void)?
    //Mark - Fetching Data API
    
    public func getAllCryptoData(
    completion: @escaping (Result<[Crypto], Error>) -> Void
    ) {
        guard !icons.isEmpty else {
            whenReady = completion
            return
        }
        
        guard let url = URL(string: Constants.assets + "?apikey=" + Constants.apiKey) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                
                completion(.success(cryptos.sorted { first, second in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                }))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getAllIcons() {
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55/?apikey=BB35E732-FB98-44EC-B048-8D364504507A")
        else {
            return 
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.whenReady {
                    self?.getAllCryptoData(completion: completion)
                }
                
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
}
