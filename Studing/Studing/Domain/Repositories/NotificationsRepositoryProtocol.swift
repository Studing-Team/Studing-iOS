//
//  NotificationsRepositoryProtocol.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/14/24.
//

import Foundation

protocol NotificationsRepository {
    func postNotificationToken() async -> Result<EmptyResponse, NetworkError>
}
