//
//  TitleTextFieldView.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import UIKit
import Combine

import SnapKit
import Then

enum TextFieldInputType {
    case userId
    case userPw
    case confirmPw
    case userName
    case studentId
    case university
    
    var title: String {
        switch self {
        case .userId:
            return "아이디"
        case .userPw:
            return "비밀번호"
        case .confirmPw:
            return "비밀번호 확인"
        case .userName:
            return "이름"
        case .studentId:
            return "전체 학번"
        case .university:
            return "대학교"
        }
    }
    
    var placeholder: String {
        switch self {
        case .userId:
            return "아이디를 입력해주세요."
        case .userPw:
            return "비밀번호를 입력해주세요."
        case .confirmPw:
            return "비밀번호를 다시 한 번 입력해주세요."
        case .userName:
            return "이름을 입력해주세요."
        case .studentId:
            return "전체 학번을 입력해주세요 (예시 -20241234)"
        case .university:
            return "대학교를 검색해주세요."
        }
    }
}

final class TitleTextFieldView: UIView {

    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    
    let textPublisher = PassthroughSubject<String, Never>()
    
    // MARK: - Life Cycle
    
    init(textFieldType: TextFieldInputType) {
        super.init(frame: .zero)
        
        setupStyle(textFieldType: textFieldType)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension

private extension TitleTextFieldView {
    func setupStyle(textFieldType: TextFieldInputType) {
        titleLabel.do {
            $0.text = textFieldType.title
        }
        
        textField.do {
            $0.placeholder = textFieldType.placeholder
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    func setupHierarchy() {
        addSubviews(titleLabel, textField)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc private func textFieldDidChange() {
        textPublisher.send(textField.text ?? "")
    }
}

// MARK: - Extension

extension TitleTextFieldView {
    func getInputText() -> String? {
        return textField.text
    }
}
