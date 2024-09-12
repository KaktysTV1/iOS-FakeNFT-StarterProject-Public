//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 05.09.2024.
//

import Foundation

struct OrderRequest: NetworkRequest {
    
    var dto: (any Dto)?
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var nfts: [String]?
}
