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

final class TitleTextFieldView: UIView {

    // MARK: - UI Properties
    
    private var textFieldState: TextFieldState
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private var stateMessageLabel = UILabel()
    
    // MARK: - Combine Publishers Properties
    
    let textPublisher = PassthroughSubject<String, Never>()
    let statePublisher = CurrentValueSubject<TextFieldState, Never>(.normal)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(textFieldType: TextFieldInputType, textFieldState: TextFieldState = .normal) {
        self.textFieldState = textFieldState
        super.init(frame: .zero)
        
        setupStyle(textFieldType: textFieldType)
        setupHierarchy()
        setupLayout()
        setupBindings()
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
            $0.font = .interSubtitle2()
            $0.textColor = .black30
        }
        
        textField.do {
            $0.placeholder = textFieldType.placeholder
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        stateMessageLabel.do {
            $0.font = .interCaption12()
        }
    }
    
    func setupHierarchy() {
        addSubviews(titleLabel, textField, stateMessageLabel)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview()
        }
        
        stateMessageLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupBindings() {
        statePublisher
            .sink { [weak self] state in
                self?.updateUI(state: state)
            }
            .store(in: &cancellables)
    }
    
    @objc private func textFieldDidChange() {
        textPublisher.send(textField.text ?? "")
    }
    
    func updateUI(state: TextFieldState) {
        textField.layer.borderColor = state.color.cgColor
        textField.layer.borderWidth = 1
        stateMessageLabel.textColor = state.color
        stateMessageLabel.text = state.message
    }
}

// MARK: - Extension

extension TitleTextFieldView {
    func getInputText() -> String? {
        return textField.text
    }
    
    func setState(_ state: TextFieldState) {
        statePublisher.send(state)
    }
}
