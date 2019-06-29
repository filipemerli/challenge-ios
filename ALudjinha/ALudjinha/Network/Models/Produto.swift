//
//  Produto.swift
//  ALudjinha
//
//  Created by Filipe on 28/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
struct Produto {
    let descricao: String
    let id: Int
    let urlImagem: String
    let nome: String
    let precoDe: Double
    let precoPor: Double
    let categoria: Categoria
    
    enum CodingKeys: String, CodingKey {
        case descricao, id, urlImagem, nome, precoDe, precoPor, categoria
    }
    
    init(descricao: String, id: Int, urlImagem: String, nome: String, precoDe: Double, precoPor: Double, categoria: Categoria) {
        self.descricao = descricao
        self.id = id
        self.urlImagem = urlImagem
        self.nome = nome
        self.precoDe = precoDe
        self.precoPor = precoPor
        self.categoria = categoria
    }
}

extension Produto: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let descricao = try container.decode(String.self, forKey: .descricao)
        let id = try container.decode(Int.self, forKey: .id)
        let urlImagem = try container.decode(String.self, forKey: .urlImagem)
        let nome = try container.decode(String.self, forKey: .nome)
        let precoDe = try container.decode(Double.self, forKey: .precoDe)
        let precoPor = try container.decode(Double.self, forKey: .precoPor)
        let categoria = try container.decode(Categoria.self, forKey: .categoria)
        self.init(descricao: descricao, id: id, urlImagem: urlImagem, nome: nome, precoDe: precoDe, precoPor: precoPor, categoria: categoria)
    }
    
}

extension Produto: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(descricao, forKey: .descricao)
        try container.encode(id, forKey: .id)
        try container.encode(urlImagem, forKey: .urlImagem)
        try container.encode(nome, forKey: .nome)
        try container.encode(precoDe, forKey: .precoDe)
        try container.encode(precoPor, forKey: .precoPor)
        try container.encode(categoria, forKey: .categoria)
    }
}
