//
//  PersonContentView.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/9/25.
//

import UIKit
import Combine

import SnapKit
import Then

final class PersonContentView: UIView {

    // MARK: - UI Properties
    
    private let textField = UITextField()
    private let titleLabel = UILabel()
    
    // MARK: - Combine Publishers Properties
    
    let textPublisher = CurrentValueSubject<String, Never>("")
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindingTitle(title: String) {
        textField.text = title
        textPublisher.send(title)
    }
}

// MARK: - Private Extensions

private extension PersonContentView {
    func setupStyle() {
        textField.do {
            $0.font = .interBody1()
            $0.textAlignment = .center
            $0.attributedPlaceholder = NSAttributedString(string: "0", attributes: [.font: UIFont.interBody1(), .foregroundColor: UIColor.black30])
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.layer.cornerRadius = 10
            $0.keyboardType = .numberPad
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        titleLabel.do {
            $0.text = "명"
            $0.textColor = .black40
            $0.font = .interBody1()
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(textField, titleLabel)
    }
    
    func setupLayout() {
        textField.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(textField)
            $0.leading.equalTo(textField.snp.trailing).offset(10)
        }
    }
    
    func setupDelegate() {
        textField.delegate = self
    }
    
    @objc private func textFieldDidChange() {
        textPublisher.send(textField.text ?? "")
    }
}

// MARK: - UITextFieldDelegate (숫자 입력만 허용)

extension PersonContentView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        // 숫자가 아닌 입력 방지
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }

        // 입력 후의 전체 텍스트 예측
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        // 숫자로 변환 후 999 초과 여부 확인
        if let number = Int(newText), number > 999 {
            return false
        }

        return true
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("PersonContentView") {
    PersonContentView()
        .showPreview()
}
#endif
