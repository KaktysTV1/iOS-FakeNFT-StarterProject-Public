//
//  CurrenciesRequest.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 05.09.2024.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    
    var dto: (any Dto)?
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")

    }
    
    var nfts: [String]?
}
