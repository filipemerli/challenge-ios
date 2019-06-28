//
//  CategoriasViewModel.swift
//  ALudjinha
//
//  Created by Filipe on 28/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation

protocol CategoriasViewModelDelegate: class {
    func fetchCategsCompleted()
    func fetchCategsFailed(with reason: String)
}

final class CategoriasViewModel {
    private weak var delegate: CategoriasViewModelDelegate?
    private var categorias: [Categoria] = []
    private var isFetching = false
    
    let client = ALodjinhaAPIClient()
    
    init(delegate: CategoriasViewModelDelegate) {
        self.delegate = delegate
    }
    
    var currentCount: Int {
        return categorias.count
    }
    
    func categorias(at index: Int) -> Categoria {
        return categorias[index]
    }
    
    func fetchCategorias() {
        guard !isFetching else {
            return
        }
        isFetching = true
        client.fetchCategorias() { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetching = false
                    self.delegate?.fetchCategsFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.categorias.append(contentsOf: response.categoria)
                    self.isFetching = false
                    self.delegate?.fetchCategsCompleted()
                }
            }
        }
    }
    
}
