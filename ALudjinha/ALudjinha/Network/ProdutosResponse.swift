//
//  ProdutosResponse.swift
//  ALudjinha
//
//  Created by Filipe Merli on 29/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
struct ProdutosResponse: Decodable {
    let produtos: [Produto]
    
    enum CodingKeys: String, CodingKey {
        case produtos = "data"
    }
}
