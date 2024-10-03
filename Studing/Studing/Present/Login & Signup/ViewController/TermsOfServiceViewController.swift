//
//  TermsOfServiceViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import UIKit

import SnapKit
import Then

final class TermsOfServiceViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let stepCountView = StepCountView(count: 5)
    private let serviceTitleLabel = UILabel()
    private let nextButton = CustomButton(buttonStyle: .next)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Push TermsOfServiceViewController")
        view.backgroundColor = .signupBackground
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("Pop TermsOfServiceViewController")
    }
}

// MARK: - Private Extensions

private extension TermsOfServiceViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupStyle() {
        serviceTitleLabel.do {
            $0.text = StringLiterals.Title.authTermsofService
            $0.font = .interHeadline2()
            $0.textColor = .black50
            $0.numberOfLines = 2
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(stepCountView, serviceTitleLabel,  nextButton)
    }
    
    func setupLayout() {
        stepCountView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(19)
        }
        
        serviceTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stepCountView.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.horizontalEdges.equalToSuperview().inset(19)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            $0.height.equalTo(48)
        }
    }
    
    func setupDelegate() {
        
    }
}
