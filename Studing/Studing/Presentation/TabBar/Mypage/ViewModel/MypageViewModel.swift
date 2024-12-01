//
//  MypageViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import Foundation
import Combine

enum MypageNavigationType {
       case userInfo           // 회원 정보
       case serviceCenter     // 고객센터
       case notice           // 공지사항
       case version          // 버전 정보
       case terms           // 이용약관
       case privacyPolicy   // 개인정보 처리방침
       case logout          // 로그아웃
       case withDraw      // 회원탈퇴
   }

final class MypageViewModel: BaseViewModel {
    
    // MARK: - Combine Publishers Properties
    
    var myPageInfoSubject = CurrentValueSubject<MypageInfoEntity?, Never>(nil)
    private let navigationEventSubject = PassthroughSubject<MypageNavigationType, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>  // 화면 로드 시점 캡처
        let selectedCell: AnyPublisher<(section: MyPageType, index: Int), Never>
        let comfirmButtonAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let myPageInfo: AnyPublisher<MypageInfoEntity?, Never>
        let navigationEvent: AnyPublisher<MypageNavigationType, Never>
        let comfirmButtonResult: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Private properties

    
    // MARK: - UseCase properties
    
    private let mypageUseCase: MypageUseCase
    
    // MARK: - init
    
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
        
        input.selectedCell
            .sink { [weak self] section, index in
                guard let self else { return }
                
                self.selectCellHandler(section: section, index: index)
            }
            .store(in: &cancellables)
        
        let comfirmButtonResult = input.comfirmButtonAction
            .map { _ -> Bool in
                KeychainManager.shared.delete(key: .userInfo)
                KeychainManager.shared.delete(key: .userAuthState)
                KeychainManager.shared.delete(key: .accessToken)
                KeychainManager.shared.delete(key: .signupInfo)
                KeychainManager.shared.delete(key: .fcmToken)
                UserDefaults.standard.set(false, forKey: "isLogined")
                
                return true
            }
            .eraseToAnyPublisher()
            

        
        return Output(
            myPageInfo: myPageInfoSubject
                .compactMap { $0 }  // nil 필터링
                .eraseToAnyPublisher(),
            navigationEvent: navigationEventSubject.eraseToAnyPublisher(),
            comfirmButtonResult: comfirmButtonResult
        )
    }
    
    private func selectCellHandler(section: MyPageType, index: Int) {
        switch section {
        case .useInfo:
            switch index {
            case 1: navigationEventSubject.send(.notice)
            case 2: navigationEventSubject.send(.serviceCenter)
            case 3: navigationEventSubject.send(.privacyPolicy)
            default: break
            }
            
        case .etc:
            switch index {
            case 0: navigationEventSubject.send(.logout)
            case 1: navigationEventSubject.send(.withDraw)
            default: break
            }
            
        default:
            break
        }
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
