//
//  PayDataModel.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 05.09.2024.
//

import Foundation

struct PayDataModel: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
