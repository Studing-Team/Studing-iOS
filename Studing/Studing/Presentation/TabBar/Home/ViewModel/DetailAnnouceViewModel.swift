//
//  DetailAnnouceViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import Foundation
import Combine

enum DetailAnnouceSectionType: Hashable, CaseIterable {
    case header
    case images
    case content
}

enum RightNavigationButtonType {
    case both
    case author
}

struct AlarmSettingData {
    let isAlarm: Bool
    var alarmDay: DateComponents? = nil
    var alarmTime: DateComponents? = nil
}

final class DetailAnnouceViewModel: BaseViewModel {
    typealias DetailAnnounceResult = (DetailAnnouceContentModel, [DetailAnnouceImageModel]?, DetailAnnouceSectionData)
    
    // MARK: - Combine Publishers Properties
    
    let sectionsData = CurrentValueSubject<[DetailAnnouceSectionType]?, Never>(nil)
    let headerOptionTypeSubject = CurrentValueSubject<PostOptionType?, Never>(nil)
    let authorToContentSubject = CurrentValueSubject<Bool, Never>(false)
    let alarmSettingSubject = CurrentValueSubject<AlarmSettingData, Never>(AlarmSettingData(isAlarm: false))
    let errorSubject = PassthroughSubject<NetworkError, Never>()
    
    // MARK: - Private properties
    
    private(set) var errorMessage: String?

    var sectionDataDict: [DetailAnnouceSectionType: [any DetailAnnouceSectionData]] = [:]
    private var announceList: [UnreadAllAnnounceListResponseDTO] = []
    private var currentIndex: Int = 0 {
        didSet {
            updateCurrentUnreadAnnounce()
        }
    }

    private var detailAnnounceType: DetailAnnounceType

    // MARK: - properties
    
    var isRefresh = false
    var isAuthor: Bool = false
    var announceContent: DetailAnnounceEntity?
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
        let likeButtonTap: AnyPublisher<Void, Never>
        let bookmarkButtonTap: AnyPublisher<Void, Never>
        let deleteButtonTap: AnyPublisher<Void, Never>
        let nextButtonTap: AnyPublisher<Void, Never>
        let currentPageControlCount : AnyPublisher<Int, Never>
        let firstComeButtonTap: AnyPublisher<FirstComeState, Never>?
    }
    
    // MARK: - Output
    
    struct Output {
        let viewLifeCycleEventResult: AnyPublisher<Bool, NetworkError>
        let isFavorite: AnyPublisher<Bool, Never>
        let isBookmark: AnyPublisher<Bool, Never>
        let bookmarkButtonResult: AnyPublisher<Bool, Never>
        let nextButtonResult: AnyPublisher<Result<Bool, NetworkError>, Never>
        let currentPageControlCountResult: AnyPublisher<Int, Never>
        let deleteResult: AnyPublisher<Bool, NetworkError>
        let authorToContentResult: AnyPublisher<Bool, Never>
        let alarmSettingResult: AnyPublisher<AlarmSettingData, Never>
        let headerOptionTypeResult: AnyPublisher<PostOptionType?, Never>
        let firstComeButtonResult: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    private(set) var selectedNoticeId: Int?
    private var selectedAssociationType: String?
    var unReadCount: Int?
    
    // MARK: - UseCase properties
    
    private let detailAnnounceUseCase: DetailAnnounceUseCase?
    private let unreadAllAnnounceUseCase: UnreadAllAnnounceUseCase?
    
    private let likeAnnounceUseCase: LikeAnnounceUseCase
    private let deleteLikeAnnounceUseCase: DeleteLikeAnnounceUseCase
    private let bookmarkAnnounceUseCase: BookmarkAnnounceUseCase
    private let deleteBookmarkAnnounceUseCase: DeleteBookmarkAnnounceUseCase
    private let checkAnnounceUseCase: CheckAnnounceUseCase
    
    private let editPostAnnounceUseCase: EditPostAnnounceUseCase?
    private let deletePostAnnounceUseCase: DeletePostAnnounceUseCase?
    
    private var registFirstComeUseCase: RegistFirstComeUseCase?
    private var firstComeRankingsUseCase: FirstComeRankingsUseCase?
    
    // MARK: - init
    
    init(type: DetailAnnounceType,
         selectedNoticeId: Int? = nil,
         selectedAssociationType: String? = nil,
         likeAnnounceUseCase: LikeAnnounceUseCase,
         deleteLikeAnnounceUseCase: DeleteLikeAnnounceUseCase,
         bookmarkAnnounceUseCase: BookmarkAnnounceUseCase,
         deleteBookmarkAnnounceUseCase: DeleteBookmarkAnnounceUseCase,
         detailAnnounceUseCase: DetailAnnounceUseCase? = nil,
         unreadAllAnnounceUseCase: UnreadAllAnnounceUseCase? = nil,
         unReadCount: Int? = nil,
         checkAnnounceUseCase: CheckAnnounceUseCase,
         editPostAnnounceUseCase: EditPostAnnounceUseCase? = nil,
         deletePostAnnounceUseCase: DeletePostAnnounceUseCase? = nil
    ) {
        self.selectedNoticeId = selectedNoticeId
        self.selectedAssociationType = selectedAssociationType
        self.likeAnnounceUseCase = likeAnnounceUseCase
        self.deleteLikeAnnounceUseCase = deleteLikeAnnounceUseCase
        self.bookmarkAnnounceUseCase = bookmarkAnnounceUseCase
        self.deleteBookmarkAnnounceUseCase = deleteBookmarkAnnounceUseCase
        self.detailAnnounceUseCase = detailAnnounceUseCase
        self.unreadAllAnnounceUseCase = unreadAllAnnounceUseCase
        self.unReadCount = unReadCount
        self.checkAnnounceUseCase = checkAnnounceUseCase
        self.detailAnnounceType = type
        self.editPostAnnounceUseCase = editPostAnnounceUseCase
        self.deletePostAnnounceUseCase = deletePostAnnounceUseCase
        
        print("DetailAnnouceViewModel init")
    }
    
    deinit {
        print("DetailAnnouceViewModel deinit")
    }
    
    static func createDetailViewModel(
        type: DetailAnnounceType,
        selectedNoticeId: Int?,
        repository: NoticesRepository
    ) -> DetailAnnouceViewModel {
        
        let currentUserAuth = KeychainManager.shared.loadData(key: .userAuthState, type: String.self)
            .flatMap { UserAuth(rawValue: $0) } ?? .unUser
        
        switch currentUserAuth {
        case .collegeUser, .departmentUser, .universityUser:
            return DetailAnnouceViewModel(
                type: type,
                selectedNoticeId: selectedNoticeId,
                likeAnnounceUseCase: LikeAnnounceUseCase(repository: repository),
                deleteLikeAnnounceUseCase: DeleteLikeAnnounceUseCase(repository: repository),
                bookmarkAnnounceUseCase: BookmarkAnnounceUseCase(repository: repository),
                deleteBookmarkAnnounceUseCase: DeleteBookmarkAnnounceUseCase(repository: repository),
                detailAnnounceUseCase: DetailAnnounceUseCase(repository: repository),
                checkAnnounceUseCase: CheckAnnounceUseCase(repository: repository),
                editPostAnnounceUseCase: EditPostAnnounceUseCase(repository: repository),
                deletePostAnnounceUseCase: DeletePostAnnounceUseCase(repository: repository)
            )
        default:
            return DetailAnnouceViewModel(
                type: type,
                selectedNoticeId: selectedNoticeId,
                likeAnnounceUseCase: LikeAnnounceUseCase(repository: repository),
                deleteLikeAnnounceUseCase: DeleteLikeAnnounceUseCase(repository: repository),
                bookmarkAnnounceUseCase: BookmarkAnnounceUseCase(repository: repository),
                deleteBookmarkAnnounceUseCase: DeleteBookmarkAnnounceUseCase(repository: repository),
                detailAnnounceUseCase: DetailAnnounceUseCase(repository: repository),
                checkAnnounceUseCase: CheckAnnounceUseCase(repository: repository)
            )
        }
    }
    
    static func createUnreadViewModel(
        type: DetailAnnounceType,
        selectedNoticeId: Int?,
        selectedAssociationType: String?,
        repository: NoticesRepository,
        unReadCount: Int?
    ) -> DetailAnnouceViewModel {
        return DetailAnnouceViewModel(
            type: type,
            selectedNoticeId: selectedNoticeId,
            selectedAssociationType: selectedAssociationType,
            likeAnnounceUseCase: LikeAnnounceUseCase(repository: repository),
            deleteLikeAnnounceUseCase: DeleteLikeAnnounceUseCase(repository: repository),
            bookmarkAnnounceUseCase: BookmarkAnnounceUseCase(repository: repository),
            deleteBookmarkAnnounceUseCase: DeleteBookmarkAnnounceUseCase(repository: repository),
            unreadAllAnnounceUseCase: UnreadAllAnnounceUseCase(repository: repository),
            unReadCount: unReadCount,
            checkAnnounceUseCase: CheckAnnounceUseCase(repository: NoticesRepositoryImpl())
        )
    }

    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        let viewLifeCycleEventResult = input.viewLifeCycleEventAction
            .flatMap { [weak self] _ -> AnyPublisher<Bool, NetworkError> in
                guard let self else { return Fail(error: .unknown).eraseToAnyPublisher() }

                switch self.detailAnnounceType {
                case .bookmarkAnnounce, .announce:
                    return self.getDetailAnnouncePublisher()
                        .map { [weak self] (contentModel, imageData, headerModel) in
                            self?.sectionDataDict[.images] = imageData
                            self?.sectionDataDict[.content] = [contentModel]
                            self?.sectionDataDict[.header] = [headerModel]
                            
                            self?.getMySections()
                        }
                        .flatMap { _ in
                            Future<Void, NetworkError> { promise in
                                Task {
                                    do {
                                        try await self.checkDetailAnnounce()
                                        promise(.success(()))
                                    } catch let error as NetworkError {
                                        promise(.failure(error))
                                    } catch {
                                        promise(.failure(.serverError))
                                    }
                                }
                            }
                            .eraseToAnyPublisher()
                        }
                        .map { _ in self.isRefresh }
                        .eraseToAnyPublisher()

                case .unreadAnnounce:
                    return Future<Void, NetworkError> { promise in
                        Task {
                            do {
                                try await self.postUnreadAllAnnounce()
                                promise(.success(()))
                            } catch let error as NetworkError {
                                promise(.failure(error))
                            } catch {
                                promise(.failure(.serverError))
                            }
                        }
                    }
                    .map { _ in self.isRefresh }
                    .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
        
        let nextButtonResult = input.nextButtonTap
            .handleEvents(receiveOutput: { _ in
                AmplitudeManager.shared.trackEvent(AnalyticsEvent.UnreadNotice.nextNotice)
            })
            .flatMap { [weak self] _ -> AnyPublisher<Result<Bool, NetworkError>, Never> in
                guard let self else { return Just((.failure(NetworkError.unknown))).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        let result = await self.checkUnAnnounce()
                        switch result {
                        case .success:
                            
                            if self.unReadCount == 0 {
                                promise(.success(.success(false)))
                            } else {
                                promise(.success(.success(true)))
                            }
                        case .failure(let error):
                            promise(.success(.failure(error)))
                        }
                    }
                }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        input.likeButtonTap
            .handleEvents(receiveOutput: { _ in
                switch self.detailAnnounceType {
                case .announce, .bookmarkAnnounce:
                    AmplitudeManager.shared.trackEvent(AnalyticsEvent.NoticeDetail.likePost)
                    
                case .unreadAnnounce:
                    AmplitudeManager.shared.trackEvent(AnalyticsEvent.UnreadNotice.likePost)
                }
            })
            .sink { [weak self] _ in
                guard let self else { return }
                
                Task {
                    await self.likeActionHandler()
                }
            }
            .store(in: &cancellables)
        
        let deleteResult = input.deleteButtonTap
            .flatMap { [weak self] _ -> AnyPublisher<Bool, NetworkError> in
                guard let self else { return Empty().eraseToAnyPublisher() }

                return Future<Bool, NetworkError> { promise in
                    Task {
                        do {
                            let _ = try await self.deletePostAnnounce(self.selectedNoticeId)
                            
                            promise(.success(true))
                        } catch let error {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)  // 에러 발생시 에러 스트림으로 전달
                    return Just(false)
                        .setFailureType(to: NetworkError.self)
                }
                .eraseToAnyPublisher()
            }
            .first()
            .eraseToAnyPublisher()
        
        let bookmarkButtonResult = input.bookmarkButtonTap
            .handleEvents(receiveOutput: { _ in
                switch self.detailAnnounceType {
                case .announce, .bookmarkAnnounce:
                    AmplitudeManager.shared.trackEvent(AnalyticsEvent.NoticeDetail.savePost)
                    
                case .unreadAnnounce:
                    AmplitudeManager.shared.trackEvent(AnalyticsEvent.UnreadNotice.savePost)
                }
            })
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }

                return Future { promise in
                    Task {
                        await self.bookmarkActionHandler()

                        guard let type = self.headerOptionTypeSubject.value else { return }
                        
                        let headerData: BaseDetailAnnounceHeaderModel
                        switch type {
                        case .basic:
                            guard let data = self.sectionDataDict[.header]?.first as? BaseDetailAnnounceHeaderModel else { return }
                            headerData = data
                            
                        case .period:
                            guard let data = self.sectionDataDict[.header]?.first as? DetailAnnouncePeriodHeaderModel else { return }
                            headerData = data.base
                            
                        case .firstCome:
                            guard let data = self.sectionDataDict[.header]?.first as? DetailAnnounceFirstComeHeaderModel else { return }
                            headerData = data.base
                        }
                        
                        promise(.success(headerData.isBookmark))
                    }
                }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let isFavorite = sectionsData
            .compactMap { [weak self] _ -> Bool? in
                
                guard let type = self?.headerOptionTypeSubject.value else { return false }
                
                switch type {
                case .basic:
                    guard let headerData = self?.sectionDataDict[.header]?.first as? BaseDetailAnnounceHeaderModel else { return nil }
                    return headerData.isFavorite
                    
                case .period:
                    guard let headerData = self?.sectionDataDict[.header]?.first as? DetailAnnouncePeriodHeaderModel else { return nil }
                    return headerData.base.isFavorite
                    
                case .firstCome:
                    guard let headerData = self?.sectionDataDict[.header]?.first as? DetailAnnounceFirstComeHeaderModel else { return nil }
                    return headerData.base.isFavorite
                }
            }
            .eraseToAnyPublisher()
            
        let isBookmark = sectionsData
            .compactMap { [weak self] _ -> Bool? in
                
                guard let type = self?.headerOptionTypeSubject.value else { return false }
                
                switch type {
                case .basic:
                    guard let headerData = self?.sectionDataDict[.header]?.first as? BaseDetailAnnounceHeaderModel else { return nil }
                    return headerData.isBookmark
                    
                case .period:
                    guard let headerData = self?.sectionDataDict[.header]?.first as? DetailAnnouncePeriodHeaderModel else { return nil }
                    return headerData.base.isBookmark
                    
                case .firstCome:
                    guard let headerData = self?.sectionDataDict[.header]?.first as? DetailAnnounceFirstComeHeaderModel else { return nil }
                    return headerData.base.isBookmark
                }
            }
            .eraseToAnyPublisher()
        
        headerOptionTypeSubject
            .compactMap { $0 }
            .sink { [weak self] type in
                if type == .firstCome {
                    self?.registFirstComeUseCase = RegistFirstComeUseCase(repository: NoticesRepositoryImpl())
                    self?.firstComeRankingsUseCase = FirstComeRankingsUseCase(repository: NoticesRepositoryImpl())
                }
            }
            .store(in: &cancellables)
        
        
        
        let firstComeButtonResult: AnyPublisher<Bool, Never> = input.firstComeButtonTap?
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Never> in
                guard let self else { return Just(false).eraseToAnyPublisher() }
                
                return self.postRegistFirstComePublisher(selectedNoticeId)
                    .map { _ in true }
                    .catch { _ in Just(false) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            ?? Empty<Bool, Never>().eraseToAnyPublisher()

        return Output(
            viewLifeCycleEventResult: viewLifeCycleEventResult,
            isFavorite: isFavorite,
            isBookmark: isBookmark,
            bookmarkButtonResult: bookmarkButtonResult,
            nextButtonResult: nextButtonResult,
            currentPageControlCountResult: input.currentPageControlCount,
            deleteResult: deleteResult, 
            authorToContentResult: authorToContentSubject.eraseToAnyPublisher(),
            alarmSettingResult: alarmSettingSubject.eraseToAnyPublisher(),
            headerOptionTypeResult: headerOptionTypeSubject.eraseToAnyPublisher(),
            firstComeButtonResult: firstComeButtonResult
        )
    }
}

extension DetailAnnouceViewModel {
    func selectNoticeId() -> Int? {
        return selectedNoticeId
    }
}

private extension DetailAnnouceViewModel {
    func likeActionHandler() async {
        
        guard let noticeId = selectedNoticeId,
              let type = self.headerOptionTypeSubject.value else { return }
        
        // 타입별로 headerData 추출
        let headerData: BaseDetailAnnounceHeaderModel
        switch type {
        case .basic:
            guard let data = sectionDataDict[.header]?.first as? BaseDetailAnnounceHeaderModel else { return }
            headerData = data
            
        case .period:
            guard let data = sectionDataDict[.header]?.first as? DetailAnnouncePeriodHeaderModel else { return }
            headerData = data.base
            
        case .firstCome:
            guard let data = sectionDataDict[.header]?.first as? DetailAnnounceFirstComeHeaderModel else { return }
            headerData = data.base
        }

        let result = headerData.isFavorite ?
            await deleteLikeAnnounce(noticeId) :
            await postLikeAnnounce(noticeId)
        
        switch result {
        case .success:
            updateHeaderFavoriteData(!headerData.isFavorite)
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
    
    func bookmarkActionHandler() async {
        
        guard let noticeId = selectedNoticeId,
              let type = self.headerOptionTypeSubject.value else { return }
        
        
        let headerData: BaseDetailAnnounceHeaderModel
        switch type {
        case .basic:
            guard let data = sectionDataDict[.header]?.first as? BaseDetailAnnounceHeaderModel else { return }
            headerData = data
            
        case .period:
            guard let data = sectionDataDict[.header]?.first as? DetailAnnouncePeriodHeaderModel else { return }
            headerData = data.base
            
        case .firstCome:
            guard let data = sectionDataDict[.header]?.first as? DetailAnnounceFirstComeHeaderModel else { return }
            headerData = data.base
        }
        
        let result = headerData.isBookmark ?
            await deleteBookmarkAnnounce(noticeId) :
            await postBookmarkAnnounce(noticeId)
        
        switch result {
        case .success:
            updateHeaderBookmarkData(!headerData.isBookmark)

        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
    
    private func updateHeaderFavoriteData(_ isFavorite: Bool) {
        guard let type = self.headerOptionTypeSubject.value else { return }
        
        switch type {
        case .basic:
            guard var data = sectionDataDict[.header]?.first as? BaseDetailAnnounceHeaderModel else { return }
            data.isFavorite = isFavorite
            data.favoriteCount = isFavorite ? data.favoriteCount + 1 : data.favoriteCount - 1
            sectionDataDict[.header] = [data]
            
        case .period:
            guard var data = sectionDataDict[.header]?.first as? DetailAnnouncePeriodHeaderModel else { return }
            data.base.isFavorite = isFavorite
            data.base.favoriteCount = isFavorite ? data.base.favoriteCount + 1 : data.base.favoriteCount - 1
            sectionDataDict[.header] = [data]
            
        case .firstCome:
            guard var data = sectionDataDict[.header]?.first as? DetailAnnounceFirstComeHeaderModel else { return }
            data.base.isFavorite = isFavorite
            data.base.favoriteCount = isFavorite ? data.base.favoriteCount + 1 : data.base.favoriteCount - 1
            sectionDataDict[.header] = [data]
        }
        
        getMySections()
    }
        
    private func updateHeaderBookmarkData(_ isBookmark: Bool) {
        guard let type = self.headerOptionTypeSubject.value else { return }
        
        switch type {
        case .basic:
            guard var data = sectionDataDict[.header]?.first as? BaseDetailAnnounceHeaderModel else { return }
            data.isBookmark = isBookmark
            data.bookmarkCount = isBookmark ? data.bookmarkCount + 1 : data.bookmarkCount - 1
            sectionDataDict[.header] = [data]
            
        case .period:
            guard var data = sectionDataDict[.header]?.first as? DetailAnnouncePeriodHeaderModel else { return }
            data.base.isBookmark = isBookmark
            data.base.bookmarkCount = isBookmark ? data.base.bookmarkCount + 1 : data.base.bookmarkCount - 1
            sectionDataDict[.header] = [data]
            
        case .firstCome:
            guard var data = sectionDataDict[.header]?.first as? DetailAnnounceFirstComeHeaderModel else { return }
            data.base.isBookmark = isBookmark
            data.base.bookmarkCount = isBookmark ? data.base.bookmarkCount + 1 : data.base.bookmarkCount - 1
            sectionDataDict[.header] = [data]
        }
        
        getMySections()
    }
    
    private func updateHeaderWatchData() {
        guard var headerData = sectionDataDict[.header]?.first as? DetailAnnouncePeriodHeaderModel else { return }
        
        headerData.base.watchCount += 1
        sectionDataDict[.header] = [headerData]
        getMySections()
    }
    
    func handleDetailAnnounceModel(headerModel: DetailAnnouceSectionData) {
        switch headerModel {
        case let model as DetailAnnounceFirstComeHeaderModel:
            sectionDataDict[.header] = [model]
        case let model as DetailAnnouncePeriodHeaderModel:
            sectionDataDict[.header] = [model]
        case let model as BaseDetailAnnounceHeaderModel:
            sectionDataDict[.header] = [model]
        default:
            print("알 수 없는 타입")
        }
    }
    
    func updateCurrentUnreadAnnounce() {
        guard currentIndex < announceList.count else { return }
        let currentAnnounce = announceList[currentIndex]
        selectedNoticeId = currentAnnounce.id
        sectionDataDict[.header] = [currentAnnounce.convertToHeader()]
        
        if let imageModels = currentAnnounce.convertToImages() {
            sectionDataDict[.images] = imageModels  // 배열 그대로 할당
        }
        sectionDataDict[.content] = [currentAnnounce.convertToContent()]
        
//        selectedNoticeId = currentAnnounce.id  // 현재 공지사항의 ID 업데이트
        
        self.isAuthor = currentAnnounce.isAuthor
        
//        RightNavigationButtonType(isAlarmEnabled: currentAnnounce.alarmTime, isAuthor: currentAnnounce.isAuthor)
//        
//        rightNavigationButtonResult.send(currentAnnounce.isAuthor)
        getMySections()
    }
    
    func getMySections() {
        var currentSections: [DetailAnnouceSectionType] = []

        // 섹션 타입 순서대로 추가
        for type in DetailAnnouceSectionType.allCases {
            if let items = sectionDataDict[type], !items.isEmpty {
                currentSections.append(type)
            }
        }

        sectionsData.send(currentSections.isEmpty ? nil : currentSections)
    }
    
    func updateHeaderIsFirstComeApplied(_ isFirstCome: Bool) {
        guard var data = sectionDataDict[.header]?.first as? DetailAnnounceFirstComeHeaderModel else { return }
        
        data.isFirstComeApplied = isFirstCome
        print("isFirstComeApplied 변수 값 변경 완료")
    }
}

// MARK: - Public API methods

extension DetailAnnouceViewModel {
    func checkUnAnnounce() async -> Result<Void, NetworkError> {
        switch await checkAnnounceUseCase.execute(noticeId: announceList[currentIndex].id) {
        case .success:
            currentIndex += 1
            unReadCount = (unReadCount ?? 0) - 1
            
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func checkDetailAnnounce() async throws {
        guard let selectedNoticeId else { return }
        
        switch await checkAnnounceUseCase.execute(noticeId: selectedNoticeId) {
        case .success(let response):
            switch response.status {
            case 200:
                print("이미 조회한 공지사항입니다.")
            case 201:
                print("조회 체크 성공했습니다.")
                updateHeaderWatchData()
            default:
                break
            }
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
    
    func getDetailAnnouncePublisher() -> AnyPublisher<DetailAnnounceResult, NetworkError> {
        
        guard let detailAnnounceUseCase, let selectedNoticeId else {
            return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
        }

        return Future { [weak self] promise in
            guard let self = self else {
                    promise(.failure(.unknown)) // self가 nil이면 실패 처리
                    return
                }
            
            Task {
                do {
                    let entity = try await detailAnnounceUseCase.execute(noticeId: selectedNoticeId)
                    self.announceContent = entity
                    self.headerOptionTypeSubject.send(entity.type)
                    self.authorToContentSubject.send(entity.isAuthor)
                    
                    let alarmData = AlarmSettingData(isAlarm: entity.isAlarmSet, alarmDay: entity.alarmDay, alarmTime: entity.alarmTime)
                    
                    self.alarmSettingSubject.send(alarmData)
                    
                    let contentModel = entity.toContentModel()
                    let imageData = entity.toImagesModel()
                    let headerModel = entity.toHeaderModel()
                    
                    promise(.success((contentModel, imageData, headerModel)))
                } catch let error as NetworkError {
                    self.errorMessage = "알 수 없는 에러가 발생했습니다."
                    promise(.failure(error))
                } catch {
                    self.errorMessage = "알 수 없는 에러가 발생했습니다."
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func postUnreadAllAnnounce() async throws {
        guard let unreadAllAnnounceUseCase else { return }
        
        switch await unreadAllAnnounceUseCase.execute(associationName: selectedAssociationType ?? "") {
        case .success(let response):
            announceList = response.notices
            updateCurrentUnreadAnnounce()
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
    
    func postLikeAnnounce(_ noticeId: Int?) async -> Result<Void, NetworkError> {
        guard let noticeId else { return .failure(.clientError(message: "데이터 없음")) }
        
        switch await likeAnnounceUseCase.execute(noticeId: noticeId) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }

    func deleteLikeAnnounce(_ noticeId: Int?) async -> Result<Void, NetworkError> {
        guard let noticeId else { return .failure(.clientError(message: "데이터 없음")) }
        
        switch await deleteLikeAnnounceUseCase.execute(noticeId: noticeId) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func postBookmarkAnnounce(_ noticeId: Int?) async -> Result<Void, NetworkError> {
        guard let noticeId else { return .failure(.clientError(message: "데이터 없음")) }
        
        switch await bookmarkAnnounceUseCase.execute(noticeId: noticeId) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }

    func deleteBookmarkAnnounce(_ noticeId: Int?) async -> Result<Void, NetworkError> {
        guard let noticeId else { return .failure(.clientError(message: "데이터 없음")) }
        
        switch await deleteBookmarkAnnounceUseCase.execute(noticeId: noticeId) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func editPostAnnounce(_ noticeId: Int?) async -> Result<Void, NetworkError>  {
        guard let noticeId else { return .failure(.clientError(message: "데이터 없음")) }
        
        switch await deleteBookmarkAnnounceUseCase.execute(noticeId: noticeId) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    
    func deletePostAnnounce(_ noticeId: Int?) async throws -> Result<Void, NetworkError>  {
        guard let noticeId, let deletePostAnnounceUseCase else { return .failure(.clientError(message: "데이터 없음")) }
        
        switch await deletePostAnnounceUseCase.execute(noticeId: noticeId) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func postRegistFirstComePublisher(_ noticeId: Int?) -> AnyPublisher<Bool, NetworkError>  {
        
        guard let registFirstComeUseCase, let noticeId else {
            return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
        }

        return Future { [weak self] promise in
            guard let self else {
                    promise(.failure(.unknown))
                    return
                }
            
            Task {
                do {
                    let result = try await registFirstComeUseCase.execute(noticeId: noticeId)

                    self.updateHeaderIsFirstComeApplied(true)
                    
                    promise(.success(true))
                } catch let error as NetworkError {
                    self.errorMessage = "알 수 없는 에러가 발생했습니다."
                    promise(.failure(error))
                } catch {
                    self.errorMessage = "알 수 없는 에러가 발생했습니다."
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getFirstComeRankings(_ noticeId: Int?) -> AnyPublisher<FirstComeRankingsResponseData, NetworkError>  {
        
        guard let firstComeRankingsUseCase, let noticeId else {
            return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
        }
        
        return Future { [weak self] promise in
            guard let self else {
                    promise(.failure(.unknown))
                    return
                }
            
            Task {
                do {
                    let result = try await firstComeRankingsUseCase.execute(noticeId: noticeId)
                    
                    promise(.success(result))
                } catch let error as NetworkError {
                    self.errorMessage = "알 수 없는 에러가 발생했습니다."
                    promise(.failure(error))
                    
                } catch {
                    self.errorMessage = "알 수 없는 에러가 발생했습니다."
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
