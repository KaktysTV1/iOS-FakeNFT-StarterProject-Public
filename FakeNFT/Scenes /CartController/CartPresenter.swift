//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 27.08.2024.
//

import Foundation
import UIKit

//MARK: - Protocol

protocol CartPresenterProtocol {
    func totalPrice() -> Float
    func count() -> Int
    func getModel(indexPath: IndexPath) -> NftDataModel
    func updateCartContent(with items: [NftDataModel])
    func removeItem(at index: Int)
    func getNftById(id: String)
    func setOrder()
    func getOrder()
    func sortCart(filter: CartFilter.FilterBy)
    var cartContent: [NftDataModel] { get set }
    var viewController: CartViewControllerProtocol? { get set }
}

final class CartPresenter: CartPresenterProtocol {
    
    weak var viewController: CartViewControllerProtocol?
    private var orderService: OrderServiceProtocol?
    private var nftByIdService: NftByIdServiceProtocol?
    private var userDefaults = UserDefaults.standard
    private let filterKey = "filter"
    private var currentFilter: CartFilter.FilterBy {
        get {
            let id = userDefaults.integer(forKey: filterKey)
            return CartFilter.FilterBy(rawValue: id) ?? .id
        }
        set {
            userDefaults.setValue(newValue.rawValue, forKey: filterKey)
        }
    }
    
    var cartContent: [NftDataModel] = []
    
    var order: OrderDataModel?
    var nftById: NftDataModel?
    
    init(viewController: CartViewControllerProtocol, orderService: OrderServiceProtocol, nftByIdService: NftByIdServiceProtocol) {
        self.viewController = viewController
        self.orderService = orderService
        self.nftByIdService = nftByIdService
        self.orderService?.cartPresenter = self
    }
    
//MARK: - Metods
    
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
                    
                    self.sortCart(filter: self.currentFilter)
                    self.viewController?.showPlaceholder()
                    self.viewController?.updateCartTable()
                    self.viewController?.stopLoadIndicator()
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

                    // Сначала проверяем, что nftById не является nil
                    guard let nft = self.nftById else {
                        print("Ошибка: nftById оказался nil")
                        return
                    }

                    // Затем проверяем, содержится ли объект в cartContent
                    let contains = self.cartContent.contains { model in
                        return model.id == nft.id
                    }

                    // Если объект еще не в массиве, добавляем его
                    if !contains {
                        self.cartContent.append(nft)
                    }

                    // Обновляем интерфейс
                    self.viewController?.showPlaceholder()
                    self.sortCart(filter: self.currentFilter)
                    self.viewController?.updateCartTable()
                    self.viewController?.stopLoadIndicator()
                    
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
    
    func sortCart(filter: CartFilter.FilterBy) {
        currentFilter = filter
        cartContent = cartContent.sorted(by: CartFilter.filter[currentFilter] ?? CartFilter.filterById)
        viewController?.updateCartTable()
    }
    
//MARK: - Object
    
    @objc private func didCartSorted(_ notification: Notification) {
        guard let orderService = orderService  else { return }
        
        let orderUnsorted = orderService.nftsStorage.compactMap { NftDataModel(nft: $0) }
        cartContent = orderUnsorted.sorted(by: CartFilter.filter[currentFilter] ?? CartFilter.filterById )
    }
}

//MARK: - Delegate

extension CartPresenter: CartDeleteDelegate {
    func updateCart(with items: [NftDataModel]) {
    }
}
