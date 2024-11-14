//
//  MyInfoCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import UIKit

import SnapKit
import Then

/// `MyInfoCollectionViewCell`은 MyPgaeViewController 의 MyInfo 섹션에서 사용자의 프로필 정보를 표시하기 위해 사용되는 `UICollectionViewCell`입니다.
/// 사용자 이름, 프로필 이미지, 대학교, 학과, 학번 정보를 표시합니다.
///
/// - Properties:
///   - myProfileImage: 사용자의 프로필 이미지를 표시하는 `UIImageView`
///   - myNameLabel: 사용자의 이름을 표시하는 `UILabel`
///   - myUniversityLabel: 사용자의 대학교 정보를 표시하는 `UILabel`
///   - myMajorLabel: 사용자의 학과 정보를 표시하는 `UILabel`
///   - myStudentIdLabel: 사용자의 학번을 표시하는 `UILabel`
///   - myInfoStackView: 사용자 정보를 수평으로 배치하는 `UIStackView`
///
/// - Methods:
///   - configureCell(forModel:): 전달된 `MypageModel`로 셀의 데이터를 설정합니다.
///   - setupStyle(): 각 UI 컴포넌트의 스타일을 설정합니다.
///   - setupHierarchy(): 셀에 서브뷰들을 추가합니다.
///   - setupLayout(): 오토레이아웃을 설정하여 UI의 배치를 결정합니다.
final class MyInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let myProfileImage = UIImageView()
    private let myNameLabel = UILabel()
    
    private let myInfoStackView = UIStackView()
    private let myUniversityLabel = UILabel()
    private let myMajorLabel = UILabel()
    private let myStudentIdLabel = UILabel()

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

extension MyInfoCollectionViewCell {
    /// `MypageModel`을 받아서 셀의 UI 컴포넌트를 설정합니다.
    /// - Parameter model: 사용자 정보를 담고 있는 `MypageModel`
    func configureCell(forModel model: MypageInfoEntity) {
        myNameLabel.text = "\(model.userName)님"
        myUniversityLabel.text = model.university
        myMajorLabel.text = model.major
        myStudentIdLabel.text = model.studentId
    }
}

// MARK: - Private Extensions

private extension MyInfoCollectionViewCell {
    func setupStyle() {
        
        self.backgroundColor = .white.withAlphaComponent(0.5)
        self.layer.borderWidth = 1
        self.layer.borderColor =  UIColor.white.cgColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        myProfileImage.do {
            $0.image = UIImage(resource: .emptyProfile)
            $0.contentMode = .scaleAspectFit
        }
        
        myNameLabel.do {
            $0.font = .interSubtitle1()
            $0.textColor = .black50
        }
        
        [myUniversityLabel, myMajorLabel, myStudentIdLabel].forEach {
            $0.font = .interCaption12()
            $0.textColor = .black50
        }
        
        myInfoStackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .equalSpacing
            $0.addArrangedSubviews(myUniversityLabel, myMajorLabel, myStudentIdLabel)
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(myProfileImage, myNameLabel, myInfoStackView)
    }
    
    func setupLayout() {
        myProfileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.centerX.equalToSuperview()
        }
        
        myNameLabel.snp.makeConstraints {
            $0.top.equalTo(myProfileImage.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        myInfoStackView.snp.makeConstraints {
            $0.top.equalTo(myNameLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(25)
        }
    }
}
