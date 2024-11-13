//
//  AFImageView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import UIKit

import Alamofire

final class AFImageView: UIImageView {
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var imageURL: URL?
    private var request: DataRequest?
    
    func setImage(_ urlString: String?, type: ImageType) {
        request?.cancel()

        guard let urlString = urlString, !urlString.isEmpty,
              let url = URL(string: urlString) else {
            
            print("❌ URL empty or invalid, setting default image")
                  
            if type == .associationLogo {
                self.image = UIImage(resource: .allAssociation)
            } else {
                self.image = UIImage(resource: .dump)
            }
            
            return
        }
        
        if imageURL == url {
            return
        }
        imageURL = url
        
        // 캐시 확인
        if let cachedImage = ImageCacheManager.shared.image(for: urlString) {
            self.image = cachedImage
            print("🔄 Cached Image")
            return
        }
        
        activityIndicator.startAnimating()
        print("🚀 Starting image request")
        request = AF.request(url, method: .get).responseData { [weak self] response in
            guard let self = self else { return }
            print("이미지 로딩 중")
            self.activityIndicator.stopAnimating()
            
            switch response.result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    self.image = UIImage(resource: .dump)
                    return
                }
                
                // 캐시에 저장
                ImageCacheManager.shared.setImage(image, for: urlString)
                print("이미지 로딩 완료")
                
                self.alpha = 0
                self.image = image
                
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 1
                }
                
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
                self.image = UIImage(resource: .dump)
            }
        }
    }
}
