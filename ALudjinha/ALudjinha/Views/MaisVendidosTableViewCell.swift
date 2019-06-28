//
//  MaisVendidosTableViewCell.swift
//  ALudjinha
//
//  Created by Filipe on 28/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import UIKit

class MaisVendidosTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var precoDeLabel: UILabel!
    @IBOutlet weak var precoPorLabel: UILabel!
    @IBOutlet weak var produtoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        produtoImageView.image = #imageLiteral(resourceName: "placeholder")
        activityIndicator.hidesWhenStopped = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setCell(with: .none)
    }
    

    func setCell(with produto: Produto?) {
        if let produto = produto {
            titleLabel?.text = produto.nome
            precoDeLabel.text = ("De: \(produto.precoDe)")
            precoPorLabel.text = String(format: "Por %.2f", produto.precoPor)
            activityIndicator.startAnimating()
            produtoImageView.loadCategWithUrl(categUrl: produto.urlImagem) { result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
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

}

