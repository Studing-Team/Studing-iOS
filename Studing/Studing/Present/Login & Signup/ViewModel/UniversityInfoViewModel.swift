//
//  UniversityInfoViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import Foundation
import Combine

let universityInfoData: SearchUniversityInfoResponseDTO = SearchUniversityInfoResponseDTO(data: ["서울과학기술대", "서울대학교", "서울여자대학교"])

protocol InputUniversityNameDelegate: AnyObject {
    func didSubmitUniversityName(_ name: String)
}

final class UniversityInfoViewModel: BaseViewModel {
    
    weak var delegate: InputUniversityNameDelegate?
    
    // MARK: - Input
    
    struct Input {
        let universityName: AnyPublisher<String, Never>
        let nextTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let searchUnivsersityResult: AnyPublisher<([UniversityInfoModel], String), Never>
        let majorInfoViewAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    func submitUniversityName(name: String) {
        // 학교 정보를 처리한 후 delegate에 전달
        delegate?.didSubmitUniversityName(name)
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let universityNamesPublisher = input.universityName
            .flatMap { [weak self] name -> AnyPublisher<([UniversityInfoModel], String), Never> in
                guard let self = self else {
                    return Just(([], "")).eraseToAnyPublisher()
                }
                
                return self.postSearchUniversityPublisher(with: name)
                    .map { dto in
                        let models = dto.data.map { UniversityInfoModel(name: $0) }
                        return (models, name)
                    }
                    .catch { _ in Just(([], "")) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return Output(
            searchUnivsersityResult: universityNamesPublisher,
            majorInfoViewAction: input.nextTap
        )
    }
}

private extension UniversityInfoViewModel {
    // TODO: - 대학교 이름 검색 API 구현
    func postSearchUniversityPublisher(with name: String) -> AnyPublisher<SearchUniversityInfoResponseDTO, Error> {
            Future { promise in
                Task {
                    do {
                        let result = try await self.search(with: name)
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    
    // TODO: - 실제로는 필터 로직은 없어질 계획, API 붙이기전 로직 확인
    func search(with name: String) async throws -> SearchUniversityInfoResponseDTO {
        
        let filteredData = universityInfoData.data.filter { universityInfo in
            universityInfo.contains(name) // 대학교 이름에 주어진 name이 포함되는지 확인
        }
        
        return SearchUniversityInfoResponseDTO(data: filteredData)
    }
}
