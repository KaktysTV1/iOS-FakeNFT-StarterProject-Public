//
//  CartFilter.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 07.09.2024.
//

import Foundation

struct CartFilter {
    
    typealias FilterClosure = (NftDataModel, NftDataModel) -> Bool
    
    enum FilterBy: Int {
        case id
        case price
        case rating
        case title
    }
    
    static var filterById: FilterClosure = { first, second in
        first.id < second.id
    }
    
    static var filterByPrice: FilterClosure = { first, second in
        return first.price < second.price
    }
    
    static var filterByRating: FilterClosure = { first, second in
        return first.rating > second.rating
    }
    
    static var filterByTitle: FilterClosure = { first, second in
        return first.name < second.name
    }
    
    static let filter: [FilterBy:FilterClosure] = [.id: filterById, .price: filterByPrice, .rating: filterByRating, .title: filterByTitle]
}


