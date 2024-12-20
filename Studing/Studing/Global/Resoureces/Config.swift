//
//  Config.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let naverMap = "NAVER_MAP_KEY"
            static let amplitude = "AMPLITUDE_KEY"
        }
        
        enum Keychain: String {
            case accessToken = "ACCESS_TOKEN_KEY"
            case refreshToken = "REFRESH_TOKEN_KEY"
            case fcmToken = "FCM_TOKEN_KEY"
            case signupInfo = "SIGNUP_INFO_KEY"
            case userAuthState = "USER_AUTH_STATE_KEY"
            case userInfo = "USER_INFO_KEY"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found !!!")
        }
        return dict
    }()
}

extension Config {
    static let baseURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("⛔️BASE_URL is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let accessTokenKey: String = {
        guard let key = Config.infoDictionary[Keys.Keychain.accessToken.rawValue] as? String else {
            fatalError("⛔️ACCESS_TOKEN_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let refreshTokenKey: String = {
        guard let key = Config.infoDictionary[Keys.Keychain.refreshToken.rawValue] as? String else {
            fatalError("⛔️REFRESH_TOKEN_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let fcmTokenKey: String = {
        guard let key = Config.infoDictionary[Keys.Keychain.fcmToken.rawValue] as? String else {
            fatalError("⛔️FCM_TOKEN_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let signupInfoKey: String = {
        guard let key = Config.infoDictionary[Keys.Keychain.signupInfo.rawValue] as? String else {
            fatalError("⛔️SIGNUP_INFO_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let userAuthStateKey: String = {
        guard let key = Config.infoDictionary[Keys.Keychain.userAuthState.rawValue] as? String else {
            fatalError("⛔️USER_AUTH_STATE_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let userInfoKey: String = {
        guard let key = Config.infoDictionary[Keys.Keychain.userAuthState.rawValue] as? String else {
            fatalError("⛔️USER_INFO_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let naverMapKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.naverMap] as? String else {
            fatalError("⛔️NAVER_MAP_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let amplitudeKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.amplitude] as? String else {
            fatalError("⛔️AMPLITUDE_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
}

