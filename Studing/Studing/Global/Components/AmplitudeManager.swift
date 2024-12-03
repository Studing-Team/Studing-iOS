//
//  AmplitudeManager.swift
//  Studing
//
//  Created by ParkJunHyuk on 12/2/24.
//

import Foundation
import AmplitudeSwift

final class AmplitudeManager {
    static let shared = AmplitudeManager()
    
    private let amplitude: Amplitude
    
    private init() {
        amplitude = Amplitude(
            configuration: Configuration(apiKey: Config.amplitudeKey)
        )
        
        guard let userData = KeychainManager.shared.loadData(key: .userInfo, type: UserInfo.self) else {
            print("유저 데이터 없음")
            
            return
        }
        amplitude.setUserId(userId: userData.identifier)
    }
    
    func trackEvent(_ eventName: String, properties: [String: Any]? = nil) {
        amplitude.track(
            eventType: eventName,
            eventProperties: properties
        )
        
        print("📤 Amplitude TrackEvent 발생:", eventName)
    }
}
