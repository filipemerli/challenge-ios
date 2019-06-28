//
//  CategoriasCollectionViewCell.swift
//  ALudjinha
//
//  Created by Filipe on 28/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import UIKit

class CategoriasCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setCell(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
    }
    
    //MARK: Configure cell
    func setCell(with categ: Categoria?) {
        if let categ = categ {
            titleLabel?.text = categ.descricao
            imageView.loadCategWithUrl(categUrl: categ.urlImagem) { result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.imageView.image = #imageLiteral(resourceName: "placeholder")
                    }
                    debugPrint("Erro ao baixar imagem: \(error.reason)")
                case .success(let response):
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.imageView.image = response.categoriaImage
                    }
                }
            }
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    
}
