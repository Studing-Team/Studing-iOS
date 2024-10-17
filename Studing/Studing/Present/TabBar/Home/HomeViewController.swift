//
//  HomeViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setNavigationBar()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
}

// MARK: - Private Extensions

private extension HomeViewController {
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
