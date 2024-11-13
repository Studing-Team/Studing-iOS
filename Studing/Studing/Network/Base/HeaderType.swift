//
//  HeaderType.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Alamofire

/// API 요청에 사용되는 HTTP 헤더 타입
///
/// 각 케이스별 포함되는 헤더:
/// - defaultHeader:
///     - "Content-Type": "application/json"
///
/// - accessTokenHeader:
///     - "Content-Type": "application/json"
///     - "Authorization": "Bearer {access_token}"
///
/// - refreshTokenHeader:
///     - "Content-Type": "application/json"
///     - "Authorization": "Bearer {refresh_token}"
///
/// ## 사용 예시:
/// ```swift
/// var headerType: HeaderType {
///     switch self {
///     case .login, .register:
///         return .defaultHeader    // 인증이 필요없는 API
///     case .refreshToken:
///         return .refreshTokenHeader    // 토큰 갱신 API
///     default:
///         return .accessTokenHeader    // 일반적인 인증 필요 API
///     }
/// }
/// ```
enum HeaderType {
    case defaultHeader
    case accessTokenHeader
    case refreshTokenHeader
    
    var headers: HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        switch self {
        case .accessTokenHeader:
            if let token = KeychainManager.shared.load(key: .accessToken) {
                headers["Authorization"] = "Bearer \(token)"
            }
            
        case .refreshTokenHeader:
            if let token = KeychainManager.shared.load(key: .refreshToken) {
                headers["Authorization"] = "Bearer \(token)"
            }
            
        case .defaultHeader:
            break
        }
        
        return headers
    }
}
