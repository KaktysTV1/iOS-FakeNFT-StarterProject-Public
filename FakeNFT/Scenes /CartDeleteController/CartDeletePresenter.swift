//
//  CartDeletePresenter.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 27.08.2024.
//

import UIKit

protocol CartDeletePresenterProtocol {
    var nftImage: UIImage { get }
    func deleteNftFromCart(completion: @escaping (Result<[String], Error>) -> Void)
}

final class CartDeletePresenter: CartDeletePresenterProtocol {
    
    private weak var viewController: CartDeleteControllerProtocol?
    private var orderService: OrderService?
    private var nftIdForDelete: String
    private (set) var nftImage: UIImage
    
    var cart: [NftDataModel]
    private var cartPresenter: CartPresenterProtocol?
    
    init(viewController: CartDeleteControllerProtocol, orderService: OrderService, nftIdForDelete: String, nftImage: UIImage, cart: [NftDataModel], cartPresenter: CartPresenterProtocol?) {
        self.viewController = viewController
        self.orderService = orderService
        self.nftIdForDelete = nftIdForDelete
        self.nftImage = nftImage
        self.cart = cart
        self.cartPresenter = cartPresenter
    }

    func deleteNftFromCart(completion: @escaping (Result<[String], Error>) -> Void) {
        viewController?.startLoadIndicator()

        if let index = cart.firstIndex(where: { $0.id == nftIdForDelete }) {
            cart.remove(at: index)
            viewController?.stopLoadIndicator()
            completion(.success(cart.map { $0.id }))

            // Обновление корзины
            cartPresenter?.updateCartContent(with: cart)
        } else {
            viewController?.stopLoadIndicator()
            let error = NSError(domain: "com.yourapp.cart", code: 404, userInfo: [NSLocalizedDescriptionKey: "Товар не найден в корзине"])
            viewController?.showNetworkError(message: "\(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}
