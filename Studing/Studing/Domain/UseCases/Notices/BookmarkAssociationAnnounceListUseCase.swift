//
//  BookmarkAssociationAnnounceListUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

final class BookmarkAssociationAnnounceListUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(associationName: String) async -> Result<BookmarkAssociationAnnounceListResponseData,NetworkError> {
        return await repository.postBookmarkAssociationAnnounce(associationName: associationName)
    }
}
