//
//  PartnerInfoUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/15/24.
//

import Foundation

final class PartnerInfoUseCase {
    private let repository: PartnerRepository
    
    init(repository: PartnerRepository) {
        self.repository = repository
    }
    
    func execute(_ dto: PartnerInfoRequestDTO) async -> Result<PartnerInfoResponseData, NetworkError> {
        return await repository.postPartnerInfo(dto: dto)
    }
}
