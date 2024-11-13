//
//  SectionBackgroundView.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import UIKit

/// `SectionBackgroundView`는 각 섹션의 배경을 나타내기 위해 사용되는 커스텀 `UICollectionReusableView`입니다.
/// 섹션의 스타일을 통일하고, 배경을 커스터마이징할 수 있도록 설정합니다.
///
/// - Properties:
///   - insetView: 섹션의 내부에 배경 스타일을 적용하기 위한 `UIView`
///
/// - Methods:
///   - setupHierarchy(): 뷰의 계층 구조를 설정하고 `insetView`를 추가합니다.
///   - setupStyle(): `insetView`의 스타일을 설정합니다.
///   - setupLayout(): `insetView`의 오토레이아웃을 설정합니다,
final class SectionBackgroundView: UICollectionReusableView {

    private let insetView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBackground() {
        backgroundColor = .white.withAlphaComponent(0.5)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
    }
    
    func setupHierarchy() {
        self.addSubviews(insetView)
    }
    
    func setupStyle() {
        insetView.do {
            $0.backgroundColor = .white.withAlphaComponent(0.5)
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 10
        }
    }
    
    func setupLayout() {
        insetView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
}
