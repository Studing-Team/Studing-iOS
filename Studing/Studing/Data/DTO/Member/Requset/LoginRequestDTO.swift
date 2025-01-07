//
//  LoginRequestDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let loginIdentifier: String
    let password: String
}
