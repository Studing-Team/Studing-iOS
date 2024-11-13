//
//  StoreViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/7/24.
//

import Foundation
import Combine

final class StoreViewModel: BaseViewModel {
    
    var storeDataSubject = CurrentValueSubject<[StoreModel], Never>([])
    private var originalStores: [StoreModel] = []
    
    // MARK: - Input
    
    struct Input {
        let categoryTap: AnyPublisher<CategoryType, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let storeList: AnyPublisher<[StoreModel], Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {

        getStoreData()
        // 카테고리 선택에 따른 필터링
       input.categoryTap
           .sink { [weak self] category in
               self?.filterStores(by: category)
           }
           .store(in: &cancellables)
        
        return Output(storeList: storeDataSubject.eraseToAnyPublisher())
    }
}

extension StoreViewModel {
    func getStoreData() {
        let storeData = [StoreModel(name: "시작이 밤이다", category: .bar, description: "공릉동 아늑하고 편안한 분위기의 안주가 맛있는 감성 술집", address: "서울 노원구 동일로190길 33 1층", imageURL: ""),
                         StoreModel(name: "GTS버거 공릉점", category: .restaurant, description: "매일 아침 신선한 식자재와 100% 수제 소고기 패티로 만드는 프리미엄 수제버거", address: "서울 노원구 동일로190길 33 1층", imageURL: ""),
                         StoreModel(name: "88플러스내과산부인과의원", category: .health, description: "공릉동 내과, 소화기내과 전문의 2인 진료 88플러스내과", address: "서울 노원구 동일로190길 33 1층", imageURL: ""),
                         StoreModel(name: "88필짐 공릉점", category: .exercise, description: "현역 피트니스 선수와 명품 운동기구의 조합. 서울과기대 학생만이 등록할 수 있어요", address: "서울 노원구 동일로190길 33 1층", imageURL: ""),
                         StoreModel(name: "88빔블커피", category: .coffee, description: "시험 기간에 공부하기 좋은 넓은 공간이 자랑인 공릉핫플 카페", address: "서울 노원구 동일로190길 33 1층", imageURL: "")
        ]
        
        originalStores = storeData
        storeDataSubject.send(storeData)
    }
    
    private func filterStores(by category: CategoryType) {
        let filteredStores = category == .all ?
            originalStores :
            originalStores.filter { $0.category == category }
        
        storeDataSubject.send(filteredStores)
    }
}
