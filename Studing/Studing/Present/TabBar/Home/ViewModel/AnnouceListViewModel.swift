//
//  AnnouceListViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/22/24.
//

import Foundation
import Combine

final class AnnouceListViewModel: BaseViewModel {
    private let associationsSubject = CurrentValueSubject<[AssociationModel], Never>([])
    private let announcesSubject = CurrentValueSubject<[AssociationAnnounceListModel], Never>([])
    private let bookmarkSubject = CurrentValueSubject<[BookmarkModel], Never>([])
    
    struct Input {
        
    }
    
    struct Output {
        let associations: AnyPublisher<[AssociationModel], Never>
        let announces: AnyPublisher<[AssociationAnnounceListModel], Never>
        let bookmarks: AnyPublisher<[BookmarkModel], Never>
    }
    
    
    func transform(input: Input) -> Output {
    
        return Output(
            associations: associationsSubject.eraseToAnyPublisher(),
            announces: announcesSubject.eraseToAnyPublisher(),
            bookmarks: bookmarkSubject.eraseToAnyPublisher()
        )
    }
}

extension AnnouceListViewModel {
    func getMyAssociation() {
        
        let associationData = [AssociationModel(name: "전체", image: "AllAssociation", isSelected: true),
                               AssociationModel(name: "총학생회", image: "AllAssociation", isSelected: false),
                               AssociationModel(name: "조형대학", image: "AllAssociation", isSelected: false),
                               AssociationModel(name: "산업디자인", image: "AllAssociation", isSelected: false),
                               AssociationModel(name: "공과대학", image: "AllAssociation", isSelected: false)]
        
        associationsSubject.send(associationData)
    }
    
    func getAnnouceData() {
        let annouceData = [AssociationAnnounceListModel(type: .annouce, title: "[🎉어의대동제 아티스트 라인업 공개🎉]",
                                                    contents: "2024 어의대동제가 이제 정말 얼마 남지 않았는데요! 학우 여러분들이 가장 궁금해하실 아티스트 라",
                                                    days: "2024년 09월 19일",
                                                    favoriteCount: 10,
                                                    bookmarkCount: 5,
                                                    watchCount: 30,
                                                    isFavorite: false,
                                                    isBookmark: false),
                           AssociationAnnounceListModel(type: .event, title: "[🎉어의대동제 아티스트 라인업 공개🎉]",
                                                                       contents: "2024 어의대동제가 이제 정말 얼마 남지 않았는데요! 학우 여러분들이 가장 궁금해하실 아티스트 라",
                                                                       days: "2024년 09월 19일",
                                                                       favoriteCount: 10,
                                                                       bookmarkCount: 5,
                                                                       watchCount: 30,
                                                                       isFavorite: false,
                                                                       isBookmark: false),
                           AssociationAnnounceListModel(type: .annouce, title: "[🎉어의대동제 아티스트 라인업 공개🎉]",
                                                                       contents: "2024 어의대동제가 이제 정말 얼마 남지 않았는데요! 학우 여러분들이 가장 궁금해하실 아티스트 라",
                                                                       days: "2024년 09월 19일",
                                                                       favoriteCount: 10,
                                                                       bookmarkCount: 5,
                                                                       watchCount: 30,
                                                                       isFavorite: false,
                                                                       isBookmark: false),
                           AssociationAnnounceListModel(type: .event, title: "[🎉어의대동제 아티스트 라인업 공개🎉]",
                                                                       contents: "2024 어의대동제가 이제 정말 얼마 남지 않았는데요! 학우 여러분들이 가장 궁금해하실 아티스트 라",
                                                                       days: "2024년 09월 19일",
                                                                       favoriteCount: 10,
                                                                       bookmarkCount: 5,
                                                                       watchCount: 30,
                                                                       isFavorite: false,
                                                                       isBookmark: false),
                           AssociationAnnounceListModel(type: .event, title: "[🎉어의대동제 아티스트 라인업 공개🎉]",
                                                                       contents: "2024 어의대동제가 이제 정말 얼마 남지 않았는데요! 학우 여러분들이 가장 궁금해하실 아티스트 라",
                                                                       days: "2024년 09월 19일",
                                                                       favoriteCount: 10,
                                                                       bookmarkCount: 5,
                                                                       watchCount: 30,
                                                                       isFavorite: false,
                                                                       isBookmark: false),
                           AssociationAnnounceListModel(type: .event, title: "[🎉어의대동제 아티스트 라인업 공개🎉]",
                                                                       contents: "2024 어의대동제가 이제 정말 얼마 남지 않았는데요! 학우 여러분들이 가장 궁금해하실 아티스트 라",
                                                                       days: "2024년 09월 19일",
                                                                       favoriteCount: 10,
                                                                       bookmarkCount: 5,
                                                                       watchCount: 30,
                                                                       isFavorite: false,
                                                                       isBookmark: false)]
        
        announcesSubject.send(annouceData)
    }
    
    func getBookmarkData() {
        
        let bookmarkData = [BookmarkModel(association: "총학생회",
                                          title: "[🎉사전 이벤트 안내🎉]",
                                          contents: "다가오는 2024 서울과학기술대학교...",
                                          days: "2024년 09월 19일"),
                            BookmarkModel(association: "총학생회",
                                          title: "[🎉사전 이벤트 안내🎉]",
                                          contents: "다가오는 2024 서울과학기술대학교...",
                                          days: "2024년 09월 19일")]
        
        bookmarkSubject.send(bookmarkData)
    }
}
