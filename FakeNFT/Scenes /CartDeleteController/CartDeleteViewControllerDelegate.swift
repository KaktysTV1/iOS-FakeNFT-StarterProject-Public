//
//  CartDeleteViewControllerProtocol.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 02.09.2024.
//

import Foundation

protocol CartDeleteDelegate: AnyObject {
    func updateCart(with items: [NftDataModel])
}
