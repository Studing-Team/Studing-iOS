//
//  BookmarkAnnouceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/12/24.
//

import Foundation

final class BookmarkAnnounceListUseCase {
    private let repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<BookmarkAnnouceData, NetworkError> {
        return await repository.getBookmarkAnnouce()
    }
}
