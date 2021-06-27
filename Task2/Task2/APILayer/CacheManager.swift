//
//  CacheManager.swift
//  Task2
//
//  Created by mehboob Alam.
//

import UIKit

public class CacheManager {
    public static let shared = CacheManager()
    private let cache: NSCache<NSString, UIImage>
    private init () {
        cache = NSCache()
        cache.countLimit = 75
        cache.totalCostLimit = 25 * 1024 * 1024 // 25 MB macx image memory for cache.
    }

    public func set(image: UIImage, for url: NSString) {
        cache.setObject(image, forKey: url)
    }

    public func getImage(for url: String) -> UIImage? {
        cache.object(forKey: url as NSString)
    }
}
