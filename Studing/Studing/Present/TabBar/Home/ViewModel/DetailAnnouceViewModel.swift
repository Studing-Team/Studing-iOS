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
    
    // MARK: - Input
    
    struct Input {

    }
    
    // MARK: - Output
    
    struct Output {
        let annouceHeaderText: AnyPublisher<String, Never>
        let headerRightButtonTap: AnyPublisher<SectionType, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public methods
    
//    func transform(input: Input) -> Output {
//        
//    }
}

extension DetailAnnouceViewModel {
    func getDetailAnnoce() {
        
    }
    
    func convertHeaderData() {
        let headerData = [DetailAnnouceHeaderModel(name: "STation 총학생회", image: "", days: "2024년 09월 19일", favoriteCount: 0, bookmarkCount: 0, watchCount: 0, isFavorite: false, isBookmark: false)]
        
        sectionDataDict[.header] = headerData
    }
    
    func convertImageData() {
        let imageData = ["", "", ""].map { DetailAnnouceImageModel(image: $0) }
        
        sectionDataDict[.images] = imageData
    }
    
    func convertContentData() {
        let contentData = [DetailAnnouceContentModel(type: .annouce, title: "📢 2024 하반기 자치회비 납부 안내📢", content: "안녕하세요. 제40대 🚉STation🚉 총학생회입니다.\n\n우리 대학 학생회는 학우분들의 소중한 의견과 참여로 더욱 발전해 나가고 있습니다. 올해도 다양한  행사와 프로그램을 계획하고 있는데요, 이를 위해 자치회비의 납부가 필요합니다.\n\n🗓️ 납부 기간:2024.09.02 \n💰 납부 금액: 100,000원\n🏦 납부 방법: 계좌이체\n\n자치회비는 다음과 같은 활동에 사용됩니다:)\n🎉 학교 행사 지원: 다채로운 문화 행사, 체육 대회 등\n📚 학생 복지 프로그램: 학습 자료 지원, 멘토링 프로그램 운영 등\n💬 의견 수렴 및 피드백: 여러분의 목소리를 반영하는 다양한 활동 자치회비는 필수가 아닌 선택입니다.\n납부에 대한 궁금한 점이나 도움이 필요하신 경우, 언제든지 카카오톡 플러스 친구로 문의해 주세요.\n함께 만들어가는 멋진 학교 생활! 여러분의 많은 관심 부탁드립니다! 🙏")]
        
        sectionDataDict[.content] = contentData
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
