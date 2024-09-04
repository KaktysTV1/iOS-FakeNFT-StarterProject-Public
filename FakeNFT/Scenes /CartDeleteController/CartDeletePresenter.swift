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
    
    weak var delegate: CartDeleteDelegate?
    private weak var view: CartDeleteControllerProtocol?
    private var orderService: OrderService?
    private var nftIdForDelete: String
    private (set) var nftImage: UIImage
    
    var cart: [NftDataModel]
    private var cartPresenter: CartPresenterProtocol?
    
    init(viewController: CartDeleteControllerProtocol, orderService: OrderService, nftIdForDelete: String, nftImage: UIImage, cart: [NftDataModel]) {
        self.orderService = orderService
        self.nftIdForDelete = nftIdForDelete
        self.nftImage = nftImage
        self.cart = cart
    }

    func deleteNftFromCart(completion: @escaping (Result<[String], Error>) -> Void) {
        view?.startLoadIndicator()

        if let index = cart.firstIndex(where: { $0.id == nftIdForDelete }) {
            cart.remove(at: index)
            view?.stopLoadIndicator()
            completion(.success(cart.map { $0.id }))

            delegate?.updateCart(with: cart)
        } else {
            view?.stopLoadIndicator()
            let error = NSError(domain: "com.yourapp.cart", code: 404, userInfo: [NSLocalizedDescriptionKey: "Товар не найден в корзине"])
            view?.showNetworkError(message: "\(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
}
