//
//  ProdutosViewModel.swift
//  ALudjinha
//
//  Created by Filipe on 28/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation

protocol ProdutosViewModelDelegate: class {
    func fetchMaisVendidosCompleted()
    func fetchMaisVendidosFailed(with reason: String)
    func fetchProdutosCompleted()
    func fetchProdutosFailed(with reason: String)
    
}

final class ProdutosViewModel {
    private weak var delegate: ProdutosViewModelDelegate?
    private var produtos: [Produto] = []
    private var maisVendidos: [Produto] = []
    private var isFetching = false
    
    let client = ALodjinhaAPIClient()
    
    init(delegate: ProdutosViewModelDelegate) {
        self.delegate = delegate
    }
    
    var currentCount: Int {
        return produtos.count
    }
    
    var maisVendidosCount: Int {
        return maisVendidos.count
    }
    
    func produto(at index: Int) -> Produto {
        return produtos[index]
    }
    
    func maisVendidos(at index: Int) -> Produto {
        return maisVendidos[index]
    }
    
    func fetchMaisVendidos() {
        guard !isFetching else {
            return
        }
        isFetching = true
        client.fetchProdutosMaisVendidos() { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetching = false
                    self.delegate?.fetchMaisVendidosFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.maisVendidos.append(contentsOf: response.produtos)
                    self.isFetching = false
                    self.delegate?.fetchMaisVendidosCompleted()
                }
            }
        }
    }
    
    func fetchProdutos() {
        guard !isFetching else {
            return
        }
        isFetching = true
        client.fetchProdutos() { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetching = false
                    self.delegate?.fetchProdutosFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.produtos.append(contentsOf: response.produtos)
                    self.isFetching = false
                    self.delegate?.fetchProdutosCompleted()
                }
            }
        }
    }
    
}
