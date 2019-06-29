//
//  ALodjinhaAPICliente.swift
//  ALudjinha
//
//  Created by Filipe on 27/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation

final class ALodjinhaAPIClient {
    private lazy var corpoURL: URL = {
        return URL(string: "https://alodjinha.herokuapp.com/")!
    }()
    
    let session: URLSession
    let pathBanner = "banner"
    let pathCategoria = "categoria"
    let pathMaisVendidos = "produto/maisvendidos"
    let pathProdutos = "produto"
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchBanners(completion: @escaping (Result<BannerResponse, ResponseError>) -> Void) {
        let urlRequest = URLRequest(url: corpoURL.appendingPathComponent(pathBanner))
        session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(ResponseError.rede))
                    return
            }
            guard let decodedResponse = try? JSONDecoder().decode(BannerResponse.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            completion(Result.success(decodedResponse))
        }).resume()
    }
    
    func fetchCategorias(completion: @escaping (Result<CategoriaResponse, ResponseError>) -> Void) {
        let urlRequest = URLRequest(url: corpoURL.appendingPathComponent(pathCategoria))
        session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(ResponseError.rede))
                    return
            }
            guard let decodedResponse = try? JSONDecoder().decode(CategoriaResponse.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            completion(Result.success(decodedResponse))
        }).resume()
    }
    
    func fetchProdutosMaisVendidos(completion: @escaping (Result<ProdutosResponse, ResponseError>) -> Void) {
        let urlRequest = URLRequest(url: corpoURL.appendingPathComponent(pathMaisVendidos))
        session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(ResponseError.rede))
                    return
            }
            guard let decodedResponse = try? JSONDecoder().decode(ProdutosResponse.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            completion(Result.success(decodedResponse))
        }).resume()
    }
    
    func fetchProdutos(completion: @escaping (Result<ProdutosResponse, ResponseError>) -> Void) {
        let urlRequest = URLRequest(url: corpoURL.appendingPathComponent(pathProdutos))
        session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(ResponseError.rede))
                    return
            }
            guard let decodedResponse = try? JSONDecoder().decode(ProdutosResponse.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            completion(Result.success(decodedResponse))
        }).resume()
    }
    
    func postProduto(id: Int, completion: @escaping (Result<PostProdutoResponse, ResponseError>) -> Void) {
        let produtoId = "\(pathProdutos)/\(id)"
        var urlRequest = URLRequest(url: corpoURL.appendingPathComponent(produtoId))
        urlRequest.httpMethod = "POST"
        session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(ResponseError.rede))
                    return
            }
            guard let decodedResponse = try? JSONDecoder().decode(PostProdutoResponse.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            completion(Result.success(decodedResponse))
        }).resume()
    }
    
}
