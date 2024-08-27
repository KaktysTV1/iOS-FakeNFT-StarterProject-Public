//
//  NftDataModel.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 27.08.2024.
//

import Foundation

struct NftDataModel: Decodable {
    var createdAt: String
    var name: String
    var images: [String]
    var rating: Int
    var description: String
    var price: Float
    var author: String
    var id: String

}
