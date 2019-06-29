//
//  Categoria.swift
//  ALudjinha
//
//  Created by Filipe on 28/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
struct Categoria {
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
    
}

extension Categoria: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let descricao = try container.decode(String.self, forKey: .descricao)
        let id = try container.decode(Int.self, forKey: .id)
        let urlImagem = try container.decode(String.self, forKey: .urlImagem)
        self.init(descricao: descricao, id: id, urlImagem: urlImagem)
    }
}

extension Categoria: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(descricao, forKey: .descricao)
        try container.encode(id, forKey: .id)
        try container.encode(urlImagem, forKey: .urlImagem)
    }
}
