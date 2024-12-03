//
//  StudentIdViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/3/24.
//

import Foundation
import Combine

final class StudentIdViewModel: BaseViewModel {
    // MARK: - Input
    
    var studentIdData = [StudentIdInfoModel(studentId: "24학번"),
                         StudentIdInfoModel(studentId: "23학번"),
                         StudentIdInfoModel(studentId: "22학번"),
                         StudentIdInfoModel(studentId: "21학번"),
                         StudentIdInfoModel(studentId: "20학번"),
                         StudentIdInfoModel(studentId: "19학번"),
                         StudentIdInfoModel(studentId: "18학번"),
                         StudentIdInfoModel(studentId: "17학번"),
                         StudentIdInfoModel(studentId: "16학번"),
                         StudentIdInfoModel(studentId: "15학번"),
                         StudentIdInfoModel(studentId: "14학번 이하")
    ]
    
    weak var delegate: InputAdmissionDelegate?
    
    struct Input {
        let nextTap: AnyPublisher<Void, Never>
        let selectedIndexPath: AnyPublisher<IndexPath, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let selectedStudentId: AnyPublisher<String?, Never>
        let shouldHideCollectionView: AnyPublisher<Bool, Never>
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
        let TermsOfServiceViewAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let selectedStudentId = input.selectedIndexPath
            .map { [weak self] indexPath -> String? in
                self?.studentIdData[indexPath.row].studentId
            }
            .eraseToAnyPublisher()
        
        let shouldHideCollectionView = input.selectedIndexPath
            .map { _ in true }
            .eraseToAnyPublisher()
        
        let isNextButtonEnabled = selectedStudentId
            .map { id in
                if id?.isEmpty == false {
                    let admissionNumber = String(id?.prefix(2) ?? "")

                    self.delegate?.didSubmitAdmission(admissionNumber)
                    return true
                } else {
                    return false
                }
            }
            .prepend(false)
            .eraseToAnyPublisher()
        
        let nextTapResult = input.nextTap
            .handleEvents(receiveOutput:  { _ in
                AmplitudeManager.shared.trackEvent(AnalyticsEvent.SignUp.nextStep4)
            })
            .eraseToAnyPublisher()
 
        return Output(
            selectedStudentId: selectedStudentId,
            shouldHideCollectionView: shouldHideCollectionView,
            isNextButtonEnabled: isNextButtonEnabled,
            TermsOfServiceViewAction: nextTapResult
        )
    }
}
