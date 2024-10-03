//
//  StepCountView.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/24/24.
//

import UIKit

import SnapKit
import Then

final class StepCountView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    private let stepCountView = UILabel()
    
    // MARK: - Life Cycle
    
    init(count: Int) {
        super.init(frame: .zero)
        
        setupStyle(count)
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension StepCountView {
    func setupStyle(_ count: Int) {
        backgroundView.do {
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.layer.cornerRadius = 14
        }
        
        stepCountView.do {
            $0.text = "Step.\(count)"
            $0.font = .interSubtitle2()
            $0.textColor = .black40
        }
    }
    
    func setupHierarchy() {
        addSubviews(backgroundView)
        backgroundView.addSubview(stepCountView)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stepCountView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(14)
        }
    }
    
    func setupDelegate() {

    }
}
