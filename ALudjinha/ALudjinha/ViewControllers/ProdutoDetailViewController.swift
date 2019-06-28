//
//  ProdutoDetailViewController.swift
//  ALudjinha
//
//  Created by Filipe on 28/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import UIKit

class ProdutoDetailViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var descricaoTextView: UITextView!
    @IBOutlet weak var precoPorLabel: UILabel!
    @IBOutlet weak var precoDeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var produtoImageView: UIImageView!
    @IBOutlet weak var reservarButton: UIButton!
    public var produto: Produto!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(produto.descricao)
        activityIndicator.hidesWhenStopped = true
        configView()
    }
    
    func configView() {
        reservarButton.clipsToBounds = false
        reservarButton.layer.cornerRadius = 10
        titleLabel.text = produto.nome
        descricaoTextView.text = produto.descricao
        precoDeLabel.text = ("De: \(produto.precoDe)")
        precoPorLabel.text = String(format: "Por %.2f", produto.precoPor)
        produtoImageView.loadCategWithUrl(categUrl: produto.urlImagem) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.produtoImageView.image = #imageLiteral(resourceName: "placeholder")
                }
                debugPrint("Erro ao baixar imagem: \(error.reason)")
            case .success(let response):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.produtoImageView.image = response.categoriaImage
                }
            }
        }
    }
    
}
