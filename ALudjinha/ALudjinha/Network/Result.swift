//
//  Result.swift
//  ALudjinha
//
//  Created by Filipe on 27/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}
