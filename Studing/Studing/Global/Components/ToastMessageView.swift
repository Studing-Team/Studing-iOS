//
//  ToasterMessageView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/27/24.
//

import UIKit

import SnapKit
import Then

enum ToastType: Equatable {
    case createCompletion
    case bookmark(isBookmark: Bool)
    case deleteAnnounce
    case editCompletion
    
    var title: String {
        switch self {
        case .createCompletion:
            return "✏️ 공지사항 작성완료"
        case .bookmark(let isBookmark):
            return isBookmark ? "저장한 공지사항에 추가했어요 ⭐" : "저장한 공지사항을 취소했어요 ⭐"
        case .deleteAnnounce:
            return "공지사항 삭제 완료 ❎"
        case .editCompletion:
            return "✏️ 공지사항 수정완료"
        }
    }
}

final class ToastMessageView: UIView {
    
    // MARK: - Properties
    
    private var messageType: ToastType
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    private let toastMessageLabel = UILabel()
    
    // MARK: - Life Cycle
    
    init(type: ToastType) {
        self.messageType = type
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
            $0.text = messageType.title
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
