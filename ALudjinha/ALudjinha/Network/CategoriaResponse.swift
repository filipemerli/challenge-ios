//
//  CategoriaResponse.swift
//  ALudjinha
//
//  Created by Filipe on 28/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
struct CategoriaResponse: Decodable {
    let categoria: [Categoria]
    
    enum CodingKeys: String, CodingKey {
        case categoria = "data"
    }
}
