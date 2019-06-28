//
//  BannerViewModel.swift
//  ALudjinha
//
//  Created by Filipe on 27/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
import UIKit

protocol BannerViewModelDelegate: class {
    func fetchCompleted()
    func fetchFailed(with reason: String)
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
    
    func bannersUrls() -> [String]? {
        var finalString: [String] = []
        for banner in self.banners {
            finalString.append(banner.urlImagem)
        }
        return finalString
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
                    self.delegate?.fetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    print("BANNERS URL = \(response.banner)")
                    self.banners.append(contentsOf: response.banner)
                    self.isFetching = false
                    self.delegate?.fetchCompleted()
                }
            }
        }
    }
    
}
