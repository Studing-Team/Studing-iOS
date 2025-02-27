//
//  DetailAnnouceHeaderCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import UIKit

import SnapKit
import Then

protocol FirstComeButtonTappedDelegate: AnyObject {
    func didFirstComeButtonTapped(buttonState: FirstComeState)
}

final class DetailAnnouceHeaderCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: FirstComeButtonTappedDelegate?
    
    private var headerType: PostOptionType?
    
    // MARK: - UI Properties
    
    private let headerStackView = UIStackView() // 전체 StackView 여백 (상하 15, 좌우 18 )
    private let headerTitleStackView = UIStackView() // 상단 StackView 총 55
    private let periodSectionStackView = UIStackView() // 하단 StackView (기간, 버튼) 총 122 , 좌우 2 여백

    let flexibleSpaceView1 = UIView()
    let flexibleSpaceView2 = UIView()
    let flexibleSpaceView3 = UIView()
    
    private let associationLogoImage = AFImageView()
    private let associationName = UILabel()
    private let postDayLabel = UILabel()
    private let contentInfoView = ContentInfoView()
    private let spacerView = UIView()
    
    private let associationInfoContainerView = UIView()
    private let associationInfoStackView = UIStackView()
    private let announceTimeStackView = UIStackView()
    
    private let firstComeNumberLabel = UILabel()
    private let firstComeIndexLabel = UILabel()
    private let startIndexLabel = UILabel()
    private var startTimeLabel = UILabel()
    
    private let endIndexLabel = UILabel()
    private var endTimeLabel = UILabel()
    
    private let periodTitleStackView = UIStackView()
    private let startStackView = UIStackView()
    private let endStackView = UIStackView()
    
    private let firstComeButton = FirstComeButton(buttonState: .active)
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailAnnouceHeaderCollectionViewCell {
    func setupHeader() {
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupHiddenForType()
    }
    
    func setupHiddenForType() {
        guard let headerType else { return }
        
        switch headerType {
        case .basic:
            periodSectionStackView.isHidden = true
            firstComeButton.isHidden = true
        case .firstCome:
            periodSectionStackView.isHidden = false
            firstComeButton.isHidden = false
        case .period:
            periodSectionStackView.isHidden = false
            firstComeButton.isHidden = true
        }
    }
    
    /// 기간이 존재하지 않은 공지사항 관련 Header
    func configureCell(forModel model: BaseDetailAnnounceHeaderModel) {
        headerType = .basic
        associationLogoImage.setImage(model.image, type: .associationLogo)
        associationName.text = model.name
        postDayLabel.text = model.days
        
        contentInfoView.configureData(model.favoriteCount,
                                      model.bookmarkCount,
                                      model.watchCount,
                                      model.isFavorite,
                                      model.isBookmark)
        
        setupHeader()
    }
    
    /// 기간이 존재하는 공지사항 관련 Header
    func configureCell(forModel model: DetailAnnouncePeriodHeaderModel) {
        headerType = model.base.type
        associationLogoImage.setImage(model.base.image, type: .associationLogo)
        associationName.text = model.base.name
        postDayLabel.text = model.base.days
        
        contentInfoView.configureData(model.base.favoriteCount,
                                      model.base.bookmarkCount,
                                      model.base.watchCount,
                                      model.base.isFavorite,
                                      model.base.isBookmark)
        
        startTimeLabel.text = model.startTime
        endTimeLabel.text = model.endTime
        
        setupHeader()
    }
    
    /// 선착순 이벤트 참여 관련 Header
    func configureCell(forModel model: DetailAnnounceFirstComeHeaderModel) {
        headerType = model.base.type
        associationLogoImage.setImage(model.base.image, type: .associationLogo)
        associationName.text = model.base.name
        postDayLabel.text = model.base.days
        
        contentInfoView.configureData(model.base.favoriteCount,
                                      model.base.bookmarkCount,
                                      model.base.watchCount,
                                      model.base.isFavorite,
                                      model.base.isBookmark)
        
        firstComeNumberLabel.text = "인원 " + model.firstComeNumber + "명"
        startTimeLabel.text = model.startTime
        endTimeLabel.text = model.endTime
        
        /// 사용자가 선착순 이벤트를 참여 했는지 여부 판단
        if model.isFirstComeApplied {
            firstComeButton.chanageButtonState(buttonState: .joined)
        } else {
            /// 참여를 하지 않았다면 기간을 기준으로 버튼 상태 변경
            firstComeButton.chanageButtonState(buttonState: model.firstComeButtonState)
        }
        
        setupHeader()
    }
}

// MARK: - Extensions

private extension DetailAnnouceHeaderCollectionViewCell {
    func setupStyle() {
        headerStackView.do {
            $0.axis = .vertical
            $0.spacing = 25
            $0.distribution = .fill
            $0.addArrangedSubviews(headerTitleStackView, periodSectionStackView, firstComeButton)
            $0.isUserInteractionEnabled = true
        }
        
        headerTitleStackView.do {
            $0.addArrangedSubviews(associationLogoImage, associationInfoStackView)
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fillProportionally
            $0.alignment = .center
        }
        
        associationLogoImage.do {
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 55 / 2
            $0.clipsToBounds = true
        }
        
        announceTimeStackView.do {
            $0.addArrangedSubviews(postDayLabel, flexibleSpaceView1, contentInfoView)
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
        }
        
        postDayLabel.do {
            $0.font = .interCaption11()
            $0.textColor = .black30
        }
        
        associationInfoStackView.do {
            $0.addArrangedSubviews(associationName, announceTimeStackView)
            $0.axis = .vertical
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        associationName.do {
            $0.font = .interSubtitle3()
            $0.textColor = .black50
        }
        
        periodSectionStackView.do {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.spacing = 10
            $0.addArrangedSubviews(periodTitleStackView, startStackView, endStackView)
        }
        
        firstComeNumberLabel.do {
            $0.textColor = .black20
            $0.font = .interChips12()
        }
        
        firstComeButton.do {
            $0.buttonAction = {
                self.firstComeButtonTapped()
            }
        }
        
        [startStackView, endStackView].forEach {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 5
        }
        
        periodTitleStackView.do {
            $0.axis = .horizontal
        }
        
        firstComeIndexLabel.do {
            $0.font = .interChips12()
            $0.textColor = .black50
            
            if case .firstCome = headerType {
                $0.text = "선착순 이벤트 기간"
            } else if case .period = headerType {
                $0.text = "공지사항 기간"
            }
        }
        
        [startIndexLabel, startTimeLabel, endIndexLabel, endTimeLabel].forEach {
            $0.font = .interCaption12()
            $0.textColor = .black50
            $0.numberOfLines = 1
        }
        
        startIndexLabel.text = "시작 :"
        endIndexLabel.text = "종료 :"
        
        [flexibleSpaceView1, flexibleSpaceView2, flexibleSpaceView3].forEach {
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal) // 높은 우선 순위
        }
    }
    
    @objc private func firstComeButtonTapped() {
        // 버튼 탭 처리
        // 이벤트 참여 완료 Alert 표기
        // Alert 에서 확인을 누르면 해당 버튼 상태 변경하기
        // Delegate 를 통해서 VC 로 전달
        print("First Come Button Tapped")
        delegate?.didFirstComeButtonTapped(buttonState: firstComeButton.buttonState)
    }
    
    func setupHierarchy() {
        self.addSubviews(headerStackView)
        
        periodTitleStackView.addArrangedSubviews(firstComeIndexLabel, flexibleSpaceView1, firstComeNumberLabel)
        startStackView.addArrangedSubviews(startIndexLabel, startTimeLabel, flexibleSpaceView2)
        endStackView.addArrangedSubviews(endIndexLabel, endTimeLabel, flexibleSpaceView3)
    }
    
    func setupLayout() {
        headerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 18, bottom: 15, right: 18))
        }

        associationLogoImage.snp.makeConstraints {
            $0.size.equalTo(55)
        }
        
        periodSectionStackView.snp.makeConstraints {
            $0.height.equalTo(70)
        }
        
        firstComeButton.snp.makeConstraints {
            $0.height.equalTo(30)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("DetailAnnouceHeaderCollectionViewCell") {
    DetailAnnouceHeaderCollectionViewCell()
        .showPreview()
}
#endif
