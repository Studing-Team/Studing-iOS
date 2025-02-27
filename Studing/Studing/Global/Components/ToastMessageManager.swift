//
//  ToastMessageManager.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/19/25.
//

import Foundation
import UIKit

final class ToastMessageManager {
    static func showToastMessage(toastType: ToastType) {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let toastView = ToastMessageView(type: toastType)
        window.addSubview(toastView)
        
        // 위치 설정
        toastView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(window.safeAreaLayoutGuide).inset(110)
        }
        
        // 애니메이션
        toastView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            toastView.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 0.3, animations: {
                toastView.alpha = 0
            }, completion: { _ in
                toastView.removeFromSuperview()
            })
        }
    }
}
