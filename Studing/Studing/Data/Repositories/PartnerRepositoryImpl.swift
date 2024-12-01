//
//  PartnerRepositoryImpl.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/15/24.
//

import Foundation

final class PartnerRepositoryImpl: PartnerRepository {
    func postPartnerInfo(dto: PartnerInfoRequestDTO) async -> Result<PartnerInfoResponseData, NetworkError> {
        return await NetworkManager.shared.request(PartnerAPI.postPartnerInfo(dto))
    }
}
