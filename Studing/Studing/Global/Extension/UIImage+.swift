//
//  UIImage+.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/29/24.
//

import UIKit

extension UIImage {
    static func downsample(imageData: Data, to pointSize: CGSize, scale: CGFloat, maxFileSize: Int = 1000000) -> Data? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions) else {
            return nil
        }
        
        // 최대 크기로 리샘플링
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        
        // 다운샘플링 후 파일 크기 확인
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        let image = UIImage(cgImage: downsampledImage)
        
        // 최초 JPEG 압축 (quality: 1.0)
        guard let jpegData = image.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        
        // 이미 파일 크기가 충분히 작다면 추가 압축 없이 반환
        if jpegData.count <= maxFileSize {
            print("✅ 이미지 리사이징 성공:", jpegData.count)
            return jpegData
        }
        
        // 1MB를 초과할 경우에만 추가 압축 시도
        var compression: CGFloat = 0.7  // 1.0에서 시작하지 않고 0.7에서 시작
        var compressedData = image.jpegData(compressionQuality: compression)
        
        while let data = compressedData, data.count > maxFileSize && compression > 0.1 {
            compression -= 0.1
            compressedData = image.jpegData(compressionQuality: compression)
        }
        
        guard let finalData = compressedData else { return nil }
        
        return finalData
    }
    
    func getImageBitSize() -> Int {
        if let imageData = self.pngData() {
            return imageData.count
        }
        return 0
    }
}
