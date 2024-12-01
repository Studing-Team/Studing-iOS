//
//  StoreMapViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/28/24.
//

import Combine
import Foundation

final class StoreMapViewModel: BaseViewModel {
    
    var storeDataSubject = CurrentValueSubject<StoreEntity?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    init(selectStoreData: StoreEntity) {
        storeDataSubject.send(selectStoreData)
    }
    
    // MARK: - Input
    
    struct Input {
        let backButtonAction: AnyPublisher<Void, Never>
        let myLocationButtonAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let selectedStoreData: AnyPublisher<StoreEntity, Never>
        let backButtonResult: AnyPublisher<Void, Never>
        let myLocationButtonResult: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private properties
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let sotreData = storeDataSubject
            .compactMap { $0 }  // nil 값 필터링
            .eraseToAnyPublisher()
        
        return Output(
            selectedStoreData: sotreData,
            backButtonResult: input.backButtonAction.eraseToAnyPublisher(),
            myLocationButtonResult: input.myLocationButtonAction.eraseToAnyPublisher()
        )
    }
}
