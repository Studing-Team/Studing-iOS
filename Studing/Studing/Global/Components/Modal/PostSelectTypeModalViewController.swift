//
//  PostSelectTypeModalViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/12/25.
//

import UIKit

import SnapKit
import Then

final class PostSelectTypeModalViewController: SingleButtonSheetViewController {
    
    // MARK: - Properties
    
    weak var coordinator: HomeCoordinator?
    
    private var postFirstSectionTapAction: (() -> Void)?
    private var postAnnounceSectionTapAction: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let postSectionStackView = UIStackView()
    private let postFirstSectionView = PostModalSectionView(type: .firstCome)
    private let postAnnounceSectionView = PostModalSectionView(type: .announce)
        
    // MARK: - Init
        
    init(
        coordinator: HomeCoordinator,
        firstSectionTap: (() -> Void)?,
        announceSectionTap: (() -> Void)?
    ) {
        super.init(
            buttonStyle: .close(type: .blue)
        )
        
        self.coordinator = coordinator
        self.postFirstSectionTapAction = firstSectionTap
        self.postAnnounceSectionTapAction = announceSectionTap

        self.bindingBottomButtonAction(action: { [weak self] in
            self?.dismiss(animated: true)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    func bindingFirstSectionTap(action: (() -> Void)?) {
        postFirstSectionTapAction = {
            self.dismiss(animated: true)
        }
    }
    
    func bindingAnnounceSectionTap(action: (() -> Void)?) {
        postAnnounceSectionTapAction = {
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Private Extensions

private extension PostSelectTypeModalViewController {
    func setupStyle() {
        postSectionStackView.do {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.spacing = 8
            $0.addArrangedSubviews(postFirstSectionView, postAnnounceSectionView)
        }
        
        titleLabel.do {
            $0.text = "알맞는 공지사항으로 작성해요!"
            $0.font = .interSubtitle1()
            $0.textColor = .black50
        }
        
        postFirstSectionView.do {
            $0.layer.cornerRadius = 12
            $0.addTapAnimation {
                self.dismiss(animated: true)
                self.postFirstSectionTapAction?()
            }
        }
        
        postAnnounceSectionView.do {
            $0.layer.cornerRadius = 12
            $0.addTapAnimation {
                self.dismiss(animated: true)
                self.postAnnounceSectionTapAction?()
            }
        }
    }
    
    func setupHierarchy() {
        self.contentAreaView.addSubviews(titleLabel, postSectionStackView)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.horizontalEdges.equalToSuperview().inset(26)
        }
        
        postSectionStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(view.convertByHeightRatio(36))
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        postFirstSectionView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        postAnnounceSectionView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    func setupDelegate() {
        
    }
}
