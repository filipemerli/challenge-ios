//
//  HomeViewController.swift
//  ALudjinha
//
//  Created by Filipe Merli on 26/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Alerts {
    
    // MARK: - Properties

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: UIView!
    private var bannerViewModel: BannerViewModel!
    private var categsViewModel: CategoriasViewModel!
    private var produtosViewModel: ProdutosViewModel!
    var numberOfScrolls = CGFloat(3)
    private let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    private var bannersImageView: [UIImageView] = []
    private var bannerActivityInd: [UIActivityIndicatorView] = []
    
    
    // MARK: - View Controller Delegates

    override func viewDidLoad() {
        super.viewDidLoad()
        bannerViewModel = BannerViewModel(delegate: self)
        categsViewModel = CategoriasViewModel(delegate: self)
        produtosViewModel = ProdutosViewModel(delegate: self)
        tableView.dataSource = self
        scrollView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.delegate = self
        bannerViewModel.fetchBanners()
        categsViewModel.fetchCategorias()
        produtosViewModel.fetchMaisVendidos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let navigationBar = self.navigationController?.navigationBar
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "logoNavbar")
        navigationBar?.topItem?.titleView = imageView
        preLoadBannersView()
        setUpScrollBanners()
        getDotsFeedback()
    }

    // MARK: - ViewController Privates Functions

    func preLoadBannersView() {
        self.scrollView.frame = CGRect(x: 0, y: 0, width: bannerView.frame.width, height: bannerView.frame.height)
        scrollView.contentSize = CGSize(width: (bannerView.frame.width * numberOfScrolls), height: bannerView.frame.height)
        let scrollViewWidth = bannerView.frame.width
        let scrollViewHeight = bannerView.frame.height
        for i in 0..<Int(numberOfScrolls) {
            let newBannerView = UIImageView(frame: CGRect(x: (scrollViewWidth * CGFloat(i)), y: 0, width: scrollViewWidth, height: scrollViewHeight))
            newBannerView.backgroundColor = .gray
            newBannerView.contentMode = .scaleToFill
            scrollView.addSubview(newBannerView)
            bannersImageView.insert(newBannerView, at: i)
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.style = .white
            activityIndicator.center = newBannerView.center
            activityIndicator.hidesWhenStopped = true
            scrollView.addSubview(activityIndicator)
            bannerActivityInd.insert(activityIndicator, at: i)
        }
    }
    
    private func setUpScrollBanners() {
        if (bannerViewModel.currentCount > 0) {
            for i in 0..<Int(numberOfScrolls) {
                bannersImageView[i].loadBannerWithUrl(bannerUrl: bannerViewModel.banner(at: i).urlImagem) { result in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.bannerActivityInd[i].stopAnimating()
                            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            self.displayAlert(with: "Alerta", message: error.reason, actions: [action])
                        }
                    case .success(let response):
                        DispatchQueue.main.async {
                            self.bannerActivityInd[i].stopAnimating()
                            self.bannersImageView[i].image = response.bannerImage
                        }
                    }
                }
            }
        } else {
            for i in 0..<Int(numberOfScrolls) {
                bannerActivityInd[i].startAnimating()
            }
            pageControl.currentPage = 0
        }
        
    }
    
    @IBAction private func moveToPage(_ sender: UIPageControl) {
        let page: Int? = sender.currentPage
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page ?? 0)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    private func getDotsFeedback() {
        let pageWidth = bannerView.frame.width
        let currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(currentPage)
    }
}

    // MARK: - UITableViewDataSource

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        getDotsFeedback()
    }
    
}

    // MARK: - UITableViewDataSource

extension HomeViewController: BannerViewModelDelegate {
    func fetchBannersCompleted() {
        setUpScrollBanners()
    }
    
    func fetchBannersFailed(with reason: String) {
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        displayAlert(with: "Alerta", message: "Falha ao carregar imagens da internet.", actions: [action])
    }
}

    // MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if produtosViewModel.maisVendidosCount > 0 {
            return produtosViewModel.maisVendidosCount
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MaisVendidosTableViewCell
        if produtosViewModel.maisVendidosCount > 0 {
            cell.setCell(with: produtosViewModel.maisVendidos(at: indexPath.row))
        } else{
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Mais Vendidos"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let produtoToPresent = produtosViewModel.maisVendidos(at: indexPath.item)
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

    // MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categsViewModel.currentCount > 0 {
            return categsViewModel.currentCount
        } else{
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CategoriasCollectionViewCell
        if categsViewModel.currentCount > 0 {
            cell.setCell(with: categsViewModel.categorias(at: indexPath.row))
        } else {
            cell.backgroundView?.backgroundColor = .blue
            cell.setCell(with: .none)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let produtosVC = storyboard?.instantiateViewController(withIdentifier: "produtosVC") as! TableViewController
        produtosVC.categTitle = "\(self.categsViewModel.categorias(at: indexPath.row).descricao)"
        collectionView.deselectItem(at: indexPath, animated: false)
        if let navVC = self.navigationController {
            navVC.pushViewController(produtosVC, animated: true)
        }else {
            let navVC = UINavigationController(rootViewController: produtosVC)
            present(navVC, animated: true, completion: nil)
        }
    }
    
}

    // MARK: - CategoriasViewModelDelegate

extension HomeViewController: CategoriasViewModelDelegate {
    func fetchCategsCompleted() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func fetchCategsFailed(with reason: String) {
        let title = "Alerta"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}

    // MARK: - ProdutosViewModelDelegate

extension HomeViewController: ProdutosViewModelDelegate {
    func fetchMaisVendidosCompleted() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchMaisVendidosFailed(with reason: String) {
        let title = "Alerta"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
    
    func fetchProdutosCompleted() {
        //
    }
    
    func fetchProdutosFailed(with reason: String) {
        //
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (2)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / 4
        return CGSize(width: widthPerItem, height: (widthPerItem))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
