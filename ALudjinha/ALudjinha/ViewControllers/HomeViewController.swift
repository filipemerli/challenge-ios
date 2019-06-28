//
//  HomeViewController.swift
//  ALudjinha
//
//  Created by Filipe Merli on 26/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Alerts {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: UIView!
    private var viewModel: BannerViewModel!
    var numberOfScrolls = CGFloat(3)
    private var bannersImageView: [UIImageView] = []
    private var bannerActivityInd: [UIActivityIndicatorView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BannerViewModel(delegate: self)
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        preLoadBannersView()
        viewModel.fetchBanners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let navigationBar = self.navigationController?.navigationBar
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "logoNavbar")
        navigationBar?.topItem?.titleView = imageView
        setUpScrollBanners()
        getDotsFeedback()
        viewModel.fetchBanners()
    }

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
    
    func setUpScrollBanners() {
        if (viewModel.currentCount > 0) {
            for i in 0..<Int(numberOfScrolls) {
                bannersImageView[i].loadBannerWithUrl(bannerUrl: viewModel.banner(at: i).urlImagem) { result in
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
    
    @IBAction func moveToPage(_ sender: UIPageControl) {
        let page: Int? = sender.currentPage
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page ?? 0)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    func getDotsFeedback() {
        let pageWidth = bannerView.frame.width
        let currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(currentPage)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        getDotsFeedback()
    }
    
}

extension HomeViewController: BannerViewModelDelegate {
    func fetchCompleted() {
        setUpScrollBanners()
    }
    
    func fetchFailed(with reason: String) {
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        displayAlert(with: "Alerta", message: "Falha ao carregar imagens da internet.", actions: [action])
    }
}

extension HomeViewController: UITableViewDelegate {
    //tableView.
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = "Teste"
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        cell.backgroundView?.backgroundColor = .blue
        return cell
    }
    
    
}
