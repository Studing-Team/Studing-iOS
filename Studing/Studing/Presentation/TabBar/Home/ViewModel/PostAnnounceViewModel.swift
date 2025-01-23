//
//  PostAnnounceViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/20/24.
//

import Foundation
import Combine

final class PostAnnounceViewModel: BaseViewModel {
    
    private(set) var type: PostType
    private(set) var selectedImageDatas: [Data]? = []
    private var isProcessing = false
    private var noticeId: Int?
    private var editContent: EditAnnounceContent?
    
    private let editAnnounceDataSubject = PassthroughSubject<EditAnnounceContent?, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
        let selectImageButtonTap: AnyPublisher<Void, Never>
        let bottomButtonTap: AnyPublisher<Void, Never>
        let titleText: AnyPublisher<String, Never>
        let contentText: AnyPublisher<String, Never>
        let tagButtonText: AnyPublisher<TagStyle, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let viewLifeCycleEventResult: AnyPublisher<EditAnnounceContent, Never>
        let isEnableCreateButton: AnyPublisher<Bool, Never>
        let selectImageButtonTap: AnyPublisher<Void, Never>
        let createAnnounceResult: AnyPublisher<Bool, Never>
        let editAnnounceData: AnyPublisher<EditAnnounceContent?, Never>?
    }
    
    // MARK: - UseCase properties
    
    private let createAnnounceUseCase: CreateAnnounceUseCase?
    private let editAnnounceUseCase: EditPostAnnounceUseCase?
    
    // MARK: - init
    
    init(
        createAnnounceUseCase: CreateAnnounceUseCase? = nil,
        editAnnounceUseCase: EditPostAnnounceUseCase? = nil,
        type: PostType
    ) {
        self.type = type
        self.createAnnounceUseCase = createAnnounceUseCase
        self.editAnnounceUseCase = editAnnounceUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let viewLifeCycleEventResult = input.viewLifeCycleEventAction
            .compactMap { _ in self.editContent }
            .eraseToAnyPublisher()
        
        let editAnnounceDataPublisher = editAnnounceDataSubject
            .eraseToAnyPublisher()
        
        let selectImageButtonResult = input.selectImageButtonTap
            .handleEvents(receiveOutput: { _ in
                AmplitudeManager.shared.trackEvent(AnalyticsEvent.NoticeCreate.addPhoto)
            })
            .eraseToAnyPublisher()
    
        let createResult = input.bottomButtonTap
            .filter { !self.isProcessing }
            .combineLatest(input.titleText, input.contentText, input.tagButtonText)
            .map { (_, title, content, type) in
                self.isProcessing = true
                
                if self.createAnnounceUseCase != nil {
                    AmplitudeManager.shared.trackEvent(AnalyticsEvent.NoticeCreate.upload)
                }
                
                return (title, content, type.title)
            }
            .flatMap { [weak self] (title, content, tagTitle) -> AnyPublisher<Bool, Never> in
                
                guard let self else { return Just((false)).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        var result: Result<Void, NetworkError>
                        
                        if self.createAnnounceUseCase != nil {
                            result = await self.createAnnounce(title, content, tagTitle)
                        } else {
                            result = await self.editAnnounce(title, content, tagTitle)
                        }
                        
                        switch result {
                        case .success:
                            promise(.success(true))
                        case .failure:
                            promise(.success(false))
                        }
                        
                        self.isProcessing = false
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let isEnableButton = Publishers.CombineLatest3(
            input.titleText,
            input.contentText,
            input.tagButtonText
        )
            .map { title, content, tagStyle in
                print("현재 상태:", title, content, tagStyle)
                
                return !title.isEmpty &&
                !content.isEmpty &&
                (tagStyle == .announce || tagStyle == .event)
            }
            .eraseToAnyPublisher()
        
        return Output(
            viewLifeCycleEventResult: viewLifeCycleEventResult,
            isEnableCreateButton: isEnableButton,
            selectImageButtonTap: selectImageButtonResult,
            createAnnounceResult: createResult,
            editAnnounceData: type == . edit ? editAnnounceDataPublisher.eraseToAnyPublisher() : Just(nil).eraseToAnyPublisher()
        )
    }
    
    func addImageData(_ data: Data) {
        selectedImageDatas?.append(data)
    }
    
    func removeImageData(at index: Int) {
        selectedImageDatas?.remove(at: index)
    }
    
    func editContent(noticeId: Int, content: EditAnnounceContent) {
        self.noticeId = noticeId
        self.editContent = content
    }
}

private extension PostAnnounceViewModel {
    func createAnnounce(_ title: String, _ content: String, _ tag: String) async -> Result<Void, NetworkError> {
        guard let createAnnounceUseCase else { return .failure(.clientError(message: "데이터 없음")) }
        
        switch await createAnnounceUseCase.execute(dto: CreateAnnounceRequestDTO(title: title, content: content, noticeImages: selectedImageDatas, tag: tag)) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func editAnnounce(_ title: String, _ content: String, _ tag: String) async -> Result<Void, NetworkError> {
        guard let editAnnounceUseCase, let noticeId else { return .failure(.clientError(message: "데이터 없음")) }
        
        switch await editAnnounceUseCase.execute(noticeId: noticeId, dto: CreateAnnounceRequestDTO(title: title, content: content, noticeImages: selectedImageDatas, tag: tag)) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
