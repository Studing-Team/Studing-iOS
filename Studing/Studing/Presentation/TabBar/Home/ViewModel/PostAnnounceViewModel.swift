//
//  PostAnnounceViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/20/24.
//

import Foundation
import Combine

final class PostAnnounceViewModel: BaseViewModel {
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private(set) var type: PostType
    private(set) var postOptionType: PostOptionType
    private(set) var selectedImageDatas: [Data]? = []
    private var isProcessing = false
    private var noticeId: Int?
    private var editContent: EditAnnounceContent?
    
    // MARK: - Combine properties
    
    let editAnnounceDataSubject = PassthroughSubject<EditAnnounceContent?, Never>()

    let startTimeSubject = CurrentValueSubject<DateComponents, Never>(Calendar.current.dateComponents([.hour, .minute], from: Date()))
    let endTimeSubject = CurrentValueSubject<DateComponents, Never>(Calendar.current.dateComponents([.hour, .minute], from: Date()))
    let startDaySubject = CurrentValueSubject<DateComponents, Never>(Calendar.current.dateComponents([.year, .month, .day], from: Date()))
    let endDaySubject = CurrentValueSubject<DateComponents, Never>(Calendar.current.dateComponents([.year, .month, .day], from: Date()))
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
        let selectImageButtonTap: AnyPublisher<Void, Never>
        let bottomButtonTap: AnyPublisher<Void, Never>
        let titleText: AnyPublisher<String, Never>
        let contentText: AnyPublisher<String, Never>
        let tagButtonText: AnyPublisher<TagStyle, Never>
        let firstComeNumber: AnyPublisher<String, Never>?
    }
    
    // MARK: - Output
    
    struct Output {
        let viewLifeCycleEventResult: AnyPublisher<EditAnnounceContent, Never>
        let isEnableCreateButton: AnyPublisher<Bool, Never>
        let selectImageButtonTap: AnyPublisher<Void, Never>
        let createAnnounceResult: AnyPublisher<Bool, Never>
        let editAnnounceData: AnyPublisher<EditAnnounceContent?, Never>?
        let startTimeResult: AnyPublisher<String, Never>
        let endTimeResult: AnyPublisher<String, Never>
        let startDayResult: AnyPublisher<String, Never>
        let endDayResult: AnyPublisher<String, Never>
    }
    
    // MARK: - UseCase properties
    
    private let createAnnounceUseCase: CreateAnnounceUseCase?
    private let editAnnounceUseCase: EditPostAnnounceUseCase?
    
    // MARK: - init
    
    init(
        createAnnounceUseCase: CreateAnnounceUseCase? = nil,
        editAnnounceUseCase: EditPostAnnounceUseCase? = nil,
        type: PostType,
        postOptionType: PostOptionType
    ) {
        self.type = type
        self.postOptionType = postOptionType
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
        
        let startDayResult = startDaySubject
            .map { startDay -> String in
                return self.formatDay(startDay)
            }
            .eraseToAnyPublisher()
            
        let startTimeResult = startTimeSubject
            .map { startTime -> String in
                return self.formatTime(startTime)
            }
            .eraseToAnyPublisher()
        
        let endDayResult = endDaySubject
            .map { endDay -> String in
                return self.formatDay(endDay)
            }
            .eraseToAnyPublisher()
            
        let endTimeResult = endTimeSubject
            .map { endTime -> String in
                return self.formatTime(endTime)
            }
            .eraseToAnyPublisher()
        
        let isAnnounceTypeEnableButton = Publishers.CombineLatest3(
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
            .prepend(false)
            .eraseToAnyPublisher()
        
        let isFirstComeTypeEnableButton = Publishers.CombineLatest3(
            input.titleText,
            input.contentText,
            unwrapOptionalPublisher(input.firstComeNumber)
        )
            .map { title, content, isFirstCome in
                print("FirstComeType 현재 상태:", title, content, isFirstCome)
                return !title.isEmpty && !content.isEmpty && isFirstCome
            }
            .prepend(false)
            .eraseToAnyPublisher()
        
        let createResult = input.bottomButtonTap
            .filter { !self.isProcessing }
            .combineLatest(input.titleText, input.contentText, input.tagButtonText)
            .map { _, title, content, type in
                self.isProcessing = true
                             
                if self.createAnnounceUseCase != nil {
                    AmplitudeManager.shared.trackEvent(AnalyticsEvent.NoticeCreate.upload)
                }
                
                return (title, content, type)
            }
            .flatMap { [weak self] (title: String, content: String, type: TagStyle) -> AnyPublisher<Bool, Never> in
                
                guard let self else { return Just((false)).eraseToAnyPublisher() }
                
                switch self.postOptionType {
                case .basic:
                    return self.basicAnnouncePublisher(title, content, type.title)
                        .map { _ in true }
                        .catch { _ in Just(false) }
                        .eraseToAnyPublisher()
                    
                case .period:
                    return self.periodAnnouncePublisher(
                        title,
                        content,
                        type.title,
                        startTime: convertToAPITimeFormat(startDaySubject.value, startTimeSubject.value),
                        endTime: convertToAPITimeFormat(endDaySubject.value, endTimeSubject.value)
                    )
                    .map { _ in true }
                    .catch { _ in Just(false) }
                    .eraseToAnyPublisher()
                    
                case .firstCome:
                    
                    guard let firstComeNumber = input.firstComeNumber else {
                        return Just(false).eraseToAnyPublisher()
                    }
                    
                    return firstComeNumber
                        .map { numberString -> String in
                            return numberString //Int(numberString)!
                        }
                        .flatMap { [weak self] number in
                            guard let self else { return Just((false)).eraseToAnyPublisher() }
                            
                            return self.firstComeAnnouncePublisher(
                                title,
                                content,
                                type.title,
                                startTime: convertToAPITimeFormat(startDaySubject.value, startTimeSubject.value),
                                endTime: convertToAPITimeFormat(endDaySubject.value, endTimeSubject.value),
                                firstComeNumber: number
                            )
                            .map { _ in true }
                            .catch { _ in Just(false) }
                            .eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
        
        return Output(
            viewLifeCycleEventResult: viewLifeCycleEventResult,
            isEnableCreateButton: (postOptionType == .basic || postOptionType == .period) ?
            isAnnounceTypeEnableButton : isFirstComeTypeEnableButton,
            selectImageButtonTap: selectImageButtonResult,
            createAnnounceResult: createResult,
            editAnnounceData: type == . edit ? editAnnounceDataPublisher.eraseToAnyPublisher() : Just(nil).eraseToAnyPublisher(),
            startTimeResult: startTimeResult,
            endTimeResult: endTimeResult,
            startDayResult: startDayResult,
            endDayResult: endDayResult
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
    
    func unwrapOptionalPublisher(_ publisher: AnyPublisher<String, Never>?) -> AnyPublisher<Bool, Never> {
        guard let publisher = publisher else {
            return Just(false).eraseToAnyPublisher()
        }
        
        return publisher
            .map { Int($0) ?? 0 > 0 }
            .eraseToAnyPublisher()
    }
    
    func changePostAnnounceOptionType(optionType: PostOptionType) {
        self.postOptionType = optionType
    }
}

private extension PostAnnounceViewModel {
    func convertTimeToDate(_ timeString: String) -> Date? {
        return timeFormatter.date(from: timeString)
    }
    
    func convertDayToDate(_ dayString: String) -> Date? {
        return dateFormatter.date(from: dayString)
    }
    
    // Date to String conversion methods
    func formatTime(_ dateComponents: DateComponents) -> String {
        
        guard let hour = dateComponents.hour,
              let minute = dateComponents.minute else { return "" }
        
        let timeString = String(format: "%02d:%02d", hour, minute)
        
        return timeString
    }
    
    func formatDay(_ dateComponents: DateComponents) -> String {
        
        guard let year = dateComponents.year,
              let month = dateComponents.month,
              let day = dateComponents.day else { return "" }
        
        let dateString = String(format: "%d년 %d월 %d일", year, month, day)
        
        return dateString
    }
    
    func convertToAPITimeFormat(_ day: DateComponents, _ time: DateComponents) -> String {
        
        guard let year = day.year,
              let month = day.month,
              let day = day.day,
              let hour = time.hour,
              let minute = time.minute else { return "" }
        
        return String(format: "%d-%02d-%02d %02d:%02d", year, month, day, hour, minute)
    }
}

private extension PostAnnounceViewModel {
    func createOrEditAnnounce(dto: CreateAnnounceRequestDTO) -> AnyPublisher<Void, NetworkError> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    switch self.type {
                    case .create:
                        guard let useCase = self.createAnnounceUseCase else {
                            promise(.failure(.unknown))
                            return
                        }
                        
                        let _ = try await useCase.execute(dto: dto)
                        
                    case .edit:
                        guard let useCase = self.editAnnounceUseCase, let noticeId = self.noticeId else {
                            promise(.failure(.unknown))
                            return
                        }
                        
                        let _ =  try await useCase.execute(noticeId: noticeId, dto: dto)
                    }
                    promise(.success(()))
                } catch let error as NetworkError {
                    promise(.failure(error))
                } catch {
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    // 기본 공지사항
    func basicAnnouncePublisher(_ title: String, _ content: String, _ tag: String) -> AnyPublisher<Void, NetworkError> {
        let dto = CreateAnnounceRequestDTO(
            title: title,
            content: content,
            noticeImages: selectedImageDatas,
            tag: tag,
            startTime: nil,
            endTime: nil,
            firstComeNumber: nil
        )
        return createOrEditAnnounce(dto: dto)
    }

    // 기간 공지사항
    func periodAnnouncePublisher(_ title: String, _ content: String, _ tag: String, startTime: String, endTime: String) -> AnyPublisher<Void, NetworkError> {
        let dto = CreateAnnounceRequestDTO(
            title: title,
            content: content,
            noticeImages: selectedImageDatas,
            tag: tag,
            startTime: startTime,
            endTime: endTime,
            firstComeNumber: nil
        )
        return createOrEditAnnounce(dto: dto)
    }

    // 선착순 공지사항
    func firstComeAnnouncePublisher(_ title: String, _ content: String, _ tag: String, startTime: String, endTime: String, firstComeNumber: String) -> AnyPublisher<Void, NetworkError> {
        let dto = CreateAnnounceRequestDTO(
            title: title,
            content: content,
            noticeImages: selectedImageDatas,
            tag: tag,
            startTime: startTime,
            endTime: endTime,
            firstComeNumber: firstComeNumber
        )
        return createOrEditAnnounce(dto: dto)
    }
}
