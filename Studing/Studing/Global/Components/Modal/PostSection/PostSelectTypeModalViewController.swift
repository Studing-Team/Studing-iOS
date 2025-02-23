//
//  PostSelectTypeModalViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/12/25.
//

import UIKit

import SnapKit
import Then

final class PostSelectTypeModalViewController: BaseSheetViewController {
    
    // MARK: - Properties
    
    weak var coordinator: HomeCoordinator?
    private var contentConfiguration: PostSelectTypeContentView
    
    // MARK: - Init
    
    init(
        coordinator: HomeCoordinator,
        firstSectionTap: (() -> Void)?,
        announceSectionTap: (() -> Void)?
    ) {
        self.coordinator = coordinator
        
        let content = PostSelectTypeContentView()
        self.contentConfiguration = content
        
        let buttonConfig = SingleButtonConfiguration(
            buttonStyle: .close(type: .blue)
        )
        
        super.init(content: content, buttons: buttonConfig)
        
        buttonConfig.setAction { [weak self] in
            self?.dismiss(animated: true)
        }
        
        // dismiss를 포함한 액션 클로저 생성
        let firstSectionWithDismiss: (() -> Void)? = { [weak self] in
            self?.dismiss(animated: true)
            firstSectionTap?()
        }
        
        let announceSectionWithDismiss: (() -> Void)? = { [weak self] in
            self?.dismiss(animated: true)
            announceSectionTap?()
        }
        
        // 새로운 클로저를 바인딩
        contentConfiguration.bindingFirstSectionTap(action: firstSectionWithDismiss)
        contentConfiguration.bindingAnnounceSectionTap(action: announceSectionWithDismiss)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("PostSelectTypeModalViewController deinit")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Push PostSelectTypeModalViewController")
    }
}
