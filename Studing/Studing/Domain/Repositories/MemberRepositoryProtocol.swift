//
//  MemberRepositoryProtocol.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

protocol MemberRepository {
    func postSignin(request: LoginRequestDTO) async -> Result<LoginResponseDTO, NetworkError>
    func postSignup(request: SignupRequestDTO) async -> Result<SignupResponseDTO, NetworkError>
    func postCheckDuplicatedId(userId: String) async -> Result<EmptyResponse, NetworkError>
    func deleteWithDraw() async -> Result<EmptyResponse, NetworkError>
    func postReSubmit(request: ReSubmitRequestDTO) async -> Result<EmptyResponse, NetworkError>
}
