//
//  OrderDataModel.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 28.08.2024.
//

import Foundation

struct OrderDataModel: Decodable {
    var nfts: [String]
    var id: String
}
