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
    
    private let nextButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Push TermsOfServiceViewController")
        
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
        print("Pop TermsOfServiceViewController")
    }
}

// MARK: - Private Extensions

private extension TermsOfServiceViewController {
    func setNavigationBar() {
        self.navigationItem.title = StringLiterals.NavigationTitle.signUp
        self.navigationItem.largeTitleDisplayMode = .inline
    }
    
    func setupStyle() {
        
    }
    
    func setupHierarchy() {
        
    }
    
    func setupLayout() {
        
    }
    
    func setupDelegate() {
        
    }
}
