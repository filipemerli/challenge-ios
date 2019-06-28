//
//  BannerResponse.swift
//  ALudjinha
//
//  Created by Filipe on 27/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
struct BannerResponse: Decodable {
    let banner: [Banner]
    
    enum CodingKeys: String, CodingKey {
        case banner = "data"
    }
}
