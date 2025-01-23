//
//  LoadImageManager.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/22/25.
//

import UIKit

import Alamofire

final class LoadImageManager {
    
    static let shared = LoadImageManager()
    
    private var request: DataRequest?
    
    private init() {}
    
    func loadImage(url: String, type: ImageType) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            AF.request(url, method: .get).responseData { response in
                switch response.result {
                case .success(let data):
                    guard let downsampledData = UIImage.downsample(imageData: data, to: type.imageSize, scale: UIScreen.main.scale) else {
                        continuation.resume(returning: nil)
                        return
                    }
                    
                    // 캐시에 저장
                    ImageCacheManager.shared.setData(downsampledData, for: url)
                    print("✅ ImageData save successfully")
                    
                    let image = UIImage(data: downsampledData)
                    continuation.resume(returning: image)
                    
                case .failure(let error):
                    print("❌ Error loading image: \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
