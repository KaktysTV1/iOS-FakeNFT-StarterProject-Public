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
}

final class CartPresenter: CartPresenterProtocol {
   
    private weak var viewController: CartViewControllerProtocol?
    private var userDefaults = UserDefaults.standard
    private let filterKey = "filter"
    
    var cartContent: [NftDataModel] = []
    
    // Моковые данные для начальной загрузки
    var mock1 = NftDataModel(createdAt: "13-04-2024", name: "mock1", images: ["mock1"], rating: 5, description: "", price: 1.78, author: "", id: "1")
    var mock2 = NftDataModel(createdAt: "13-04-2024", name: "mock2", images: ["mock2"], rating: 2, description: "", price: 1.5, author: "", id: "2")
    
    init(viewController: CartViewControllerProtocol) {
        self.viewController = viewController
        cartContent = [mock1, mock2] // Инициализация корзины с моковыми данными
    }
    
    // Метод для обновления корзины
    func updateCartContent(with items: [NftDataModel]) {
        self.cartContent = items
        if cartContent.isEmpty {
            self.viewController?.showPlaceholder()
        } else {
            self.viewController?.updateCartTable()
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
    
    func getModel(indexPath: IndexPath) -> NftDataModel {
        return cartContent[indexPath.row]
    }
}
