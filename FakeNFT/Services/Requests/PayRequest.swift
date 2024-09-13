//
//  PayRequest.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 05.09.2024.
//

import Foundation

import Foundation

struct PayRequest: NetworkRequest {
    
    var dto: (any Dto)?
    let currencyId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
    }
    
    var nfts: [String]?
}
