//
//  AnnouceListViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/22/24.
//

import Foundation
import Combine

final class AnnounceListViewModel: BaseViewModel {
    
    // MARK: - Combine properties
    
    var associationsSubject = CurrentValueSubject<[AssociationEntity], Never>([])
    var selectedAssociationSubject = CurrentValueSubject<String, Never>("")
    
    var allAnnouncesSubject = CurrentValueSubject<[AllAnnounceEntity], Never>([])
    var associationAnnouncesSubject = CurrentValueSubject<[AllAssociationAnnounceListEntity], Never>([])
    var bookmarkListSubject = CurrentValueSubject<[BookmarkListEntity], Never>([])
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Private properties
    
    private var type: AnnounceListType
    private let associationLogoUseCase: AssociationLogoUseCase
    private let allAnnounceListUseCase: AllAnnounceListUseCase
    private let allAssociationAnnounceListUseCase: AllAssociationAnnounceListUseCase
    private let bookmarkAssociationAnnounceListUseCase: BookmarkAssociationAnnounceListUseCase?
    
    private let selectAssicationName: String

    init(type: AnnounceListType,
        associationLogoUseCase: AssociationLogoUseCase,
         allAnnounceListUseCase: AllAnnounceListUseCase,
         allAssociationAnnounceListUseCase: AllAssociationAnnounceListUseCase,
         bookmarkAssociationAnnounceListUseCase: BookmarkAssociationAnnounceListUseCase? = nil,
         assicationName: String? = nil
    ) {
        self.type = type
        self.associationLogoUseCase = associationLogoUseCase
        self.allAnnounceListUseCase = allAnnounceListUseCase
        self.allAssociationAnnounceListUseCase = allAssociationAnnounceListUseCase
        self.bookmarkAssociationAnnounceListUseCase = bookmarkAssociationAnnounceListUseCase
        self.selectAssicationName = assicationName ?? ""

        print("AnnounceListViewModel init")
    }
    
    deinit {
        print("AnnounceListViewModel deinit")
    }

    // MARK: - Input
    
    struct Input {
        let associationTap: AnyPublisher<Int, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let associations: AnyPublisher<[AssociationEntity], Never>
        let allAnnounce: AnyPublisher<[AllAnnounceEntity], Never>
        let anthoerAnnounces: AnyPublisher<[AllAssociationAnnounceListEntity], Never>
        let bookmarks: AnyPublisher<[BookmarkListEntity], Never>
    }
    
    func transform(input: Input) -> Output {
    
        input.associationTap
            .map { [weak self] index -> String in
                guard let self else { return "" }
                
                let tapAssocation = associationsSubject.value[index]
                
                let updateData = associationsSubject.value.enumerated().map { (i, entity) in
                    AssociationEntity(
                        name: entity.name,
                        image: entity.image,
                        associationType: entity.associationType,
                        isSelected: (i == index)
                    )
                }
                
                associationsSubject.send(updateData)
                
                if let name = tapAssocation.associationType?.typeName {
                    return name
                } else {
                    return tapAssocation.name
                }
            }
            .sink { [weak self] name in
                guard let self else { return }
                
//                selectedAssociationSubject.send(name)
                
                switch type {
                case .association:
                    Task {
                        if name == "전체" {
                            await self.getAllAnnounceList()
                        } else {
                            await self.getAllAssociationAnnounceList(name: name)
                        }
                    }
                case .bookmark:
                    Task {
                        await self.postBookmarkAssociationAnnounceList(name: name)
                    }
                }
            }
            .store(in: &cancellables)
        
        return Output(
            associations: associationsSubject.eraseToAnyPublisher(),
            allAnnounce: allAnnouncesSubject.eraseToAnyPublisher(),
            anthoerAnnounces: associationAnnouncesSubject.eraseToAnyPublisher(),
            bookmarks: bookmarkListSubject.eraseToAnyPublisher()
        )
    }
}

extension AnnounceListViewModel {
    func fetchAllAssociationInitialData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.getMyAssociationInfo() }
            group.addTask { await self.getAllAnnounceList() }
        }
    }
    
    func fetchAssociationInitialData(name: String) async {
        await self.getMyAssociationInfo()
    }
}

extension AnnounceListViewModel {
    func convertToAssociationModels(from dto: UniversityLogoResponseDTO) -> [AssociationEntity] {
        var models: [AssociationEntity] = []
        
        models.append(
            AssociationEntity(name: "전체", image: "", associationType: nil, isSelected: false)
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
    
    func getMyAssociationInfo() async {
        switch await associationLogoUseCase.execute() {
        case .success(let response):
            let convertData = convertToAssociationModels(from: response)
            associationsSubject.send(convertData)
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
    
    func getAllAnnounceList() async {
        switch await allAnnounceListUseCase.execute() {
        case .success(let response):
            let data = response.toEntities()
            allAnnouncesSubject.send(data)
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
    
    func getAllAssociationAnnounceList(name: String) async {
        switch await allAssociationAnnounceListUseCase.execute(associationName: name) {
        case .success(let response):
            let data = response.toEntities()
            associationAnnouncesSubject.send(data)
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
    
    func postBookmarkAssociationAnnounceList(name: String) async {
        
        guard let bookmarkAssociationAnnounceListUseCase else { return }
        
        switch await bookmarkAssociationAnnounceListUseCase.execute(associationName: name) {
        case .success(let response):
            let data = response.toEntities()
            bookmarkListSubject.send(data)
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
        }
    }
}
