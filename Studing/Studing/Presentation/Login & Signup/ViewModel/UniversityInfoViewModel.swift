//
//  UniversityInfoViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import Foundation
import Combine

final class UniversityInfoViewModel: BaseViewModel {
    
    // MARK: - properties
    
    private let universityListUseCase: UniversityListUseCase
    private var universityInfoData: [String]?
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: InputUniversityNameDelegate?
    
    // MARK: - init

    init(universityListUseCase: UniversityListUseCase) {
        self.universityListUseCase = universityListUseCase
        
        Task {
            await getUniversityList()
        }
    }
    
    // MARK: - Input
    
    struct Input {
        let universityName: AnyPublisher<String, Never>
        let selectUniversityName: AnyPublisher<String, Never>
        let nextTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let searchUnivsersityResult: AnyPublisher<([UniversityInfoEntity], String), Never>
        let selectUniversity: AnyPublisher<String, Never>
        let isEnableButton: AnyPublisher<Bool, Never>
        let majorInfoViewAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let universityNamesPublisher = input.universityName
            .flatMap { [weak self] name -> AnyPublisher<([UniversityInfoEntity], String), Never> in
                guard let self = self else {
                    return Just(([], "")).eraseToAnyPublisher()
                }
                
                return self.searchUniversityPublisher(with: name)
                    .map { dto in
                        let models = dto.data.map { UniversityInfoEntity(name: $0) }
                        return (models, name)
                    }
                    .catch { _ in Just(([], "")) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let isEnableButton = Publishers.CombineLatest(input.universityName, input.selectUniversityName)
            .map { [weak self] (universityName, selectedName) in
                
                if !universityName.isEmpty && universityName == selectedName {
                    self?.delegate?.didSubmitUniversityName(selectedName)
                    return true
                } else {
                    return false
                }
            }
            .prepend(false)
            .eraseToAnyPublisher()
        
        let nextTapResult = input.nextTap
            .handleEvents(receiveOutput:  { _ in
                AmplitudeManager.shared.trackEvent(AnalyticsEvent.SignUp.nextStep2)
            })
            .eraseToAnyPublisher()
        
        return Output(
            searchUnivsersityResult: universityNamesPublisher,
            selectUniversity: input.selectUniversityName,
            isEnableButton: isEnableButton,
            majorInfoViewAction: nextTapResult
        )
    }
}

// MARK: - Private Extension

private extension UniversityInfoViewModel {
    func searchUniversityPublisher(with name: String) -> AnyPublisher<SearchUniversityInfoEntity, Error> {
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
    
    func search(with name: String) async throws -> SearchUniversityInfoEntity? {
        
        guard let universityInfoData else { return nil }
        
        let filteredData = universityInfoData.filter { universityInfo in
            universityInfo.contains(name)
        }
        
        return SearchUniversityInfoEntity(data: filteredData)
    }
}

// MARK: - API Extension

extension UniversityInfoViewModel {
    func getUniversityList() async {
        switch await self.universityListUseCase.execute() {
        case .success(let response):
            universityInfoData = response
        case .failure(_):
            break
        }
    }
}
