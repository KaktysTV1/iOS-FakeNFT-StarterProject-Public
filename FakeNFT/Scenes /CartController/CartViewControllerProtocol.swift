//
//  CartViewControllerProtocol.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 27.08.2024.
//

import Foundation

protocol CartViewControllerProtocol: AnyObject {
    func showPlaceholder()
    func updateCartTable()
    func startLoadIndicator()
    func stopLoadIndicator()
}
