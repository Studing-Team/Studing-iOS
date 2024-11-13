//
//  MyPageAnotherCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import UIKit

import SnapKit
import Then

/// `MyPageAnotherCollectionViewCell`은 MyPgaeViewController 의 이용 정보, 기타 섹션에서 사용되는 `UICollectionViewCell`입니다.
/// 제목과 오른쪽에 버튼 또는 레이블을 동적으로 표시하며, 항목에 따른 구분선도 보여줍니다.
///
/// - Properties:
///   - titleLabel: 셀의 제목을 표시하는 `UILabel`
///   - rightLabel: 앱 버전과 같은 오른쪽 텍스트를 표시하는 `UILabel`
///   - rightButton: 오른쪽에 표시될 화살표 버튼을 나타내는 `UIButton`
///   - separatorView: 항목을 구분하는 구분선을 나타내는 `UIView`
///
/// - Methods:
///   - configureCell(title:): 제목에 따라 버튼 또는 레이블을 숨기거나 표시합니다.
///   - hideSeparator(): 구분선을 숨깁니다.
///   - showSeparator(): 구분선을 표시합니다.
final class MyPageAnotherCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let rightLabel = UILabel()
    private let rightButton = UIButton()
    private let separatorView = UIView()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension MyPageAnotherCollectionViewCell {
    func configureCell(title: String) {
        
        if title == "앱 버전" {
            rightButton.isHidden = true
            rightLabel.isHidden = false
        } else {
            rightButton.isHidden = false
            rightLabel.isHidden = true
        }
    
        titleLabel.text = title
    }
    
    func hideSeparator() {
        separatorView.isHidden = true
    }
    
    func showSeparator() {
        separatorView.isHidden = false
    }
}

// MARK: - Private Extensions

private extension MyPageAnotherCollectionViewCell {
    func setupStyle() {
        titleLabel.do {
            $0.font = .interBody2()
            $0.textColor = .black50
        }
        
        rightButton.do {
            $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            $0.tintColor = .black30
        }
        
        rightLabel.do {
            $0.text = "V.1.0.0"
            $0.font = .interBody3()
            $0.textColor = .black30
        }
        
        separatorView.do {
            $0.backgroundColor = .black10
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(titleLabel, rightButton, rightLabel, separatorView)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
        }
        
        rightLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
