//
//  PartnerRepositoryProtocol.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/15/24.
//

import Foundation

protocol PartnerRepository {
    func postPartnerInfo(dto: PartnerInfoRequestDTO) async -> Result<PartnerInfoResponseData, NetworkError>
}
