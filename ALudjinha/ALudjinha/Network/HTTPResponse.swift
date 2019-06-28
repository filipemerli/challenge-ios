//
//  HTTPResponse.swift
//  ALudjinha
//
//  Created by Filipe on 27/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
