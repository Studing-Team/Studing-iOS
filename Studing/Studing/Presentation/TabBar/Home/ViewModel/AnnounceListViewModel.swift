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
        let refreshAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let associations: AnyPublisher<[AssociationEntity], Never>
        let allAnnounce: AnyPublisher<[AllAnnounceEntity], Never>
        let anthoerAnnounces: AnyPublisher<[AllAssociationAnnounceListEntity], Never>
        let bookmarks: AnyPublisher<[BookmarkListEntity], Never>
        let refreshResult: AnyPublisher<Bool, Never>
    }
    
    func transform(input: Input) -> Output {
    
        input.associationTap
            .map { [weak self] index -> String in
                guard let self else { return "" }
                
                let tapAssocation = associationsSubject.value[index]
                selectedAssociationSubject.send(tapAssocation.associationType?.typeName ?? "전체")
                
                let updateData = associationsSubject.value.enumerated().map { (i, entity) in
                    AssociationEntity(
                        name: entity.name,
                        image: entity.image,
                        associationType: entity.associationType,
                        isSelected: (i == index),
                        unRead: entity.unRead, 
                        isRegisteredDepartment: entity.isRegisteredDepartment
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
        
        let refreshResult = input.refreshAction
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Never> in
                
                guard let self else { return Just((false)).eraseToAnyPublisher() }
                
                let selectedAssociationName = self.selectedAssociationSubject.value
                
                return Future { promise in
                    Task {
                        var result: Result<Void, NetworkError>
                        
                        switch self.type {
                        case .association:
                            if selectedAssociationName == "전체" {
                                result = await self.getAllAnnounceList()
                            } else {
                                result = await self.getAllAssociationAnnounceList(name: selectedAssociationName)
                            }
                        case .bookmark:
                            result = await self.postBookmarkAssociationAnnounceList(name: selectedAssociationName)
                        }
                        
                        switch result {
                        case .success:
                            promise(.success(true))
                        case .failure:
                            promise(.success(false))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            
        return Output(
            associations: associationsSubject.eraseToAnyPublisher(),
            allAnnounce: allAnnouncesSubject.eraseToAnyPublisher(),
            anthoerAnnounces: associationAnnouncesSubject.eraseToAnyPublisher(),
            bookmarks: bookmarkListSubject.eraseToAnyPublisher(),
            refreshResult: refreshResult
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
            AssociationEntity(name: "전체", image: "", associationType: nil, isSelected: false, unRead: false, isRegisteredDepartment: true)
        )
        
        models.append(
            AssociationEntity(name: dto.universityName, image: dto.universityLogoImage, associationType: .generalStudents, isSelected: false, unRead: false, isRegisteredDepartment: true)
        )
        
        models.append(
            AssociationEntity(name: dto.collegeDepartmentName, image: dto.collegeDepartmentLogoImage, associationType: .college, isSelected: false, unRead: false, isRegisteredDepartment: true)
        )
        
        models.append(
            AssociationEntity(name: dto.departmentName, image: dto.departmentLogoImage ?? "", associationType: .major, isSelected: false, unRead: false, isRegisteredDepartment: dto.isRegisteredDepartment)
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
    
    func getAllAnnounceList() async -> Result<Void, NetworkError> {
        switch await allAnnounceListUseCase.execute() {
        case .success(let response):
            let data = response.toEntities()
            allAnnouncesSubject.send(data)
            
            return .success(())
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
            return .failure(error)
        }
    }
    
    func getAllAssociationAnnounceList(name: String) async -> Result<Void, NetworkError> {
        switch await allAssociationAnnounceListUseCase.execute(associationName: name) {
        case .success(let response):
            let data = response.toEntities()
            associationAnnouncesSubject.send(data)
            return .success(())
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
            return .failure(error)
        }
    }
    
    func postBookmarkAssociationAnnounceList(name: String) async -> Result<Void, NetworkError> {
        
        guard let bookmarkAssociationAnnounceListUseCase else { return .failure(.unknown) }
        
        switch await bookmarkAssociationAnnounceListUseCase.execute(associationName: name) {
        case .success(let response):
            let data = response.toEntities()
            bookmarkListSubject.send(data)
            return .success(())
            
        case .failure(let error):
            print("Error:", error.localizedDescription)
            return .failure(error)
        }
    }
}
