//
//  MypageViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class MypageViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        setNavigationBar()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
}

// MARK: - Private Extensions

private extension MypageViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
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
