//
//  FirstComeModalViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/24/25.
//

import Combine

final class FirstComeModalViewModel {
    
    // MARK: - Private properties
    
    private var noticeId: Int
    private(set) var myRanking: Int?
    private(set) var firstComeRankingData: [FirstComeRankingsModel]?
    
    // MARK: - UseCase properties
    
    private let firstComeRankingsUseCase: FirstComeRankingsUseCase
    
    // MARK: - Init
    
    init(
        noticeId: Int,
        firstComeRankingsUseCase: FirstComeRankingsUseCase
    ) {
        self.noticeId = noticeId
        self.firstComeRankingsUseCase = firstComeRankingsUseCase
        
        print("FirstComeModalViewModel init")
    }
    
    deinit {
        print("FirstComeModalViewModel deinit")
    }
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, NetworkError>
        let findMyRankAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let firstComeRankingsResult: AnyPublisher<Bool, NetworkError>
        let findMyRankResult: AnyPublisher<Int?, Never>
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let viewLifeCycleEventResult = input.viewLifeCycleEventAction
            .flatMap { [weak self] _ -> AnyPublisher<Bool, NetworkError> in
                
                guard let self else {
                    return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
                }
                
                return self.getFirstComeRankings(self.noticeId)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let findMyRankResult = input.findMyRankAction
            .map {
                return self.myRanking ?? nil
            }
            .eraseToAnyPublisher()
        
        return Output(
            firstComeRankingsResult: viewLifeCycleEventResult,
            findMyRankResult: findMyRankResult
        )
    }
}

// MARK: - Public API methods

extension FirstComeModalViewModel {
    func getFirstComeRankings(_ noticeId: Int) -> AnyPublisher<Bool, NetworkError>  {
        return Future { [weak self] promise in
            guard let self else {
                    promise(.failure(.unknown))
                    return
                }
            
            Task {
                do {
                    let result = try await self.firstComeRankingsUseCase.execute(noticeId: noticeId)
                    
                    self.myRanking = result.myRanking
                    self.firstComeRankingData = result.toModels()
                    
                    promise(.success(true))
                } catch let error as NetworkError {
//                    self.errorMessage = "알 수 없는 에러가 발생했습니다."
                    promise(.failure(error))
                    
                } catch {
//                    self.errorMessage = "알 수 없는 에러가 발생했습니다."
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Public methods

extension FirstComeModalViewModel {
    func findMyRanking() -> Int? {
        guard let myRanking else { return nil }
        
        return myRanking
    }
}
