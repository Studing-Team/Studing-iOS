//
//  StoreViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/7/24.
//

import Foundation
import Combine

final class StoreViewModel: BaseViewModel {
    
    var storeDataSubject = CurrentValueSubject<[StoreEntity], Never>([])
    var selectedCategory = CurrentValueSubject<CategoryType, Never>(.all)
    
    private var originalStores: [StoreEntity] = []
    
    // MARK: - Input
    
    struct Input {
        let categoryTap: AnyPublisher<CategoryType, Never>
        let searchStoreName: AnyPublisher<String, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let storeList: AnyPublisher<[StoreEntity], Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let partnerInfoUseCase: PartnerInfoUseCase
    
    init(partnerInfoUseCase: PartnerInfoUseCase) {
        self.partnerInfoUseCase = partnerInfoUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        input.categoryTap
            .flatMap { [weak self] category -> AnyPublisher<CategoryType, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                
                selectedCategory.send(category)
                
                return Future { promise in
                    Task {
                        switch await self.getStoreData() {
                        case .success:
                            promise(.success(category))  // 성공시에만 카테고리 전달
                        case .failure(let error):
                            print(error)
                        }
                    }
                }.eraseToAnyPublisher()
            }
            .sink { [weak self] category in
                self?.filterStoresToType(by: category)
            }
            .store(in: &cancellables)
        
        input.searchStoreName
            .sink { [weak self] inputText in
                self?.filterStoresToName(by: inputText)
            }
            .store(in: &cancellables)
        
        return Output(storeList: storeDataSubject.eraseToAnyPublisher())
    }
}

extension StoreViewModel {
    func getStoreData() async -> Result<Void, Error> {
        switch await partnerInfoUseCase.execute(PartnerInfoRequestDTO(categorie: "전체")) {
        case .success(let response):
            originalStores = response.toEntities()
            return .success(())
        case .failure(let error):
            print("Error:", error.localizedDescription)
            return .failure(error)
        }
    }
    
    private func filterStoresToType(by category: CategoryType) {
        let filteredStores = category == .all ? originalStores : originalStores.filter { $0.category == category }
        
        storeDataSubject.send(filteredStores)
    }
    
    private func filterStoresToName(by searchText: String) {
        
        print("데이터:", storeDataSubject.value)
        
        print("입력:", searchText)
        
        if searchText.isEmpty {
            // 검색어가 비어있으면 현재 선택된 카테고리의 전체 목록으로 복원
            filterStoresToType(by: selectedCategory.value)
            return
        }
        
        let searchNameFilterStores = originalStores.filter {
            let isMatch = $0.name.lowercased().contains(searchText.lowercased())
            return isMatch
        }
        
        storeDataSubject.send(searchNameFilterStores)
    }
}
