//
//  UIViewController+.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import UIKit

extension UIViewController {
    /// 화면밖 터치시 키보드를 내려 주는 메서드
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func setupCustomNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .yellow
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 컨테이너 뷰 생성
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 49))
        customView.backgroundColor = .red
        
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black50
        config.image = UIImage(systemName: "chevron.backward")
        config.imagePlacement = .leading
        config.imagePadding = 10
        
        var titleAttr = AttributedString("학생회 공지 리스트")
        titleAttr.font = .interSubtitle1()
        titleAttr.foregroundColor = .black50
        config.attributedTitle = titleAttr
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(backNavTapped), for: .touchUpInside)
        
        // 버튼을 컨테이너 뷰에 추가
        customView.addSubview(button)
        
        // SnapKit으로 버튼 위치 조정
        button.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8) // 하단에서 8포인트 위로
            $0.height.equalTo(24)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customView)
    }
    
    @objc private func backNavTapped() {
        navigationController?.popViewController(animated: true)
    }
}
