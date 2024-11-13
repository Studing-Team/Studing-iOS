//
//  ImageCacheManager.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation
import UIKit

enum ImageType {
    case associationLogo
    case postImage
}

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        // 캐시 용량 설정
        cache.countLimit = 100 // 최대 이미지 개수
        cache.totalCostLimit = 1024 * 1024 * 100 // 100MB
    }
    
    func image(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func removeImage(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
