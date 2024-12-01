//
//  ToasterMessageView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/27/24.
//

import UIKit

import SnapKit
import Then

final class ToastMessageView: UIView {
    
    // MARK: - Properties
    
    private var isBookmark: Bool
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    private let toastMessageLabel = UILabel()
    
    // MARK: - Life Cycle
    
    init(isBookmark: Bool) {
        self.isBookmark = isBookmark
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension ToastMessageView {
    func setupStyle() {
        backgroundView.do {
            $0.backgroundColor = .black50.withFigmaStyleAlpha(0.65)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black50.cgColor
            $0.layer.cornerRadius = 10
        }
        
        toastMessageLabel.do {
            $0.text = isBookmark == true ? "저장한 공지사항에 추가했어요 ⭐" : "저장한 공지사항을 취소했어요 ⭐"
            $0.font = .interCaption12()
            $0.textColor = .white
        }
    }
    
    func setupHierarchy() {
        addSubviews(backgroundView)
        backgroundView.addSubview(toastMessageLabel)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.width.equalTo(206)
            $0.height.equalTo(27)
            $0.center.equalToSuperview()
        }
        
        toastMessageLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func setupDelegate() {

    }
}
