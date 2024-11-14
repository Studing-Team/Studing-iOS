//
//  MypageViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import Foundation
import Combine

final class MypageViewModel: BaseViewModel {
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>  // 화면 로드 시점 캡처
    }
    
    // MARK: - Output
    
    struct Output {
        let myPageInfo: AnyPublisher<MypageInfoEntity?, Never>
    }

    
    // MARK: - Private properties
    
    var myPageInfoSubject = CurrentValueSubject<MypageInfoEntity?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    private let mypageUseCase: MypageUseCase
    
    init(mypageUseCase: MypageUseCase) {
        self.mypageUseCase = mypageUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        // viewDidLoad 시점에 데이터 요청
        input.viewDidLoad
            .sink { [weak self] _ in
                guard let self else { return }
                
                Task {
                    await self.getMyPageInfo()
                }
            }
            .store(in: &cancellables)
        
        return Output(myPageInfo: myPageInfoSubject
                .compactMap { $0 }  // nil 필터링
                .eraseToAnyPublisher()
        )
    }
}

extension MypageViewModel {
    func getMyPageInfo() async {
        switch await mypageUseCase.execute() {
        case .success(let response):
            let data = response.toEntity()
            myPageInfoSubject.send(data)
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
}
