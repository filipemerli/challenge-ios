//
//  PostProdutoResponse.swift
//  ALudjinha
//
//  Created by Filipe Merli on 29/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
struct PostProdutoResponse: Decodable {
    let produto: String
    
    enum CodingKeys: String, CodingKey {
        case produto = "result"
    }
}
