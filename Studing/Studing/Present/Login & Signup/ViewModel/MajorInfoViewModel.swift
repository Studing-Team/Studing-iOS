//
//  MajorInfoViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/25/24.
//

import Foundation
import Combine

let majorInfoData: SearchMajorInfoResponseDTO = SearchMajorInfoResponseDTO(data: ["컴퓨터공학과", "컴퓨터시스템공학과", "컴퓨터학부"])

final class MajorInfoViewModel: BaseViewModel {
    
    // MARK: - Input
    
    struct Input {
        let majorName: AnyPublisher<String, Never>
        let selectMajorName: AnyPublisher<String, Never>
        let nextTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let searchMajorResult: AnyPublisher<([MajorInfoModel], String), Never>
        let selectUniversity: AnyPublisher<String, Never>
        let isEnableButton: AnyPublisher<Bool, Never>
        let TermsOfServiceViewAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let majorNamesPublisher = input.majorName
            .flatMap { [weak self] name -> AnyPublisher<([MajorInfoModel], String), Never> in
                guard let self = self else {
                    return Just(([], "")).eraseToAnyPublisher()
                }
                
                return self.postSearchMajorPublisher(with: name)
                    .map { dto in
                        let models = dto.data.map { MajorInfoModel(name: $0) }
                        return (models, name)
                    }
                    .catch { _ in Just(([], "")) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let isEnableButton = Publishers.CombineLatest(input.majorName, input.selectMajorName)
            .map { (majorName, selectedName) in
                return !majorName.isEmpty && majorName == selectedName
            }
            .prepend(false)
            .eraseToAnyPublisher()
        
        return Output(
            searchMajorResult: majorNamesPublisher,
            selectUniversity: input.selectMajorName,
            isEnableButton: isEnableButton,
            TermsOfServiceViewAction: input.nextTap
        )
    }
}

private extension MajorInfoViewModel {
    // TODO: - 학과 이름 검색 API 구현
    func postSearchMajorPublisher(with name: String) -> AnyPublisher<SearchMajorInfoResponseDTO, Error> {
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
    func search(with name: String) async throws -> SearchMajorInfoResponseDTO {
        
        let filteredData = majorInfoData.data.filter { universityInfo in
            universityInfo.contains(name) // 대학교 이름에 주어진 name이 포함되는지 확인
        }
        
        return SearchMajorInfoResponseDTO(data: filteredData)
    }
}
