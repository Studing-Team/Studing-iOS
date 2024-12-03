//
//  DetailAnnouceViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import Foundation
import Combine

enum DetailAnnouceSectionType: CaseIterable {
    case header
    case images
    case content
}

final class DetailAnnouceViewModel: BaseViewModel {
    var sectionsData = CurrentValueSubject<[DetailAnnouceSectionType]?, Never>(nil)
    
    var sectionDataDict: [DetailAnnouceSectionType: [any DetailAnnouceSectionData]] = [:]
    private var announceList: [UnreadAllAnnounceListResponseDTO] = []
    private var currentIndex: Int = 0 {
        didSet {
            updateCurrentUnreadAnnounce()
        }
    }
    
    private var detailAnnounceType: DetailAnnounceType
    
    // MARK: - Input
    
    struct Input {
        let likeButtonTap: AnyPublisher<Void, Never>
        let bookmarkButtonTap: AnyPublisher<Void, Never>
        let nextButtonTap: AnyPublisher<Void, Never>
        let currentPageControlCount : AnyPublisher<Int, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let isFavorite: AnyPublisher<Bool, Never>
        let isBookmark: AnyPublisher<Bool, Never>
        let bookmarkButtonResult: AnyPublisher<Bool, Never>
        let nextButtonResult: AnyPublisher<Result<Bool, NetworkError>, Never>
        let currentPageControlCountResult: AnyPublisher<Int, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    private var selectedNoticeId: Int?
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
         checkAnnounceUseCase: CheckAnnounceUseCase
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
        return DetailAnnouceViewModel(
            type: type,
            selectedNoticeId: selectedNoticeId,
            likeAnnounceUseCase: LikeAnnounceUseCase(repository: repository),
            deleteLikeAnnounceUseCase: DeleteLikeAnnounceUseCase(repository: repository),
            bookmarkAnnounceUseCase: BookmarkAnnounceUseCase(repository: repository),
            deleteBookmarkAnnounceUseCase: DeleteBookmarkAnnounceUseCase(repository: repository),
            detailAnnounceUseCase: DetailAnnounceUseCase(repository: repository),
            checkAnnounceUseCase: CheckAnnounceUseCase(repository: NoticesRepositoryImpl())
        )
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
                        
                        let newData = self.sectionDataDict[.header]?.first as? DetailAnnouceHeaderModel
                        promise(.success(newData?.isBookmark ?? false))
                    }
                }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let isFavorite = sectionsData
            .compactMap { [weak self] _ -> Bool? in
                guard let headerData = self?.sectionDataDict[.header]?.first as? DetailAnnouceHeaderModel else { return nil }
                return headerData.isFavorite
            }
            .eraseToAnyPublisher()
            
        let isBookmark = sectionsData
            .compactMap { [weak self] _ -> Bool? in
                guard let headerData = self?.sectionDataDict[.header]?.first as? DetailAnnouceHeaderModel else { return nil }
                return headerData.isBookmark
            }
            .eraseToAnyPublisher()

        return Output(
            isFavorite: isFavorite,
            isBookmark: isBookmark,
            bookmarkButtonResult: bookmarkButtonResult,
            nextButtonResult: nextButtonResult,
            currentPageControlCountResult: input.currentPageControlCount
        )
    }
}

extension DetailAnnouceViewModel {
    
    func initializeData() async {
        switch detailAnnounceType {
        case .bookmarkAnnounce, .announce:
            await getDetailAnnounce()
            await checkDetailAnnounce()
        case .unreadAnnounce:
            await postUnreadAllAnnounce()
        }
    }
    
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
    
    func checkDetailAnnounce() async {
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
}

extension DetailAnnouceViewModel {
    
    private func likeActionHandler() async {
        guard let noticeId = selectedNoticeId,
              let headerData = sectionDataDict[.header]?.first as? DetailAnnouceHeaderModel else { return }
        
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
    
    private func bookmarkActionHandler() async {
        guard let noticeId = selectedNoticeId,
              let headerData = sectionDataDict[.header]?.first as? DetailAnnouceHeaderModel else { return }
        
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
        guard var headerData = sectionDataDict[.header]?.first as? DetailAnnouceHeaderModel else { return }
        
        headerData.isFavorite = isFavorite
        headerData.favoriteCount = isFavorite ? headerData.favoriteCount + 1 : headerData.favoriteCount - 1
        sectionDataDict[.header] = [headerData]
        getMySections()
    }
    
    private func updateHeaderBookmarkData(_ isBookmark: Bool) {
        guard var headerData = sectionDataDict[.header]?.first as? DetailAnnouceHeaderModel else { return }
        
        headerData.isBookmark = isBookmark
        headerData.bookmarkCount = isBookmark ? headerData.bookmarkCount + 1 : headerData.bookmarkCount - 1
        sectionDataDict[.header] = [headerData]
        getMySections()
    }
    
    private func updateHeaderWatchData() {
        guard var headerData = sectionDataDict[.header]?.first as? DetailAnnouceHeaderModel else { return }
        
        headerData.watchCount += 1
        sectionDataDict[.header] = [headerData]
        getMySections()
    }
    
    func getDetailAnnounce() async {
        guard let detailAnnounceUseCase, let selectedNoticeId else { return }
        
        switch await detailAnnounceUseCase.execute(noticeId: selectedNoticeId) {
        case .success(let response):
            sectionDataDict[.header] = [response.convertToHeader()]
            
            if let imageModels = response.convertToImages() {
                sectionDataDict[.images] = imageModels  // 배열 그대로 할당
            }
            
            sectionDataDict[.content] = [response.convertToContent()]
            
            getMySections()
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
    
    func postUnreadAllAnnounce() async {
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
    
    private func updateCurrentUnreadAnnounce() {
        guard currentIndex < announceList.count else { return }
        let currentAnnounce = announceList[currentIndex]
        selectedNoticeId = currentAnnounce.id
        sectionDataDict[.header] = [currentAnnounce.convertToHeader()]
        
        if let imageModels = currentAnnounce.convertToImages() {
            sectionDataDict[.images] = imageModels  // 배열 그대로 할당
        }
        sectionDataDict[.content] = [currentAnnounce.convertToContent()]
        
//        selectedNoticeId = currentAnnounce.id  // 현재 공지사항의 ID 업데이트
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
}
