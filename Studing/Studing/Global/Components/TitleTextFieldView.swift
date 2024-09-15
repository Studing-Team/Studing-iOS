//
//  TitleTextFieldView.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import UIKit

import SnapKit
import Then

final class TitleTextFieldView: UIView {

    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    
    // MARK: - Life Cycle
    
    init(title: String, placeholder: String) {
        super.init(frame: .zero)
        
        setupStyle(title: title, placeholder: placeholder)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension

private extension TitleTextFieldView {
    func setupStyle(title: String, placeholder: String) {
        titleLabel.do {
            $0.text = title
        }
        
        textField.do {
            $0.placeholder = placeholder
        }
    }
    
    func setupHierarchy() {
        addSubviews(titleLabel, textField)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(textField.snp.top).offset(6)
        }
        
        textField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Extension

private extension TitleTextFieldView {
    func getInputText() -> String? {
        return textField.text
    }
}
