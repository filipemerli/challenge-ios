//
//  TableViewController.swift
//  ALudjinha
//
//  Created by Filipe Merli on 29/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var produtosViewModel: ProdutosViewModel!
    var categTitle = ""

    // MARK: - View Controller Delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
        produtosViewModel = ProdutosViewModel(delegate: self)
        produtosViewModel.fetchProdutos()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navTopItem = self.navigationController!.navigationBar.topItem {
            navTopItem.titleView = .none
            navTopItem.title = categTitle
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if produtosViewModel.currentCount > 0 {
            if produtosViewModel.currentCount > 20 {
                return 20
            } else {
                return produtosViewModel.currentCount
            }
        } else{
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MaisVendidosTableViewCell
        if produtosViewModel.currentCount > 0 {
            cell.setCell(with: produtosViewModel.produto(at: indexPath.row))
        } else{
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let produtoToPresent = produtosViewModel.produto(at: indexPath.item)
        let produtoDetailVC = storyboard?.instantiateViewController(withIdentifier: "produtoDetailVC") as! ProdutoDetailViewController
        produtoDetailVC.produto = produtoToPresent
        tableView.deselectRow(at: indexPath, animated: false)
        if let navVC = self.navigationController {
            navVC.pushViewController(produtoDetailVC, animated: true)
        }else {
            let navVC = UINavigationController(rootViewController: produtoDetailVC)
            present(navVC, animated: true, completion: nil)
        }
    }
    
}

    // MARK: - ProdutosViewModel Delegates

extension TableViewController: ProdutosViewModelDelegate {
    func fetchMaisVendidosCompleted() {
        //
    }
    
    func fetchMaisVendidosFailed(with reason: String) {
        //
    }
    
    func fetchProdutosCompleted() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchProdutosFailed(with reason: String) {
        //
    }
    
    
}
