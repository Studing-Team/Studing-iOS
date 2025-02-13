//
//  SingleButtonSheetViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/12/25.
//

import UIKit

import SnapKit
import Then

class SingleButtonSheetViewController: BaseSheetViewController {
    
    // MARK: - Properties
    
    private var bottomButtonAction: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let bottomButton: CustomButton
    
    // MARK: - Init
    
    init(buttonStyle: ButtonStyle, action: (() -> Void)? = nil) {
        self.bottomButton = CustomButton(buttonStyle: buttonStyle)
        self.bottomButtonAction = action
        super.init(nibName: nil, bundle: nil)
        
        print("SingleButtonSheetViewController init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("SingleButtonSheetViewController deinit")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    func bindingBottomButtonAction(action: (() -> Void)?) {
        bottomButtonAction = action
    }
}

// MARK: - Private Extensions

private extension SingleButtonSheetViewController {
    func setupStyle() {
        bottomButton.do {
            $0.buttonAction = { [weak self] in
                self?.bottomButtonAction?()
            }
        }
    }
    
    func setupHierarchy() {
        self.containerView.addSubview(bottomButton)
    }
    
    func setupLayout() {
        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalTo(containerView.snp.bottom).inset(18)
            $0.height.equalTo(49)
        }
    }
    
    func setupDelegate() {
        
    }
}
