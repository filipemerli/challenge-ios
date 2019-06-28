//
//  ResponseError.swift
//  ALudjinha
//
//  Created by Filipe on 27/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
enum ResponseError: Error {
    case rede
    case decoding
    
    var reason: String {
        switch self {
        case .rede:
            return "Ocorreu um erro ao receber os dados da rede. Verifique sua conexão e tente novamente mais tarde."
        case .decoding:
            return "Ocorreu um erro ao decodificar os dados da rede. Tente novamente mais tarde."
        }
    }
}
