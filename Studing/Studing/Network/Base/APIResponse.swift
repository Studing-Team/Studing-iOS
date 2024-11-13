//
//  APIResponse.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/10/24.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let status: Int
    let message: String
    let data: T?
}

struct APIResult: Decodable {
    let status: Int
    let message: String
}
