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
            .flatMap { [weak self] _ -> AnyPublisher<Result<Bool, NetworkError>, Never> in
                guard let self else { return Just((.failure(NetworkError.unknown))).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        if self.unReadCount == 0 {
                            promise(.success(.success(false)))
                        }
                        
                        let result = await self.checkUnAnnounce()
                        switch result {
                        case .success:
                            promise(.success(.success(true)))
                        case .failure(let error):
                            promise(.success(.failure(error)))
                        }
                    }
                }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        input.likeButtonTap
            .sink { [weak self] _ in
                guard let self else { return }
                
                Task {
                    await self.likeActionHandler()
                }
            }
            .store(in: &cancellables)
        
        let bookmarkButtonResult = input.bookmarkButtonTap
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
    
    
    
    
    
    
    
    
//    func convertHeaderData() {
//        let headerData = [DetailAnnouceHeaderModel(name: "STation 총학생회", image: "", days: "2024년 09월 19일", favoriteCount: 0, bookmarkCount: 0, watchCount: 0, isFavorite: false, isBookmark: false)]
//        
//        sectionDataDict[.header] = headerData
//    }
//    
//    func convertImageData() {
//        let imageData = ["", "", ""].map { DetailAnnouceImageModel(image: $0) }
//        
//        sectionDataDict[.images] = imageData
//    }
//    
//    func convertContentData() {
//        let contentData = [DetailAnnouceContentModel(type: .annouce, title: "📢 2024 하반기 자치회비 납부 안내📢", content: "안녕하세요. 제40대 🚉STation🚉 총학생회입니다.\n\n우리 대학 학생회는 학우분들의 소중한 의견과 참여로 더욱 발전해 나가고 있습니다. 올해도 다양한  행사와 프로그램을 계획하고 있는데요, 이를 위해 자치회비의 납부가 필요합니다.\n\n🗓️ 납부 기간:2024.09.02 \n💰 납부 금액: 100,000원\n🏦 납부 방법: 계좌이체\n\n자치회비는 다음과 같은 활동에 사용됩니다:)\n🎉 학교 행사 지원: 다채로운 문화 행사, 체육 대회 등\n📚 학생 복지 프로그램: 학습 자료 지원, 멘토링 프로그램 운영 등\n💬 의견 수렴 및 피드백: 여러분의 목소리를 반영하는 다양한 활동 자치회비는 필수가 아닌 선택입니다.\n납부에 대한 궁금한 점이나 도움이 필요하신 경우, 언제든지 카카오톡 플러스 친구로 문의해 주세요.\n함께 만들어가는 멋진 학교 생활! 여러분의 많은 관심 부탁드립니다! 🙏")]
//        
//        sectionDataDict[.content] = contentData
//    }
    
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
