//
//  PostAnnounceViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/20/24.
//

import Foundation
import Combine

final class PostAnnounceViewModel: BaseViewModel {
    
    private(set) var selectedImageDatas: [Data]? = [] {
        didSet {
            print("사진 데이터 개수:", selectedImageDatas?.count)
        }
    }
    
    // MARK: - Input
    
    struct Input {
        let selectImageButtonTap: AnyPublisher<Void, Never>
        let createAnnounceButtonTap: AnyPublisher<Void, Never>
        let titleText: AnyPublisher<String, Never>
        let contentText: AnyPublisher<String, Never>
        let tagButtonText: AnyPublisher<TagStyle, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let isEnableCreateButton: AnyPublisher<Bool, Never>
        let selectImageButtonTap: AnyPublisher<Void, Never>
        let createAnnounceResult: AnyPublisher<Bool, Never>
    }
    
    // MARK: - UseCase properties
    
    private let createAnnounceUseCase: CreateAnnounceUseCase
    
    // MARK: - init
    
    init(createAnnounceUseCase: CreateAnnounceUseCase) {
        self.createAnnounceUseCase = createAnnounceUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let createResult = input.createAnnounceButtonTap
            .combineLatest(input.titleText, input.contentText, input.tagButtonText)
            .map { (_, title, content, type) in
                
                return (title, content, type.title)
            }
            .flatMap { [weak self] (title, content, tagTitle) -> AnyPublisher<Bool, Never> in
                
                guard let self else { return Just((false)).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        let result = await self.createAnnounce(title, content, tagTitle)
                        
                        switch result {
                        case .success:
                            promise(.success(true))
                        case .failure:
                            promise(.success(false))
                        }
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
                
                print("현재 상태:", !title.isEmpty &&
                      !content.isEmpty &&
                      (tagStyle == .announce || tagStyle == .event)
                  )
                
                return !title.isEmpty &&
                !content.isEmpty &&
                (tagStyle == .announce || tagStyle == .event)
            }
            .eraseToAnyPublisher()
        
        return Output(isEnableCreateButton: isEnableButton,
                      selectImageButtonTap: input.selectImageButtonTap,
                      createAnnounceResult: createResult
        )
    }
    
    func addImageData(_ data: Data) {
        selectedImageDatas?.append(data)
    }
    
    func removeImageData(at index: Int) {
        selectedImageDatas?.remove(at: index)
    }
}

extension PostAnnounceViewModel {
    private func createAnnounce(_ title: String, _ content: String, _ tag: String) async -> Result<Void, NetworkError> {
        switch await createAnnounceUseCase.execute(dto: CreateAnnounceRequestDTO(title: title, content: content, noticeImages: selectedImageDatas, tag: tag)) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
