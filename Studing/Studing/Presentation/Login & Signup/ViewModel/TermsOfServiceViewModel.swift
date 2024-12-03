//
//  TermsOfServiceViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/10/24.
//

import Foundation
import Combine

final class TermsOfServiceViewModel: BaseViewModel {
    
    private let isAllCheckBoxSubject = CurrentValueSubject<Bool, Never>(false)
    private let isServiceBoxSubject = CurrentValueSubject<Bool, Never>(false)
    private let isUserInfoSubject = CurrentValueSubject<Bool, Never>(false)
    private let isMarketingSubject = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Input
    
    struct Input {
        let allCheckBoxTap: AnyPublisher<Void, Never>
        let serviceBoxTap: AnyPublisher<Void, Never>
        let userInfoBoxTap: AnyPublisher<Void, Never>
        let marketingBoxTap: AnyPublisher<Void, Never>
        let nextTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let allCheckBoxTap: AnyPublisher<Bool, Never>
        let serviceBoxTap: AnyPublisher<Bool, Never>
        let userInfoBoxTap: AnyPublisher<Bool, Never>
        let marketingBoxTap: AnyPublisher<Bool, Never>
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
        let authUniversityViewAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: InputmarketingDelegate?
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        input.allCheckBoxTap
            .sink { [weak self] in
                guard let self else { return }
                let newValue = !self.isAllCheckBoxSubject.value
                self.isAllCheckBoxSubject.send(newValue)
                self.isServiceBoxSubject.send(newValue)
                self.isUserInfoSubject.send(newValue)
                self.isMarketingSubject.send(newValue)
            }
            .store(in: &cancellables)
        
        input.serviceBoxTap
            .sink { [weak self] in
                guard let self else { return }
                
                let newValue = !self.isServiceBoxSubject.value
                self.isServiceBoxSubject.send(newValue)
            }
            .store(in: &cancellables)
        
        input.userInfoBoxTap
            .sink { [weak self] in
                guard let self else { return }
                
                let newValue = !self.isUserInfoSubject.value
                self.isUserInfoSubject.send(newValue)
            }
            .store(in: &cancellables)
        
        input.marketingBoxTap
            .sink { [weak self] in
                guard let self else { return }
                
                let newValue = !self.isMarketingSubject.value
                self.isMarketingSubject.send(newValue)
            }
            .store(in: &cancellables)
        
        let checkboxesState = Publishers.CombineLatest3(
            isServiceBoxSubject,
            isUserInfoSubject,
            isMarketingSubject
        )

        checkboxesState
            .sink { [weak self] serviceBox, userInfoBox, marketingBox in
                guard let self else { return }
                
                self.updateAllCheckBoxState(serviceBox: serviceBox, userInfoBox: userInfoBox, marketingBox: marketingBox)
            }
            .store(in: &cancellables)
        
        
        let nextButtonState = Publishers.CombineLatest3(
            isAllCheckBoxSubject,
            isServiceBoxSubject,
            isUserInfoSubject
        )
        
        let isNextButtonEnabled = nextButtonState
            .map { [weak self] allBox, serviceBox, userInfoBox in
                let isEnabled = allBox || (serviceBox && userInfoBox)
                self?.delegate?.didSubmitMarketing(self?.isMarketingSubject.value ?? false)
                return isEnabled
            }
            .eraseToAnyPublisher()

        let nextTapResult = input.nextTap
            .handleEvents(receiveOutput:  { _ in
                AmplitudeManager.shared.trackEvent(AnalyticsEvent.SignUp.nextStep5)
            })
            .eraseToAnyPublisher()

        return Output(
            allCheckBoxTap: isAllCheckBoxSubject.eraseToAnyPublisher(),
            serviceBoxTap: isServiceBoxSubject.eraseToAnyPublisher(),
            userInfoBoxTap: isUserInfoSubject.eraseToAnyPublisher(),
            marketingBoxTap: isMarketingSubject.eraseToAnyPublisher(),
            isNextButtonEnabled: isNextButtonEnabled,
            authUniversityViewAction: nextTapResult
        )
    }
    
    private func updateAllCheckBoxState(serviceBox: Bool, userInfoBox: Bool, marketingBox: Bool) {
        let allChecked = serviceBox && userInfoBox && marketingBox
        isAllCheckBoxSubject.send(allChecked)
    }
}
