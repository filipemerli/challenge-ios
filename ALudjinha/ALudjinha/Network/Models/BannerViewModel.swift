//
//  BannerViewModel.swift
//  ALudjinha
//
//  Created by Filipe on 27/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation

protocol BannerViewModelDelegate: class {
    func fetchBannersCompleted()
    func fetchBannersFailed(with reason: String)
}

final class BannerViewModel {
    private weak var delegate: BannerViewModelDelegate?
    private var banners: [Banner] = []
    private var isFetching = false
    
    let client = ALodjinhaAPIClient()
    
    init(delegate: BannerViewModelDelegate) {
        self.delegate = delegate
    }
    
    var currentCount: Int {
        return banners.count
    }
    
    func banner(at index: Int) -> Banner {
        return banners[index]
    }
    
    func fetchBanners() {
        guard !isFetching else {
            return
        }
        isFetching = true
        client.fetchBanners() { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetching = false
                    self.delegate?.fetchBannersFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.banners.append(contentsOf: response.banner)
                    self.isFetching = false
                    self.delegate?.fetchBannersCompleted()
                }
            }
        }
    }
    
}
