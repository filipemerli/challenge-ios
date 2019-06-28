//
//  Categoria.swift
//  ALudjinha
//
//  Created by Filipe on 28/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
struct Categoria: Decodable {
    let descricao: String
    let id: Int
    let urlImagem: String
    
    enum CodingKeys: String, CodingKey {
        case id, descricao, urlImagem
    }
    
    init(descricao: String, id: Int, urlImagem: String) {
        self.descricao = descricao
        self.id = id
        self.urlImagem = urlImagem
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let descricao = try container.decode(String.self, forKey: .descricao)
        let id = try container.decode(Int.self, forKey: .id)
        let urlImagem = try container.decode(String.self, forKey: .urlImagem)
        self.init(descricao: descricao, id: id, urlImagem: urlImagem)
    }
    
}
