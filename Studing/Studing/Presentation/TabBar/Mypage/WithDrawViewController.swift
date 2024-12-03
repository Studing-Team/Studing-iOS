//
//  WithDrawViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/26/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class WithDrawViewController: UIViewController {
    
    // MARK: - Properties
    
    private let withDrawViewModel: WithDrawViewModel
    weak var coordinator: MypageCoordinator?
    
    // MARK: - Combine Publishers Properties
    
    private var comfirmButtonTappend = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let backbutton = UIButton()
    private let drawInfoStackView = UIStackView()
    private let firstDrawInfoView = DrawInfoView(sectionType: .first)
    private let secondDrawInfoView = DrawInfoView(sectionType: .second)
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let cancelButton = UIButton()
    private let withDrawButton = UIButton()
    
    // MARK: - init
    
    init(withDrawViewModel: WithDrawViewModel,
         coordinator: MypageCoordinator) {
        self.withDrawViewModel = withDrawViewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black5
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let customNavController = self.navigationController as? CustomAnnouceNavigationController {
            customNavController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

// MARK: - Private Bind Extensions

private extension WithDrawViewController {
    func bindViewModel() {
        let input = WithDrawViewModel.Input(
            cancelButtonAction: cancelButton.tapPublisher,
            withDrawButtonAction: withDrawButton.tapPublisher,
            comfirmButtonAction: comfirmButtonTappend.eraseToAnyPublisher()
        )
        
        let output = withDrawViewModel.transform(input: input)
        
        output.cancelButtonResult
            .sink { [weak self] _ in
                if let customNavController = self?.navigationController as? CustomAnnouceNavigationController {
                    customNavController.popViewController(animated: true)
                } else {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
        
        output.withDrawButtonResult
            .sink { [weak self] _ in
                self?.showConfirmCancelAlert(
                    mainTitle: "잠깐만요",
                    subTitle: "모든 안내사항을 확인해주세요.\n탈퇴를 진행할까요?",
                    rightButtonTitle: "아니요",
                    leftButtonTitle: "탈퇴하기",
                    leftButtonHandler: {
                    self?.comfirmButtonTappend.send()
                })
            }
            .store(in: &cancellables)
        
        output.comfirmButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if result {
                    // 1. 현재 present된 ViewController가 CustomAlertViewController인지 확인
                    if let presentedVC = self?.presentedViewController as? CustomAlertViewController {
                        // 2. CustomAlertViewController dismiss
                        presentedVC.dismiss(animated: false) { [weak self] in
                            // 3. dismiss 완료 후 removeAuthUser 호출
                            if result {
                                self?.coordinator?.removeAuthUser()
                            }
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension WithDrawViewController {
    func setupStyle() {
//        backbutton.do {
//            $0.setTitleColor(.black50, for: .normal)
//            $0.setImage(UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)),
//                        for: .normal)
//            $0.tintColor = .black50
//            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        }
        
        titleLabel.do {
            $0.text = "탈퇴하기"
            $0.textColor = .black50
            $0.font = .interHeadline2()
        }
        
        subTitleLabel.do {
            $0.text = "잠깐! 스튜딩을 탈퇴하기 전에\n아래의 안내사항을 확인해주세요"
            $0.textColor = .black40
            $0.font = .interCaption16()
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        drawInfoStackView.do {
            $0.axis = .vertical
            $0.addArrangedSubviews(firstDrawInfoView, secondDrawInfoView)
            $0.spacing = 10
            $0.distribution = .fill
        }
        
        cancelButton.do {
            $0.setTitle("취소", for: .normal) // 버튼의 제목 설정
            $0.setTitleColor(.black20, for: .normal) // 제목 색상 설정
            $0.titleLabel?.font = .interSubtitle2() // 폰트 설정
            $0.backgroundColor = .white // 배경색 설정
            $0.layer.cornerRadius = 24
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.layer.borderWidth = 1
        }
        
        withDrawButton.do {
            $0.setTitle("탈퇴할게요", for: .normal) // 버튼의 제목 설정
            $0.setTitleColor(.white, for: .normal) // 제목 색상 설정
            $0.titleLabel?.font = .interSubtitle2() // 폰트 설정
            $0.backgroundColor = .primary50 // 배경색 설정
            $0.layer.cornerRadius = 24
        }
    }
    
    func setupHierarchy() {
//        view.addSubviews(backbutton, titleLabel, subTitleLabel, drawInfoStackView, cancelButton, withDrawButton)
        view.addSubviews(titleLabel, subTitleLabel, drawInfoStackView, cancelButton, withDrawButton)
    }
    
    func setupLayout() {
//        backbutton.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
//            $0.leading.equalToSuperview().inset(20)
//        }
        
        titleLabel.snp.makeConstraints {
//            $0.top.equalTo(backbutton.snp.bottom).offset(50)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        drawInfoStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(view.convertByWidthRatio(15))
            $0.bottom.equalToSuperview().inset(34)
            $0.width.equalTo(view.convertByWidthRatio(167))
            $0.height.equalTo(48)
        }
        
        withDrawButton.snp.makeConstraints {
            $0.leading.equalTo(cancelButton.snp.trailing).offset(view.convertByWidthRatio(11))
            $0.trailing.equalToSuperview().inset(view.convertByWidthRatio(15))
            $0.bottom.equalToSuperview().inset(34)
            $0.width.equalTo(view.convertByWidthRatio(167))
            $0.height.equalTo(48)
        }
        
        firstDrawInfoView.snp.makeConstraints {
            $0.height.equalTo(119)
        }

        secondDrawInfoView.snp.makeConstraints {
            $0.height.equalTo(119)
        }
    }
    
    func setupDelegate() {
        
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
