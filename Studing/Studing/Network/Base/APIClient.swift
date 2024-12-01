//
//  APIClient.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Alamofire
import Foundation

actor NetworkManager {
   static let shared = NetworkManager()
   private init() {}
   
   func request<T: Decodable>(_ endpoint: APIEndpoint) async -> Result<T, NetworkError> {
       print("1️⃣ \(T.self) API 호출 ==========================")

       let urlString = endpoint.baseURL.appendingPathComponent(endpoint.path)
       let parameters = try? endpoint.parameters.flatMap { encodable -> [String: Any]? in
           let data = try JSONEncoder().encode(encodable)
           return try JSONSerialization.jsonObject(with: data) as? [String: Any]
       }
               
       print("🚀 URL: \(urlString)")
       
       do {
           let response: APIResponse<T>
           
           switch endpoint.requestBodyType {
           case .json:
               // SpecificStatusResponseDTO 타입인 경우 EmptyResponse로 처리
               if T.self is SpecificStatusResponseDTO.Type {
                   let emptyResponse = try await AF.request(urlString,
                                                   method: endpoint.method,
                                                   parameters: parameters,
                                                   encoding: JSONEncoding.default,
                                                   headers: endpoint.headers)
                       .validate()
                       .serializingDecodable(APIResponse<EmptyResponse>.self)
                       .value
                   
                   if [200, 201].contains(emptyResponse.status) {
                       return .success(SpecificStatusResponseDTO(status: emptyResponse.status) as! T)
                   }
                   return .failure(.unknown)
               }
               
               // 일반적인 응답 처리
               response = try await AF.request(urlString,
                                            method: endpoint.method,
                                            parameters: parameters,
                                            encoding: JSONEncoding.default,
                                            headers: endpoint.headers)
                   .validate()
                   .serializingDecodable(APIResponse<T>.self)
                   .value
               
           case .formData:
               response = try await AF.upload(multipartFormData: { multipartFormData in
                   parameters?.forEach { key, value in
                       if key == "studentCardImage" {
                           if let dto = endpoint.parameters as? SignupRequestDTO {
                               let imageFileName = "\(dto.name)_studentCard.jpeg"
                               multipartFormData.append(dto.studentCardImage,
                                                     withName: key,
                                                     fileName: imageFileName,
                                                     mimeType: "image/jpeg")
                           } else if let dto = endpoint.parameters as? ReSubmitRequestDTO {
                               let imageFileName = "\(dto.name)_studentCard.jpeg"
                               multipartFormData.append(dto.studentCardImage,
                                                     withName: key,
                                                     fileName: imageFileName,
                                                     mimeType: "image/jpeg")
                           }
                       } else if key == "noticeImages" {
                           if let dto = endpoint.parameters as? CreateAnnounceRequestDTO {
                               if let images = dto.noticeImages {
                                   for (index, imageData) in images.enumerated() {
                                       let imageFileName = "notice_image_\(index).jpeg"
                                       multipartFormData.append(imageData,
                                                             withName: key,
                                                             fileName: imageFileName,
                                                             mimeType: "image/jpeg")
                                   }
                               }
                           }
                       } else if let stringValue = value as? String {
                           multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                       } else if let boolValue = value as? Bool {
                           let boolString = boolValue ? "true" : "false"
                           multipartFormData.append(boolString.data(using: .utf8)!, withName: key)
                       }
                   }
               }, to: urlString, method: endpoint.method, headers: endpoint.headers)
                   .validate()
                   .serializingDecodable(APIResponse<T>.self)
                   .value
           }
           
           print("🚀 StatusCode: \(String(describing: response.status))")
           print("🚀 Message: \(String(describing: response.message))")
           
           switch response.status {
           case 200, 201:
               if response.data == nil {
                   if T.self is EmptyResponse.Type {
                       print("4️⃣ \(T.self) API 종료 (빈 응답) ==========================")
                       return .success(EmptyResponse() as! T)
                   }
                   return .failure(.serverError)
               }
               
               print("🚀 Data: \(String(describing: response.data))")
               print("4️⃣ \(T.self) API 종료 ==========================")
               return .success(response.data!)
               
           case 403:
               if response.data == nil {
                   if T.self is EmptyResponse.Type {
                       print("4️⃣ \(T.self) API 에러 발생 (빈 응답) ==========================")
                       return .success(EmptyResponse() as! T)
                   }
                   return .failure(.serverError)
               }
               
               print("🚀 Data: \(String(describing: response.data))")
               print("4️⃣ \(T.self) API API 에러 발생 ==========================")
               return .failure(.serverError)
               
           default:
               print("❌ API 에러 발생: ==========================")
               return .failure(.unknown)
           }
           
       } catch {
           print("❌ API 에러 발생: ==========================")
           print(error.localizedDescription)
           return .failure(.unknown)
       }
   }
}
