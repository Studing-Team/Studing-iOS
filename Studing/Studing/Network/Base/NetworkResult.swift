//
//  NetworkResult.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/10/24.
//

import Foundation

enum NetworkResult<T> {
    case success(T?)             // 성공 시 데이터를 반환
    case badRequest               // 400 에러
    case unAuthorized             // 401 에러
    case notFound                 // 404 에러
    case unProcessable            // 422 에러
    case serverErr                // 500 에러
    case decodeErr                // 디코딩 에러
    case networkFail              // 기타 네트워크 실패
}
