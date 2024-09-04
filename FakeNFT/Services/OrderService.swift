//
//  OrderService.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 28.08.2024.
//

import Foundation

typealias OrderCompletion = (Result<OrderDataModel, Error>) -> Void
typealias RemoveOrderCompletion = (Result<[String], Error>) -> Void
typealias RemoveAllNftCompletion = (Result<Int, Error>) -> Void

protocol OrderServiceProtocol {
    func removeNftFromStorage(id: String, completion: @escaping RemoveOrderCompletion)
}

final class OrderService: OrderServiceProtocol {
    
    private let networkClient: NetworkClient
    private let orderStorage: OrderStorage
    private var idsStorage: [String] = []
    var nftsStorage: [NftDataModel] = []
    
    init(networkClient: NetworkClient, orderStorage: OrderStorage) {
        self.networkClient = networkClient
        self.orderStorage = orderStorage
    }
    
    func removeNftFromStorage(id: String, completion: @escaping RemoveOrderCompletion) {
        var newIdsStorage = idsStorage
        newIdsStorage.removeAll(where: { $0 == id } )
        
        let request = ChangeOrderRequest(nfts: newIdsStorage)
        networkClient.send(request: request, type: ChangedOrderDataModel.self) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    self.idsStorage.removeAll(where: { $0 == id } )
                    self.nftsStorage.removeAll(where: { $0.id == id } )
                    completion(.success(data.nfts))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
        return
    }
}
