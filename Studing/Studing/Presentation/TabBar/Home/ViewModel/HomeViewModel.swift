//
//  HomeViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/20/24.
//

import Foundation
import Combine

struct HeaderButtonAction {
    let type: SectionType
    let associationName: String?
}



final class HomeViewModel: BaseViewModel {
    
    var sectionsData = CurrentValueSubject<[SectionType]?, Never>(nil)
    var selectedAssociationTitle = CurrentValueSubject<String, Never>("")
    
    var sectionDataDict: [SectionType: [any HomeSectionData]] = [:]
    
    var sectionUpdatePublisher = PassthroughSubject<SectionType, Never>()
    var associationUpdatePublisher = PassthroughSubject<[IndexPath], Never>()
    
    var selectedAssociationType = ""
    
    // MARK: - Input
    
    struct Input {
        let associationTap: AnyPublisher<Int, Never>
        let headerRightButtonTap: AnyPublisher<SectionType, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let annouceHeaderText: AnyPublisher<String, Never>
        let headerRightButtonTap: AnyPublisher<HeaderButtonAction?, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let associationLogoUseCase: AssociationLogoUseCase
    private let unreadAssociationUseCase: UnreadAssociationUseCase
    private let unreadAssociationAnnouceCountUseCase: UnreadAssociationAnnounceCountUseCase
    private let recentAnnouceUseCase: RecentAnnounceUseCase
    private let bookmarkAnnouceUseCase: BookmarkAnnounceListUseCase
    
    init(associationLogoUseCase: AssociationLogoUseCase,
         unreadAssociationUseCase: UnreadAssociationUseCase,
         unreadAssociationAnnouceCountUseCase: UnreadAssociationAnnounceCountUseCase,
         recentAnnouceUseCase: RecentAnnounceUseCase,
         bookmarkAnnouceUseCase: BookmarkAnnounceListUseCase
    ) {
        self.associationLogoUseCase = associationLogoUseCase
        self.unreadAssociationUseCase = unreadAssociationUseCase
        self.unreadAssociationAnnouceCountUseCase = unreadAssociationAnnouceCountUseCase
        self.recentAnnouceUseCase = recentAnnouceUseCase
        self.bookmarkAnnouceUseCase = bookmarkAnnouceUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        input.associationTap
            .compactMap { [weak self] index -> String? in
                guard let self else { return nil }
                
                if let associationData = self.sectionDataDict[.association] as? [AssociationEntity] {
                    // 새로운 배열 생성
                    let updatedData = associationData.enumerated().map { (i, entity) in
                        // 각 엔티티의 모든 속성을 유지하면서 isSelected만 업데이트
                        AssociationEntity(
                            name: entity.name,
                            image: entity.image, 
                            associationType: entity.associationType,
                            isSelected: (i == index)
                        )
                    }
                    
                    self.sectionDataDict[.association] = updatedData
                    self.sectionUpdatePublisher.send(.association)
                    self.selectedAssociationTitle.send(updatedData[index].name)
                    
                    if updatedData[index].associationType != nil {
                        return updatedData[index].associationType?.typeName
                    } else {
                        return updatedData[index].name
                    }
                }
                return nil
            }
            .sink { [weak self] name in
                guard let self = self else { return }
                selectedAssociationType = name
                // API 동시 호출
                Task {
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask { await self.getAnnouceInfo(name: name) }
                        group.addTask { await self.getMissAnnouceInfo(name: name) }
                    }
                    
                    self.sectionUpdatePublisher.send(.missAnnouce)
                    self.sectionUpdatePublisher.send(.annouce)
                }
            }
            .store(in: &cancellables)
        
        let rightButtonTap = input.headerRightButtonTap
            .map { [weak self] type -> HeaderButtonAction? in
                guard let self = self else {
                    // self가 없더라도 기본값 반환
                    return HeaderButtonAction(type: type, associationName: nil)
                }
                
                switch type {
                case .annouce:
                    let associationType = (self.sectionDataDict[.association] as? [AssociationEntity])?
                        .first(where: { $0.isSelected })?
                        .associationType
                    
                    let selectAssociationName = associationType == nil ? "전체" : associationType?.typeName
                    
                    return HeaderButtonAction(type: type, associationName: selectAssociationName)
                    
                case .bookmark:
                    return HeaderButtonAction(type: type, associationName: nil)
                    
                default:
                    return nil
                }
            }
        
        return Output(
            annouceHeaderText: selectedAssociationTitle.eraseToAnyPublisher(),
            headerRightButtonTap: rightButtonTap.eraseToAnyPublisher()
        )
    }
}

extension HomeViewModel {
    func getMissAnnouceInfo(name: String) async {
        switch await unreadAssociationAnnouceCountUseCase.execute(associationName: name) {
        case .success(let response):
            
            if response.categorieCount != 0 {
                sectionDataDict[.missAnnouce] = [MissAnnounceEntity(userName: "상우", missAnnounceCount: response.categorieCount)]
            } else {
                sectionDataDict.removeValue(forKey: .missAnnouce)
            }
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
    
    func getMyAssociationInfo() async {
        switch await associationLogoUseCase.execute() {
        case .success(let response):
            let convertData = convertToAssociationModels(from: response)
            sectionDataDict[.association] = convertData
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
    
    func getAnnouceInfo(name: String) async {
        switch await recentAnnouceUseCase.execute(associationName: name) {
        case .success(let response):
            let convertData = convertAssociationAnnounceEntity(response.notices)
            sectionDataDict[.annouce] = convertData
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }

    func getMyBookmarkInfo() async {
        switch await bookmarkAnnouceUseCase.execute() {
        case .success(let response):
            
            let convertData = convertBookmarkAnnounceEntity(response.notices)
            sectionDataDict[.bookmark] = convertData
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
    
    func getUnreadAssociationInfo() async {
        switch await unreadAssociationUseCase.execute() {
        case .success(let response):
            let unreadAsoociation = response.categories
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
    
    func getMySections() {
        var currentSections: [SectionType] = []

        print("🔍 섹션 구성 시작")
        for type in SectionType.allCases {
            
            switch type {
            case .bookmark :
                if let bookmarkItems = sectionDataDict[type], !bookmarkItems.isEmpty {
                    currentSections.append(.bookmark)
                    print("- bookmark 섹션 추가됨 (데이터 수: \(bookmarkItems.count))")
                }
                
            case .annouce:
                currentSections.append(.annouce)
                if let announceItems = sectionDataDict[type], !announceItems.isEmpty {
                    print("- announce 섹션 추가됨 (데이터 수: \(announceItems.count))")
                } else {
                    print("- announce 섹션 추가됨 (데이터 없음)")
                }
                
            case .emptyBookmark:
                if !currentSections.contains(.bookmark) {
                    currentSections.append(.emptyBookmark)
                    print("- emptyBookmark 섹션 추가됨 (데이터 1개)")
                }
                
            default:
                if let items = sectionDataDict[type], !items.isEmpty {
                    currentSections.append(type)
                    print("- \(type) 섹션 추가됨 (데이터 수: \(items.count))")
                } else {
                    print("- \(type) 섹션 스킵됨 (데이터 없음)")
                }
            }
        }

        sectionsData.send(currentSections.isEmpty ? nil : currentSections)
    }
}

extension HomeViewModel {
    func convertBookmarkAnnounceEntity(_ data: [BookmarkAnnouceResponseDTO]) -> [BookmarkAnnounceEntity] {
        let convertData = data.map {
            $0.toEntity()
        }
        
        return convertData
    }
    
    func convertToAssociationModels(from dto: UniversityLogoResponseDTO) -> [AssociationEntity] {
        var models: [AssociationEntity] = []
        
        models.append(
            AssociationEntity(name: "전체", image: "", associationType: nil, isSelected: true)
        )
        
        models.append(
            AssociationEntity(name: dto.universityName, image: dto.universityLogoImage, associationType: .generalStudents, isSelected: false)
        )
        
        models.append(
            AssociationEntity(name: dto.collegeDepartmentName, image: dto.collegeDepartmentLogoImage, associationType: .college, isSelected: false)
        )
        
        models.append(
            AssociationEntity(name: dto.departmentName, image: dto.departmentLogoImage ?? "", associationType: .major, isSelected: false)
        )
        
        return models
    }
    
    func convertAssociationAnnounceEntity(_ data: [AnnouncementResponseDTO]) -> [AssociationAnnounceEntity] {
        let convertData = data.map {
            $0.toEntity()
        }
        
        return convertData
    }
}
