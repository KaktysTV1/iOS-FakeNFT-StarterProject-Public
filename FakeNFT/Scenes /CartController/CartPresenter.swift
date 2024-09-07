//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 27.08.2024.
//

import Foundation
import UIKit

protocol CartPresenterProtocol {
    func totalPrice() -> Float
    func count() -> Int
    func getModel(indexPath: IndexPath) -> NftDataModel
    func updateCartContent(with items: [NftDataModel])
    func removeItem(at index: Int)
    func getNftById(id: String)
    func setOrder()
    func getOrder()
    var cartContent: [NftDataModel] { get set }
    var viewController: CartViewControllerProtocol? { get set }
}

final class CartPresenter: CartPresenterProtocol {
    
    weak var viewController: CartViewControllerProtocol?
    private var orderService: OrderServiceProtocol?
    private var nftByIdService: NftByIdServiceProtocol?
    private var userDefaults = UserDefaults.standard
    private let filterKey = "filter"
    
    var cartContent: [NftDataModel] = [
        NftDataModel(createdAt: "13-04-2024", name: "mock1", images: ["mock1"], rating: 5, description: "", price: 1.78, author: "", id: "1"),
        NftDataModel(createdAt: "13-04-2024", name: "mock2", images: ["mock2"], rating: 4, description: "", price: 1.5, author: "", id: "2")
    ]
    
    var order: OrderDataModel?
    var nftById: NftDataModel?
    
    init(viewController: CartViewControllerProtocol, orderService: OrderServiceProtocol, nftByIdService: NftByIdServiceProtocol) {
        self.viewController = viewController
        self.orderService = orderService
        self.nftByIdService = nftByIdService
        self.orderService?.cartPresenter = self
    }
    
    // Метод для обновления корзины
    func updateCartContent(with items: [NftDataModel]) {
        cartContent = items
        viewController?.updateCartTable()
        if cartContent.isEmpty {
            viewController?.showPlaceholder()
        }
    }
    
    // Метод для удаления товара из корзины
    func removeItem(at index: Int) {
        guard index < cartContent.count else { return }
        cartContent.remove(at: index)
        updateCartContent(with: cartContent)
    }
    
    func totalPrice() -> Float {
        return cartContent.reduce(0) { $0 + $1.price }
    }
    
    func count() -> Int {
        return cartContent.count
    }
    
    func getOrder() {
        viewController?.startLoadIndicator()
        orderService?.loadOrder() { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let order):
                    self.order = order
                    self.cartContent = []
                    if !order.nfts.isEmpty {
                        order.nfts.forEach {
                            self.getNftById(id: $0)
                        }
                        
                        self.viewController?.updateCartTable()
                    }
                    
                    //self.sortCart(filter: self.currentFilter)
                    self.viewController?.stopLoadIndicator()
                    self.viewController?.updateCartTable()
                    self.viewController?.showPlaceholder()
                case .failure(let error):
                    print(error)
                    self.viewController?.stopLoadIndicator()
                }
            }
        }
    }
    
    func getNftById(id: String) {
        viewController?.startLoadIndicator()
        nftByIdService?.loadNft(id: id) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let nft):
                    self.nftById = nft
                    
                    let contains = self.cartContent.contains {
                        model in
                        return model.id == nft.id
                    }
                    
                    if contains {
                        guard let nft = self.nftById else {
                            print("Ошибка: nftById оказался nil")
                            return
                        }
                        self.cartContent.append(nft)
                    }
                    
                    self.viewController?.showPlaceholder()
                    self.viewController?.stopLoadIndicator()
                    //self.sortCart(filter: self.currentFilter)
                    
                    self.viewController?.updateCartTable()
                case .failure(let error):
                    print(error)
                    self.viewController?.stopLoadIndicator()
                }
            }
        }
    }
    
    func setOrder() {
        guard let order = self.orderService?.nftsStorage else { return }
        self.cartContent = order
        
        viewController?.updateCartTable()
    }
    
    func getModel(indexPath: IndexPath) -> NftDataModel {
        return cartContent[indexPath.row]
    }
}

extension CartPresenter: CartDeleteDelegate {
    func updateCart(with items: [NftDataModel]) {
    }
}
