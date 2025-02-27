//
//  BaseSheetViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/12/25.
//

import UIKit

import SnapKit
import Then

class BaseSheetViewController: UIViewController {
    
    // MARK: - Properties
    
    private var contentConfiguration: SheetContentConfigurable?
    private var buttonConfiguration: SheetButtonsConfigurable?
    
    // MARK: - UI Properties
    
    let containerView = UIView()
    private let topBarView = UIView()
    let contentAreaView = UIView()
    
    // MARK: - Init
    
    init(content: SheetContentConfigurable? = nil,
         buttons: SheetButtonsConfigurable? = nil) {
        self.contentConfiguration = content
        self.buttonConfiguration = buttons
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupContent()
        setupButtons()
    }
}

// MARK: - Private Extensions

private extension BaseSheetViewController {
    func setupStyle() {
        view.backgroundColor = .clear
        
        containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }
        
        topBarView.do {
            $0.backgroundColor = .black20
            $0.layer.cornerRadius = 2
        }
    }
    
    func setupHierarchy() {
        view.addSubview(containerView)
        containerView.addSubviews(topBarView, contentAreaView)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        topBarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(33)
            $0.height.equalTo(4)
        }
        
        setupContentLayout()
    }
    
    func setupContentLayout() {
        if let buttonHeight = buttonConfiguration?.buttonHeight {
            contentAreaView.snp.makeConstraints {
                $0.top.equalTo(topBarView.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview().inset(buttonHeight)
            }
        } else {
            contentAreaView.snp.makeConstraints {
                $0.top.equalTo(topBarView.snp.bottom).offset(20)
                $0.horizontalEdges.bottom.equalToSuperview()
            }
        }
    }
    
    func setupContent() {
        guard let content = contentConfiguration else { return }
        contentAreaView.addSubview(content.contentView)
        
        content.contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        content.setupContent()
    }
    
    
    func setupButtons() {
        guard let buttonView = buttonConfiguration?.buttonContainerView else { return }
        containerView.addSubview(buttonView)
        buttonConfiguration?.setupButtons()
        
        buttonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(buttonConfiguration?.buttonHeight ?? 0)
        }
    }
}

// MARK: - Public Methods

extension BaseSheetViewController {
    func updateContent(_ content: SheetContentConfigurable) {
        self.contentConfiguration = content
        setupContent()
    }
    
    func updateButtons(_ buttons: SheetButtonsConfigurable) {
        self.buttonConfiguration = buttons
        setupButtons()
        setupContentLayout()
    }
}
