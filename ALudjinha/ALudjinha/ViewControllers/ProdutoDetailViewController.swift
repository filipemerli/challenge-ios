//
//  ProdutoDetailViewController.swift
//  ALudjinha
//
//  Created by Filipe on 28/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import UIKit

class ProdutoDetailViewController: UIViewController, Alerts {
    
    // MARK: - Properties
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var descricaoTextView: UITextView!
    @IBOutlet weak var precoPorLabel: UILabel!
    @IBOutlet weak var precoDeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var produtoImageView: UIImageView!
    @IBOutlet weak var reservarButton: UIButton!
    public var produto: Produto!
    private var postProdutoViewModel: PostProdutoViewModel!
    let activityInd = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        postProdutoViewModel = PostProdutoViewModel(delegate: self)
        activityIndicator.hidesWhenStopped = true
        precoDeLabel.font = UIFont(name: "bptypewritestrikethrough", size: 12)
        configView()
    }
    
    func configView() {
        activityInd.style = .white
        activityInd.hidesWhenStopped = true
        reservarButton.clipsToBounds = false
        reservarButton.layer.cornerRadius = 10
        titleLabel.text = produto.nome
        descricaoTextView.text = produto.descricao
        precoDeLabel.text = String(format: "De: %.2f", produto.precoDe)
        precoPorLabel.text = String(format: "Por %.2f", produto.precoPor)
        produtoImageView.loadCategWithUrl(categUrl: produto.urlImagem) { result in
            switch result {
            case .failure( _):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.produtoImageView.image = #imageLiteral(resourceName: "placeholder")
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.produtoImageView.image = response.categoriaImage
                }
            }
        }
    }
    
    @IBAction func reservarPress(_ sender: Any) {
        view.addSubview(activityInd)
        activityInd.center = reservarButton.center
        activityInd.startAnimating()
        reservarButton.isEnabled = false
        postProdutoViewModel.idToPost = produto.id
        postProdutoViewModel.postProduto()
        
    }
    
}

extension ProdutoDetailViewController: PostProdutoViewModelDelegate {
    func postProdutoCompleted() {
        DispatchQueue.main.async {
            self.activityInd.stopAnimating()
            self.reservarButton.isEnabled = true
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.displayAlert(with: "Sucesso", message: "Reserva feita!", actions: [action])
        }
    }
    
    func postProdutoFailed(with reason: String) {
        DispatchQueue.main.async {
            self.activityInd.stopAnimating()
            self.reservarButton.isEnabled = true
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.displayAlert(with: "Alerta", message: "Erro ao fazer reserva!", actions: [action])
        }
    }
    
    
}
