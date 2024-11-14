//
//  KeychainManager.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/10/24.
//

import Foundation

// MARK: - KeychainKey

/// 키체인에 저장될 데이터의 키 값을 정의하는 열거형
///
/// 각 case는 저장할 데이터의 종류를 나타내며, Info.plist에 정의된 실제 키 값과 매핑됩니다.
/// - Note: value 프로퍼티를 통해 Info.plist에 정의된 실제 키 값을 가져옵니다.
///
/// ```swift
/// // KeychainKey 사용 예시
/// let accessTokenKey = KeychainKey.accessToken
/// let refreshTokenKey = KeychainKey.refreshToken
///
/// // 실제 키 값 얻기
/// let actualKey = KeychainKey.accessToken.value
/// ```
enum KeychainKey: String {
    /// 액세스 토큰을 저장하기 위한 키
    case accessToken
    /// 리프레시 토큰을 저장하기 위한 키
    case refreshToken
    
    case fcmToken
    
    /// Info.plist에서 정의된 실제 키체인 키 값을 반환합니다.
        /// - Returns: Info.plist에 정의된 실제 키 문자열
    var value: String {
        switch self {
        case .accessToken:
            return Config.accessTokenKey
        case .refreshToken:
            return Config.refreshTokenKey
        case .fcmToken:
            return Config.fcmTokenKey
        }
    }
}

// MARK: - KeychainManager

/// 키체인 데이터를 안전하게 관리하기 위한 매니저 클래스
///
/// 이 클래스는 싱글톤 패턴을 사용하여 키체인 접근을 한 곳에서 관리합니다.
/// 토큰과 같은 민감한 데이터를 안전하게 저장, 조회, 삭제할 수 있는 메서드를 제공합니다.
///
/// ## 일반적인 사용 예시:
/// ```swift
/// // 토큰 저장
/// KeychainManager.shared.save(key: .accessToken, value: "eyJhbGciOiJ...")
///
/// // 토큰 조회
/// if let token = KeychainManager.shared.load(key: .accessToken) {
///     // 토큰 사용
///     print("Access Token: \(token)")
/// }
///
/// // 토큰 삭제
/// KeychainManager.shared.delete(key: .accessToken)
///
/// // 모든 토큰 삭제 (로그아웃, 회원탈퇴 시)
/// KeychainManager.shared.clearTokens()
/// ```
final class KeychainManager {
    /// 싱글톤 인스턴스
    static let shared = KeychainManager()
    
    /// 외부에서의 인스턴스 생성을 방지하기 위한 private 생성자
    private init() {}
    
    /// 키체인에 데이터를 저장하는 메서드
    /// - Parameters:
    ///   - key: 저장할 데이터의 키 (KeychainKey 타입)
    ///   - value: 저장할 값 (String 타입)
    /// - Note: 이미 같은 키로 저장된 데이터가 있다면 덮어씌웁니다.
    func save(key: KeychainKey, value: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: value.data(using: .utf8) as Any
        ]
        
        // 기존 데이터 삭제 후 새로운 데이터 저장
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
        
        print("KeyChain - \(key) 저장 완료")
    }
    
    /// 키체인에서 데이터를 조회하는 메서드
    /// - Parameter key: 조회할 데이터의 키 (KeychainKey 타입)
    /// - Returns: 저장된 문자열 값, 데이터가 없거나 오류 발생 시 nil 반환
    func load(key: KeychainKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                
                print("KeyChain - \(key) 불러오기 완료")
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
    
    /// 키체인에서 특정 키의 데이터를 삭제하는 메서드
    /// - Parameter key: 삭제할 데이터의 키 (KeychainKey 타입)
    func delete(key: KeychainKey) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    /// 모든 토큰 관련 데이터를 키체인에서 삭제하는 메서드
    /// - Note: 로그아웃 시 호출하여 모든 인증 관련 데이터를 삭제합니다.
    func clearTokens() {
        delete(key: .accessToken)
        delete(key: .refreshToken)
    }
}
