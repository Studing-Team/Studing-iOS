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
    
    var imageSize: CGSize {
        switch self {
        case .associationLogo:
            return CGSize(width: SizeLiterals.Screen.screenWidth * 55 / 375, height: SizeLiterals.Screen.screenHeight * 55 / 812)
        case .postImage:
            return CGSize(width: SizeLiterals.Screen.screenWidth * 335 / 375, height: SizeLiterals.Screen.screenHeight * 335 / 812)
        }
    }
}

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, NSData>()
    
    private init() {
        // 캐시 용량 설정
        cache.countLimit = 100 // 최대 데이터 개수
        cache.totalCostLimit = 1024 * 1024 * 100 // 100MB
    }
    
    // Data 가져오기
    func data(for key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }
    
    // Data 저장
    func setData(_ data: Data, for key: String) {
        cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    // Data 삭제
    func removeData(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    // 모든 캐시 삭제
    func clearCache() {
        cache.removeAllObjects()
    }
}
