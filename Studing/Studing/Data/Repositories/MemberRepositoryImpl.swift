//
//  MemberRepositoryImpl.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

final class MemberRepositoryImpl: MemberRepository {
    func postSignin(request: LoginRequestDTO) async -> Result<LoginResponseDTO, NetworkError> {
        return await NetworkManager.shared.request(MemberAPI.postSignin(request))
    }
    
    func postSignup(request: SignupRequestDTO) async -> Result<SignupResponseDTO, NetworkError> {
        return await NetworkManager.shared.request(MemberAPI.postSignup(request))
    }
    
    func postCheckDuplicatedId(userId: String) async -> Result<EmptyResponse, NetworkError> {
        let dto = DuplicationIdRequestDTO(loginIdentifier: userId)

        return await NetworkManager.shared.request(MemberAPI.postCheckId(dto))
    }
    
    func deleteWithDraw() async -> Result<EmptyResponse, NetworkError> {
        return await NetworkManager.shared.request(MemberAPI.deleteWithDraw)
    }
    
    func postReSubmit(request: ReSubmitRequestDTO) async -> Result<EmptyResponse, NetworkError> {
        return await NetworkManager.shared.request(MemberAPI.postReSubmit(request))
    }
}
