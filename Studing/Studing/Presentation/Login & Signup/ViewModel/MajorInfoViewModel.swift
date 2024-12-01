//
//  MajorInfoViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/25/24.
//

import Foundation
import Combine

final class MajorInfoViewModel: BaseViewModel {
    
    private var majorInfoData: [String]?
    
    weak var delegate: InputMajorDelegate?
    
    // MARK: - Input
    
    struct Input {
        let majorName: AnyPublisher<String, Never>
        let selectMajorName: AnyPublisher<String, Never>
        let nextTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let searchMajorResult: AnyPublisher<([MajorInfoEntity], String), Never>
        let selectUniversity: AnyPublisher<String, Never>
        let isEnableButton: AnyPublisher<Bool, Never>
        let TermsOfServiceViewAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let departmentListUseCase: DepartmentListUseCase

    init(universityName: String, departmentListUseCase: DepartmentListUseCase) {
        self.departmentListUseCase = departmentListUseCase
        
        Task {
            await getDepartmentList(name: universityName)
        }
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let majorNamesPublisher = input.majorName
            .flatMap { [weak self] name -> AnyPublisher<([MajorInfoEntity], String), Never> in
                guard let self = self else {
                    return Just(([], "")).eraseToAnyPublisher()
                }
                
                return self.searchMajorPublisher(with: name)
                    .map { dto in
                        let models = dto.data.map { MajorInfoEntity(name: $0) }
                        return (models, name)
                    }
                    .catch { _ in Just(([], "")) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let isEnableButton = Publishers.CombineLatest(input.majorName, input.selectMajorName)
            .map { (majorName, selectedName) in
                
                if !majorName.isEmpty && majorName == selectedName {
                    self.delegate?.didSubmitMajor(majorName)
                    return true
                } else {
                    return false
                }
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
    func searchMajorPublisher(with name: String) -> AnyPublisher<SearchMajorInfoEntity, Error> {
            Future { promise in
                Task {
                    do {
                        let result = try await self.search(with: name)
                        
                        if let result {
                            promise(.success(result))
                        }
                        
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    
    // TODO: - 실제로는 필터 로직은 없어질 계획, API 붙이기전 로직 확인
    func search(with name: String) async throws -> SearchMajorInfoEntity? {
        
        guard let majorInfoData else { return nil }
        
        let filteredData = majorInfoData.filter { majorInfo in
            majorInfo.localizedCaseInsensitiveContains(name) // 대학교 이름에 주어진 name이 포함되는지 확인
        }
        
        return SearchMajorInfoEntity(data: filteredData)
    }
}

extension MajorInfoViewModel {
    func getDepartmentList(name: String) async {
        switch await self.departmentListUseCase.execute(request: DepartmentRequestDTO(universityName: name)) {
        case .success(let response):
            majorInfoData = response
        case .failure(_):
            break
        }
    }
}
