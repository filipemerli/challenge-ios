//
//  PostProdutoViewModel.swift
//  ALudjinha
//
//  Created by Filipe Merli on 29/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation


protocol PostProdutoViewModelDelegate: class {
    func postProdutoCompleted()
    func postProdutoFailed(with reason: String)
}

final class PostProdutoViewModel {
    private weak var delegate: PostProdutoViewModelDelegate?
    private var isFetching = false
    var idToPost = Int()
    
    let client = ALodjinhaAPIClient()
    
    init(delegate: PostProdutoViewModelDelegate) {
        self.delegate = delegate
    }
    
    func postProduto() {
        guard !isFetching else {
            return
        }
        isFetching = true
        client.postProduto(id: idToPost) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetching = false
                    self.delegate?.postProdutoFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.isFetching = false
                    self.delegate?.postProdutoCompleted()
                }
            }
        }
    }

    
}




