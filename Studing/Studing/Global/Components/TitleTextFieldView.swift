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
    private var stateMessageLabel = UILabel()
    private var rightButton = UIButton()
    
    var textField = UITextField()
    
    // MARK: - Combine Publishers Properties
    
    let textPublisher = PassthroughSubject<String, Never>()
    let statePublisher: CurrentValueSubject<TextFieldState, Never>
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(textFieldType: TextFieldInputType) {
        self.textFieldType = textFieldType
        self.textFieldState = .normal(type: textFieldType)
        self.statePublisher = CurrentValueSubject<TextFieldState, Never>(.normal(type: textFieldType))
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
                rightButton.setImage(UIImage(resource: .focuseNotVisibility), for: .normal)
            case false:
                rightButton.setImage(UIImage(resource: .focuseVisibility), for: .normal)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textFieldType == .userPw) || (textFieldType == .confirmPw) {
            switch textField.isSecureTextEntry {
            case true:
                rightButton.setImage(UIImage(resource: .notFocuseNotVisibility), for: .normal)
            case false:
                rightButton.setImage(UIImage(resource: .notFocuseVisibility), for: .normal)
            }
        }
    }
}

// MARK: - Objc Extension

private extension TitleTextFieldView {
    @objc private func textFieldDidChange() {
        textPublisher.send(textField.text ?? "")
    }
    
    @objc private func togglePasswordVisibility() {
        textField.isSecureTextEntry.toggle()
        rightButton.setImage(UIImage(resource: textField.isSecureTextEntry ? .focuseNotVisibility : .focuseVisibility), for: .normal)
    }
    
    @objc private func clearTextField() {
        textField.text = ""
        textPublisher.send("")
        textField.becomeFirstResponder()
        rightButton.setImage(UIImage(systemName: "magnifyingglass")?.withTintColor(.black30, renderingMode: .alwaysOriginal), for: .normal)
        rightButton.removeTarget(self, action: #selector(clearTextField), for: .touchUpInside)
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
            $0.textColor = .black30
        }
        
        rightButton.do {
            switch textFieldType {
            case .university, .major:
                $0.setImage(UIImage(systemName: "magnifyingglass")?.withTintColor(.black30, renderingMode: .alwaysOriginal), for: .normal)
            case .studentId:
                $0.setImage(UIImage(systemName: "chevron.down")?.withTintColor(.black30, renderingMode: .alwaysOriginal), for: .normal)
            default:
                $0.setImage(UIImage(resource: .notFocuseNotVisibility), for: .normal)
            }
            $0.frame = CGRect(x: 0, y: 0, width: 24, height: 22.51)
        }
    }
    
    func setupHierarchy() {
        switch textFieldType {
        case .studentId:
            addSubviews(titleLabel, textField)
        default:
            addSubviews(titleLabel, textField, stateMessageLabel)
        }
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        switch textFieldType {
        case .studentId, .userName, .allStudentId:
            textField.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(10)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(textFieldHeight)
            }
            
        default:
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
    }
    
    func setupBindings() {
        statePublisher
            .sink { [weak self] state in
                self?.updateUI(state: state)
            }
            .store(in: &cancellables)
        
        textPublisher
            .sink { [weak self] text in
                self?.updateRightButtonForTextChange(text: text)
            }
            .store(in: &cancellables)
    }
    
    func updateUI(state: TextFieldState) {
        updateBorderColor(state)
        updateStudentIdRightButton(state)
        
        switch textFieldType {
        case .university, .major:
            stateMessageLabel.textColor = .black30
        default:
            stateMessageLabel.textColor = state.color
        }
        
        stateMessageLabel.text = state.message
    }
    
    func updateBorderColor(_ state: TextFieldState) {
        textField.layer.borderColor = state.borderColor
        textField.layer.borderWidth = 1
    }
    
    func updateTextColor(_ state: TextFieldState) {
        switch textFieldType {
        case .university, .major:
            stateMessageLabel.textColor = .black30
        default:
            stateMessageLabel.textColor = state.color
        }
    }
    
    func createRightButton(textFieldType: TextFieldInputType) {
        switch textFieldType {
        case .userPw, .confirmPw:
            createVisibilityButton()
        case .university, .major:
            createClearOrSearchButton() // 새로운 함수 호출
        case .studentId:
            createDownButton()
        default:
            textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        }
        
        textField.rightViewMode = .always
    }
    
    // 비밀번호 가시성 토글 버튼 생성
    func createVisibilityButton() {
        
        // 버튼을 감싸는 패딩 뷰 생성
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24 + 15, height: 22.51))
        paddingView.addSubview(rightButton)
        
        // 버튼을 paddingView의 왼쪽에 붙이기
        rightButton.frame.origin = CGPoint(x: 0, y: 0)
        rightButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        textField.rightView = paddingView
        textField.isSecureTextEntry = true
    }
    
    // 돋보기 또는 X 버튼 생성
    func createClearOrSearchButton() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24 + 15, height: 24))
        paddingView.addSubview(rightButton)
        
        rightButton.frame.origin = CGPoint(x: 0, y: 0)
        rightButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        
        textField.rightView = paddingView
    }
    
    // 아래방향 버튼 생성
    func createDownButton() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24 + 15, height: 22.51))
        paddingView.addSubview(rightButton)
        
        rightButton.frame.origin = CGPoint(x: 0, y: 0)
        
        textField.rightView = paddingView
    }
    
    // 텍스트가 변경되면 버튼의 이미지를 업데이트
    func updateRightButtonForTextChange(text: String) {
        guard textFieldType == .university || textFieldType == .major else { return }
        
        if text.isEmpty {
            // 텍스트 필드가 비어있을 때는 돋보기 아이콘
            rightButton.setImage(UIImage(systemName: "magnifyingglass")?.withTintColor(.black30, renderingMode: .alwaysOriginal), for: .normal)
            rightButton.removeTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        } else {
            // 텍스트 필드에 값이 있을 때는 X 아이콘
            rightButton.setImage(UIImage(systemName: "xmark.circle.fill")?.withTintColor(.black30, renderingMode: .alwaysOriginal), for: .normal)
            rightButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        }
    }
}

// MARK: - Extension

extension TitleTextFieldView {
    /// studentIDTextField 에서 rightButton 을 바꾸는 함수
    func updateStudentIdRightButton(_ state: TextFieldState) {
        guard textFieldType == .studentId else { return }
            
        switch state {
        case .normal:
            rightButton.setImage(UIImage(systemName: "chevron.down")?.withTintColor(.black30, renderingMode: .alwaysOriginal), for: .normal)
        case .select:
            rightButton.setImage(UIImage(systemName: "chevron.up")?.withTintColor(.primary50, renderingMode: .alwaysOriginal), for: .normal)
        default:
            break
        }
    }
    
    func getInputText() -> String? {
        return textField.text
    }
    
    func setState(_ state: TextFieldState) {
        statePublisher.send(state)
    }
}
