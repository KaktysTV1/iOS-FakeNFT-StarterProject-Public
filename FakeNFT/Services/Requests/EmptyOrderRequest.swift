//
//  EmptyOrderRequest.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 05.09.2024.
//

import Foundation

struct EmptyOrderRequest: NetworkRequest {
    
    var dto: (any Dto)?
    var httpMethod: HttpMethod { .put }
    var nfts: [String]?
    
    var endpoint: URL? {
        var urlComponents = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
        
        let components: [URLQueryItem] = []
        
        urlComponents?.queryItems = components
        return urlComponents?.url
    }
    
    var isUrlEncoded: Bool {
      return true
    }
    
    init(nfts: [String]) {
        self.nfts = nfts
    }
}

