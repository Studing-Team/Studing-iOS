//
//  FirstComeModalViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/24/25.
//

import Combine
import UIKit

import SnapKit
import Then

final class FirstComeModalViewController: BaseSheetViewController {
    
    // MARK: - Combine Properties
    
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, NetworkError>()
    private let findMyRankingSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private var firstComeModalViewModel: FirstComeModalViewModel
    private var contentConfiguration: FirstComeContentView
    
    // MARK: - Init
    
    init(firstComeModalViewModel: FirstComeModalViewModel) {
        self.firstComeModalViewModel = firstComeModalViewModel
        let content = FirstComeContentView(viewModel: firstComeModalViewModel)
        self.contentConfiguration = content
        
        // 클로저 없이 버튼 설정
        let buttonConfig = FirstComeButtonConfiguration()
        
        super.init(content: content, buttons: buttonConfig)
        
        // super.init 이후에 액션 설정
        buttonConfig.setCloseAction { [weak self] in
            self?.dismiss(animated: true)
        }
        
        buttonConfig.setMyRankingAction { [weak self] in
            self?.findMyRankingSubject.send()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("FirstComeModalViewController deinit")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Push FirstComeModalViewController")
        
        bindViewModel()
        viewLifeCycleSubject.send(.viewDidLoad)
    }
}

// MARK: - Private Bind Extensions

private extension FirstComeModalViewController {
    func bindViewModel() {
        let input = FirstComeModalViewModel.Input(
            viewLifeCycleEventAction: viewLifeCycleSubject.eraseToAnyPublisher(),
            findMyRankAction: findMyRankingSubject.eraseToAnyPublisher()
        )
        
        let output = firstComeModalViewModel.transform(input: input)
        
        output.firstComeRankingsResult
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] result in
                if result {
                    self?.contentConfiguration.updateCollectionView()
                }
            })
            .store(in: &cancellables)
        
        output.findMyRankResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let index = result else { return }
                self?.contentConfiguration.selectRank(at: index)
            }
            .store(in: &cancellables)
    }
}
