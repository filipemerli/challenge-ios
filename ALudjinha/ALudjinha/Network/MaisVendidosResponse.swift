//
//  MaisVendidosResponse.swift
//  ALudjinha
//
//  Created by Filipe on 28/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
struct MaisVendidosResponse: Decodable {
    let produtos: [Produto]
    
    enum CodingKeys: String, CodingKey {
        case produtos = "data"
    }
}
