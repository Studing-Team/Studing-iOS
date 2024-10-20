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
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        /// 학생회를 탭했을 때  sectionDataDict 에서 key 값이 association 인 의 데이터 중 name 을 반환
        /// selectedAssociationTitle 라는 CurrentValueSubject 에 name 을 보내고  공지사항 Header 에 학생회 이름을 할당
        let associationTitle = input.associationTap
            .compactMap { [weak self] index -> String? in
                guard let self else { return nil }
                
                if var associationData = self.sectionDataDict[.association] as? [AssociationModel] {
                    // 모든 항목의 isSelected를 false로 설정
                    for i in 0..<associationData.count {
                        associationData[i].isSelected = (i == index)
                    }
                    
                    // 업데이트된 데이터를 다시 저장
                    self.sectionDataDict[.association] = associationData
                    
                    // sectionsData를 업데이트하여 UI 갱신 트리거
                    if let currentSections = self.sectionsData.value {
                        self.sectionsData.send(currentSections)
                    }
                    
                    // 선택된 항목의 이름 반환
                    return associationData[index].name
                }
                return nil
            }
            .handleEvents(receiveOutput: { [weak self] name in
                self?.selectedAssociationTitle.send(name)
            })
            .eraseToAnyPublisher()
        
        return Output(annouceHeaderText: associationTitle.eraseToAnyPublisher(),
                      headerRightButtonTap: input.headerRightButtonTap.eraseToAnyPublisher())
    }
}


extension HomeViewModel {
    func getMissAnnouce() {
        let annouceData = [MissAnnounceModel(userName: "상우", missAnnounceCount: 7)]
        
        sectionDataDict[.missAnnouce] = annouceData
    }
    
    func getMyAssociation() {
        
        let associationData = [AssociationModel(name: "전체", image: "AllAssociation", isSelected: true),
                               AssociationModel(name: "총학생회", image: "AllAssociation", isSelected: false),
                               AssociationModel(name: "조형대학", image: "AllAssociation", isSelected: false),
                               AssociationModel(name: "산업디자인", image: "AllAssociation", isSelected: false),
                               AssociationModel(name: "공과대학", image: "AllAssociation", isSelected: false)]
        
        sectionDataDict[.association] = associationData
    }
    
    func getAnnouceData() {
        let annouceData = [AssociationAnnounceModel(title: "[🎉어의대동제 아티스트 라인업 공개🎉]",
                                                    contents: "2024 어의대동제가 이제 정말 얼마 남지 않았는데요! 학우 여러분들이 가장 궁금해하실 아티스트 라",
                                                    days: "2024년 09월 19일",
                                                    favoriteCount: 10,
                                                    bookmarkCount: 5,
                                                    watchCount: 30,
                                                    isFavorite: false,
                                                    isBookmark: false),
                           AssociationAnnounceModel(title: "[🎉어의대동제 아티스트 라인업 공개🎉]",
                                                                       contents: "2024 어의대동제가 이제 정말 얼마 남지 않았는데요! 학우 여러분들이 가장 궁금해하실 아티스트 라",
                                                                       days: "2024년 09월 19일",
                                                                       favoriteCount: 10,
                                                                       bookmarkCount: 5,
                                                                       watchCount: 30,
                                                                       isFavorite: false,
                                                                       isBookmark: false)]
        
        sectionDataDict[.annouce] = annouceData
    }
    
    func getMyBookmark() {
        
        let bookmarkData = [BookmarkModel(association: "총학생회",
                                          title: "[🎉사전 이벤트 안내🎉]",
                                          contents: "다가오는 2024 서울과학기술대학교...",
                                          days: "2024년 09월 19일"),BookmarkModel(association: "총학생회",
                                                                               title: "[🎉사전 이벤트 안내🎉]",
                                                                               contents: "다가오는 2024 서울과학기술대학교...",
                                                                               days: "2024년 09월 19일")]
        
        sectionDataDict[.bookmark] = bookmarkData
    }
    
    func getMySections() {
        var currentSections: [SectionType] = []

        // 섹션 타입 순서대로 추가
        for type in SectionType.allCases {
            if let items = sectionDataDict[type], !items.isEmpty {
                currentSections.append(type)
            }
        }

        sectionsData.send(currentSections.isEmpty ? nil : currentSections)
    }
}
