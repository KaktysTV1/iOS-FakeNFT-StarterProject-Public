//
//  ChangeOrderRequest.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 28.08.2024.
//

import Foundation

struct ChangeOrderRequest: NetworkRequest {
    var dto: (any Dto)?
    
    
    var httpMethod: HttpMethod { .put }
    var nfts: Encodable?
    
    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    init(nfts: [String]) {
        self.nfts = ChangedOrderDataModel(nfts: nfts)
    }
}
