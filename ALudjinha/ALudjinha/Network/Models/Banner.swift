//
//  Banner.swift
//  ALudjinha
//
//  Created by Filipe on 27/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
struct Banner: Decodable {
    let linkUrl: String
    let id: Int
    let urlImagem: String
    
    enum CodingKeys: String, CodingKey {
        case id, linkUrl, urlImagem
    }
    
    init(linkUrl: String, id: Int, urlImagem: String) {
        self.linkUrl = linkUrl
        self.id = id
        self.urlImagem = urlImagem
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let linkUrl = try container.decode(String.self, forKey: .linkUrl)
        let id = try container.decode(Int.self, forKey: .id)
        let urlImagem = try container.decode(String.self, forKey: .urlImagem)
        self.init(linkUrl: linkUrl, id: id, urlImagem: urlImagem)
    }
    
}
