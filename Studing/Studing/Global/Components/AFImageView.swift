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
    
    init() {
        super.init(frame: .zero)
        setupActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setImage(_ urlString: String?, type: ImageType, forceReload: Bool = false) {
        request?.cancel()
        
        guard let urlString = urlString, !urlString.isEmpty,
              let url = URL(string: urlString) else {
            print("❌ URL empty or invalid, setting default image")
            self.image = type == .associationLogo ? UIImage(resource: .unAssociation) : UIImage(resource: .dump)
            return
        }
        
        // forceReload가 true이거나 URL이 다를 때만 이미지 로드
        if !forceReload && imageURL == url {
            return
        }
        imageURL = url
        
        // 캐시 확인 (forceReload가 true면 캐시 무시)
        if !forceReload, let cachedImage = ImageCacheManager.shared.data(for: urlString) {
            self.image = UIImage(data: cachedImage)
            print("🔄 Cached Image")
            return
        }
        
        activityIndicator.startAnimating()
        print("🚀 Starting image request for URL: \(url)")
        
        request = AF.request(url, method: .get).responseData { [weak self] response in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            
            switch response.result {
            case .success(let data):
                
                guard let downsampledData = UIImage.downsample(imageData: data, to: type.imageSize, scale: UIScreen.main.scale) else {
                    return
                }
                
                // 캐시에 저장
                ImageCacheManager.shared.setData(downsampledData, for: urlString)
                print("✅ ImageData save successfully")
                
                self.alpha = 0
                self.image = UIImage(data: downsampledData)
                
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 1
                }
                
            case .failure(let error):
                print("❌ Error loading image: \(error.localizedDescription)")
                self.image = UIImage(resource: .dump)
            }
        }
    }
    
    // 이미지 로딩 취소
    func cancelImageLoad() {
        request?.cancel()
        activityIndicator.stopAnimating()
    }
}
