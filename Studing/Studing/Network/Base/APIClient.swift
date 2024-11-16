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
       
       var parameters: [String: Any]?
       if let encodable = endpoint.parameters {
           do {
               let data = try JSONEncoder().encode(encodable)
               parameters = try JSONSerialization.jsonObject(with: data) as? [String: Any]
           } catch {
               return .failure(.urlEncodingError)
           }
       }

       print("🚀 URL: \(urlString)")
       
       do {
           let response: APIResponse<T>
           
           switch endpoint.requestBodyType {
           case .json:
               response = try await AF.request(urlString,
                                             method: endpoint.method,
                                             parameters: parameters,
                                             encoding: JSONEncoding.default,
                                             headers: endpoint.headers)
                   .validate()
                   .responseData { response in
//                       if let data = response.data {
//                           if let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                               print("📥 Response 데이터:\n\(dict)")
//                           }
//                       } else {
//                           print("📥 Response 데이터 없음")
//                       }
                   }
                   .serializingDecodable(APIResponse<T>.self)
                   .value
               
           case .formData:
               response = try await AF.upload(multipartFormData: { multipartFormData in
                       parameters?.forEach { key, value in
                           if key == "studentCardImage" {
                               if let dto = endpoint.parameters as? SignupRequestDTO {
                                   let imageFileName = "\(dto.name)_studentCard.jpeg"
                                   multipartFormData.append(dto.studentCardImage,
                                                         withName: "\(key)",
                                                         fileName: imageFileName,
                                                         mimeType: "image/jpeg")
                               }
                           } else if let stringValue = value as? String {
                               multipartFormData.append(stringValue.data(using: .utf8)!, withName: "\(key)")
                           } else if let boolValue = value as? Bool {
                               let boolString = boolValue ? "true" : "false"
                               multipartFormData.append(boolString.data(using: .utf8)!, withName: "\(key)")
                           }
                       }
               }, to: urlString, method: endpoint.method, headers: endpoint.headers)
                      .validate()
                      .serializingDecodable(APIResponse<T>.self)
                      .value
           }
           
           // 빈 응답 처리: `T`가 EmptyResponse와 같은 빈 타입을 기대할 경우, 성공 응답으로 처리
           if response.data == nil {
               if T.self is EmptyResponse.Type {
                   print("4️⃣ \(T.self) API 종료 (빈 응답) ==========================")
                   return .success(EmptyResponse() as! T)
               } else {
                   return .failure(.unknown)
               }
           } else {
               print("🚀 StatusCode: \(String(describing: response.status))")
               print("🚀 Message: \(String(describing: response.message))")
               print("🚀 Message: \(String(describing: response.data))")
               
               print("4️⃣ \(T.self) API 종료 ==========================")
               return .success(response.data!)
           }
           
       } catch {
           print("❌ API 에러 발생: ==========================")
           print(error.localizedDescription)
           return .failure(.unknown)
       }
   }
}
