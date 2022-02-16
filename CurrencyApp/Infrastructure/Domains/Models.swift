//
//  Models.swift
//  CurrencyApp
//
//  Created by Zuka Papuashvili on 22.01.22.
//

import Foundation


struct Crypto: Codable {
    
    let asset_id: String
    let name: String?
    let price_usd: Float?
    let id_icon: String?
}


struct Icon: Codable {
    let asset_id: String
    let url: String
}
