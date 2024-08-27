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
    private var nftIdForDelete: String
    private (set) var nftImage: UIImage
    
    init(viewController: CartDeleteControllerProtocol, nftIdForDelete: String, nftImage: UIImage) {
        self.viewController = viewController
        self.nftIdForDelete = nftIdForDelete
        self.nftImage = nftImage
    }
    
    func deleteNftFromCart(completion: @escaping (Result<[String], Error>) -> Void) {
        viewController?.startLoadIndicator()
        //TODO: реализовать действительное удаление
    }
}

