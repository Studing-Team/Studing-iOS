//
//  AFImageView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import UIKit

import Alamofire

/// `AFImageView`는 이미지를 비동기적으로 로드하고 캐싱하는 커스텀 UIImageView 클래스입니다.
/// Alamofire를 사용하여 네트워크 이미지를 로드하며, 로딩 상태를 표시하고 이미지 다운샘플링 및 캐싱 기능을 제공합니다.
///
/// - Features:
///   - 비동기 이미지 로딩
///   - 로딩 중 인디케이터 표시
///   - 이미지 캐싱
///   - 다운샘플링을 통한 메모리 최적화
///   - 페이드 인 애니메이션
///
final class AFImageView: UIImageView {
    
    /// 이미지 로딩 중임을 표시하는 액티비티 인디케이터
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    /// 현재 로드 중인 이미지의 URL
    private var imageURL: URL?
    
    /// 현재 진행 중인 이미지 요청
    private var request: DataRequest?
    
    init() {
        super.init(frame: .zero)
        setupActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupActivityIndicator()
    }
    
    /// 액티비티 인디케이터 설정 및 레이아웃 구성
    private func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    /// 이미지를 설정하는 메인 메서드
    /// - Parameters:
    ///   - urlString: 이미지 URL 문자열
    ///   - type: 이미지 타입 (로고, 포스트 등)
    ///   - forceReload: 캐시 무시하고 강제로 새로 로드할지 여부
    func setImage(_ urlString: String?, type: ImageType, forceReload: Bool = false) {
        request?.cancel()
        
        // URL 유효성 검사 및 기본 이미지 설정
        guard let urlString = urlString, !urlString.isEmpty,
              let url = URL(string: urlString) else {
            print("❌ URL empty or invalid, setting default image")
            
            switch type {
            case .associationLogo:
                self.image = UIImage(resource: .unAssociation)
            case .postImage:
                self.image = UIImage(resource: .defaultPost)
            case .postSmallImage:
                self.image = UIImage(resource: .defaultPostSmall)
            case .largeImage:
                self.image = UIImage(resource: .defaultPost)
            }
            
            return
        }
        
        // URL이 같고 강제 새로고침이 아니면 스킵
        if !forceReload && imageURL == url {
            return
        }
        imageURL = url
        
        // 캐시 확인 (강제 새로고침이 아닐 경우)
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
                self.image = UIImage(resource: .defaultPost)
            }
        }
    }
    
    // 이미지 로딩 취소
    func cancelImageLoad() {
        request?.cancel()
        activityIndicator.stopAnimating()
    }
}
