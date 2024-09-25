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

final class TitleTextFieldView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var textFieldHeight: CGFloat {
        switch textFieldType {
        case .university, .studentId:
            return textField.frame.height + 40
        default:
            return textField.frame.height + 38
        }
    }

    // MARK: - UI Properties
    
    private var textFieldState: TextFieldState
    private let textFieldType: TextFieldInputType
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private var stateMessageLabel = UILabel()
    private var visibilityButton = UIButton()
    
    // MARK: - Combine Publishers Properties
    
    let textPublisher = PassthroughSubject<String, Never>()
    let statePublisher = CurrentValueSubject<TextFieldState, Never>(.normal)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(textFieldType: TextFieldInputType, textFieldState: TextFieldState = .normal) {
        self.textFieldType = textFieldType
        self.textFieldState = textFieldState
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupBindings()
        createRightButton(textFieldType: textFieldType)
        
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITextFieldDelegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textFieldType == .userPw) || (textFieldType == .confirmPw) {
            switch textField.isSecureTextEntry {
            case true:
                visibilityButton.setImage(UIImage(resource: .focuseNotVisibility), for: .normal)
            case false:
                visibilityButton.setImage(UIImage(resource: .focuseVisibility), for: .normal)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textFieldType == .userPw) || (textFieldType == .confirmPw) {
            switch textField.isSecureTextEntry {
            case true:
                visibilityButton.setImage(UIImage(resource: .notFocuseNotVisibility), for: .normal)
            case false:
                visibilityButton.setImage(UIImage(resource: .notFocuseVisibility), for: .normal)
            }
        }
    }
}

// MARK: - Private Extension

private extension TitleTextFieldView {
    func setupStyle() {
        titleLabel.do {
            $0.text = textFieldType.title
            $0.font = .interSubtitle2()
            $0.textColor = .black30
        }
        
        textField.do {
            $0.font = .interSubtitle2()
            $0.attributedPlaceholder = NSAttributedString(string: textFieldType.placeholder, attributes: [.font: UIFont.interBody1(), .foregroundColor: UIColor.black20])
            $0.backgroundColor = .white
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.leftViewMode = .always
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.layer.cornerRadius = 10
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        stateMessageLabel.do {
            $0.font = .interCaption12()
        }
        
        visibilityButton.do {
            $0.setImage(UIImage(resource: .notFocuseNotVisibility), for: .normal)
            $0.frame = CGRect(x: 0, y: 0, width: 24, height: 22.51)
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(textFieldHeight)
        }
        
        stateMessageLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(20)
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
    
    func createRightButton(textFieldType: TextFieldInputType) {
        switch textFieldType {
        case .userPw, .confirmPw:
            
            // 버튼을 감싸는 패딩 뷰 생성
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24 + 15, height: 22.51))
            paddingView.addSubview(visibilityButton)
            
            // 버튼을 paddingView의 왼쪽에 붙이기
            visibilityButton.frame.origin = CGPoint(x: 0, y: 0)
            visibilityButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
            
            textField.rightView = paddingView
            
            textField.isSecureTextEntry = true
        case .university, .major:
            
            // 버튼을 감싸는 패딩 뷰 생성
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24 + 15, height: 24))
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 22.51))
            imageView.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.black30, renderingMode: .alwaysOriginal)
            
            paddingView.addSubview(imageView)
            textField.rightView = paddingView
            
        default:
            textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        }
        
        textField.rightViewMode = .always
    }
    
    @objc private func togglePasswordVisibility() {
        textField.isSecureTextEntry.toggle()
        visibilityButton.setImage(UIImage(resource: textField.isSecureTextEntry ? .focuseNotVisibility : .focuseVisibility), for: .normal)
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
