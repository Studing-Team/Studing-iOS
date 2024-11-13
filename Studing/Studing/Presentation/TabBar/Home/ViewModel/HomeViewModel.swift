//
//  HomeViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/20/24.
//

import Foundation
import Combine

final class HomeViewModel: BaseViewModel {
    
    var sectionsData = CurrentValueSubject<[SectionType]?, Never>(nil)
    var selectedAssociationTitle = CurrentValueSubject<String, Never>("")
    
    var sectionDataDict: [SectionType: [any HomeSectionData]] = [:]
    
    var sectionUpdatePublisher = PassthroughSubject<SectionType, Never>()
    var associationUpdatePublisher = PassthroughSubject<[IndexPath], Never>()
    
    // MARK: - Input
    
    struct Input {
        let associationTap: AnyPublisher<Int, Never>
        let headerRightButtonTap: AnyPublisher<SectionType, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let annouceHeaderText: AnyPublisher<String, Never>
        let headerRightButtonTap: AnyPublisher<SectionType, Never>
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
        
//        input.associationTap
//            .map { [weak self] index -> String in
//                
//                guard let self = self, let associationData = self.sectionDataDict[.association] as? [AssociationEntity] else { return "" }
//                
//                selectedAssociationTitle.send(associationData[index].name)
//                
//                return associationData[index].name
//            }
//            .flatMap { name -> AnyPublisher<(AnnounceInfo, MissAnnounceInfo), Error> in
//                
//                
//            }
        
//        input.associationTap
//            .sink { [weak self] index in
//                guard let self = self,
//                      let associationData = self.sectionDataDict[.association] as? [AssociationEntity]
//                else { return }
//                
//                var updatedData = associationData
//                var changedItemIndexPaths: [IndexPath]
//                
//                let sectionNumber = Int(sectionsData.value?.firstIndex(of: .association) ?? 0)
//                
//                let previouseSelectedIndex = Int(associationData.firstIndex(where: { $0.isSelected }) ?? 0)
//                
//                if previouseSelectedIndex == index {
//                    // 똑같은 셀을 눌렀을 때
//                } else {
//                    updatedData[previouseSelectedIndex].isSelected = false
//                    updatedData[index].isSelected = true
//                    
//                    changedItemIndexPaths = [IndexPath(row: index, section: sectionNumber)]
//                    changedItemIndexPaths.append(IndexPath(row: previouseSelectedIndex, section: sectionNumber))
//                    
//                    
//                }
//            }
//            .store(in: &cancellables)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        /// 학생회를 탭했을 때  sectionDataDict 에서 key 값이 association 인 의 데이터 중 name 을 반환
//        /// selectedAssociationTitle 라는 CurrentValueSubject 에 name 을 보내고  공지사항 Header 에 학생회 이름을 할당
//        // association tap 처리
//        input.associationTap
//            .sink { [weak self] index in
//                guard let self = self,
//                      let associationData = self.sectionDataDict[.association] as? [AssociationEntity]
//                else { return }
//                
//                
//                var updatedData = associationData
//                var changedItemIndexPaths: [IndexPath]
//                
//                let sectionNumber = Int(sectionsData.value?.firstIndex(of: .association) ?? 0)
//                
//                let previouseSelectedIndex = Int(associationData.firstIndex(where: { $0.isSelected }) ?? 0)
//                
//                if previouseSelectedIndex == index {
//                    // 똑같은 셀을 눌렀을 때
//                } else {
//                    updatedData[previouseSelectedIndex].isSelected = false
//                    updatedData[index].isSelected = true
//                    
//                    changedItemIndexPaths = [IndexPath(row: index, section: sectionNumber)]
//                    changedItemIndexPaths.append(IndexPath(row: previouseSelectedIndex, section: sectionNumber))
//                }
//                
////                let updatedData = associationData.enumerated().map { (i, entity) in
////                    var updatedEntity = entity
////                    updatedEntity.isSelected = (i == index)
////                    return updatedEntity
////                }
//                
//                self.sectionDataDict[.association] = updatedData
//                self.sectionUpdatePublisher.send(.association)
//                
//                if let selectedAssociation = updatedData.first(where: { $0.isSelected }) {
//                    self.selectedAssociationTitle.send(selectedAssociation.name)
//                    
//                    Task {
//                        await withTaskGroup(of: Void.self) { group in
//                            group.addTask { await self.getAnnouceInfo(name: selectedAssociation.name) }
//                            group.addTask { await self.getMissAnnouceInfo(name: selectedAssociation.name) }
//                        }
//                        
//                        self.sectionUpdatePublisher.send(.annouce)
//                        self.sectionUpdatePublisher.send(.missAnnouce)
//                        
//                    }
//                }
//            }
//            .store(in: &cancellables)
        
        
        input.associationTap
            .compactMap { [weak self] index -> String? in
//                guard let self = self,
//                      let associationData = self.sectionDataDict[.association] as? [AssociationEntity]
//                else { return nil }
//                
//                // 선택 상태 업데이트
//                let updatedData = associationData.enumerated().map { (i, entity) in
//                    var updatedEntity = entity
//                    updatedEntity.isSelected = (i == index)
//                    print("\(index) 업데이트")
//                    return updatedEntity
//                }
//                
//                self.sectionDataDict[.association] = updatedData
//                
//                self.sectionUpdatePublisher.send(.association)
//                self.selectedAssociationTitle.send(associationData[index].name)
//                
//                return associationData[index].name
                guard let self = self else { return nil }
                
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
                    
                    // 업데이트된 데이터 저장
                    self.sectionDataDict[.association] = updatedData
                    
                    // UI 갱신 트리거
//                    if let currentSections = self.sectionsData.value {
//                        self.sectionsData.send(currentSections)
//                    }
                    self.sectionUpdatePublisher.send(.association)
                    // selectedAssociationTitle 업데이트
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
        
        return Output(
            annouceHeaderText: selectedAssociationTitle.eraseToAnyPublisher(),
            headerRightButtonTap: input.headerRightButtonTap.eraseToAnyPublisher()
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
    
    func convertToAssociationType(_ affiliation: String) -> AssociationType {
        
        let lastTwoCharacters = String(affiliation.suffix(2))
        
        if lastTwoCharacters == "대학" {
            return .college
        } else if lastTwoCharacters == "생회" {
            return .generalStudents
        } else {
            return .major
        }
    }
}
