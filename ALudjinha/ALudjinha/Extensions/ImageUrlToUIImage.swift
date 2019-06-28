//
//  ImageUrlToUIImage.swift
//  ALudjinha
//
//  Created by Filipe on 27/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import Foundation
import UIKit

let imgCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadBannerWithUrl(bannerUrl: String, completion: @escaping (Result<BannerImageUrlResponse, ResponseError>) -> Void) {
        let url = URL(string: bannerUrl)
        image = nil
        if let imageFromCache = imgCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            let banner = BannerImageUrlResponse.init(bannerImage: self.image!)
            completion(Result.success(banner))
            return
        }
        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(ResponseError.rede))
                    return
            }
            let downloadedImage = UIImage(data: data)!
            imgCache.setObject(downloadedImage, forKey: url as AnyObject)
            let image = BannerImageUrlResponse.init(bannerImage: downloadedImage)
            completion(Result.success(image))
        }).resume()
    }
    
}
