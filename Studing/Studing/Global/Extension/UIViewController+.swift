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

/// 키보드 표시에 따른 화면 조정을 처리하는 UIViewController 확장
extension UIViewController {
   /// 키보드 이벤트 처리를 위한 설정을 수행하는 메서드
   /// - Parameter spacing: 키보드와 텍스트필드 사이의 여백 (기본값: 40pt)
   func setupKeyboardHandling(with spacing: CGFloat = 40) {
       // 키보드가 나타날 때의 알림 observer 등록
       NotificationCenter.default.addObserver(
           self,                                        // 현재 ViewController를 observer로 등록
           selector: #selector(handleKeyboardWillShow), // 키보드 표시 시 호출될 메서드
           name: UIResponder.keyboardWillShowNotification, // 키보드 표시 알림
           object: nil                                  // 특정 객체의 알림만 받지 않고 모든 알림 수신
       )
       
       // 키보드가 사라질 때의 알림 observer 등록
       NotificationCenter.default.addObserver(
           self,
           selector: #selector(handleKeyboardWillHide),
           name: UIResponder.keyboardWillHideNotification,
           object: nil
       )
       
       // 화면 터치 시 키보드를 숨기기 위한 제스처 추가
       let tapGesture = UITapGestureRecognizer(
           target: self,
           action: #selector(dismissKeyboard)
       )
       view.addGestureRecognizer(tapGesture)
   }
   
   /// 키보드가 나타날 때 호출되는 메서드
   /// - Parameter notification: 키보드 관련 정보를 포함한 알림 객체
   @objc private func handleKeyboardWillShow(_ notification: NSNotification) {
       // notification에서 키보드 크기와 애니메이션 시간 추출
       guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
             let duration: Double = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
           return
       }
       
       // 키보드의 실제 높이 계산
       let keyboardHeight = keyboardFrame.cgRectValue.height
       print("⌨️ Keyboard height: \(keyboardHeight)")
       
       // 현재 포커스된 텍스트필드 찾기
       if let activeField = view.firstResponder as? UITextField {
           // 텍스트필드의 좌표를 현재 view의 좌표계로 변환
           let fieldFrame = activeField.convert(activeField.bounds, to: view)
           print("📱 Field frame: \(fieldFrame)")
           
           // 텍스트필드 하단부터 화면 하단까지의 거리 계산
           let distanceToBottom = view.frame.height - (fieldFrame.origin.y + fieldFrame.height)
           print("↕️ Distance to bottom: \(distanceToBottom)")
           
           // 키보드에 의해 가려지는 공간 계산 (여유 공간 40pt 추가)
           let collapseSpace = keyboardHeight - distanceToBottom + 80
           print("📏 Collapse space: \(collapseSpace)")
           
           // 텍스트필드가 키보드에 가려질 경우에만 화면을 위로 이동
           if collapseSpace > 0 {
               // 설정된 시간동안 부드럽게 화면 이동 애니메이션 실행
               UIView.animate(withDuration: duration) {
                   self.view.frame.origin.y = -collapseSpace  // 화면을 위로 이동
                   print("⬆️ Moving view up by: \(collapseSpace)")
               }
           }
       }
   }
   
   /// 키보드가 사라질 때 호출되는 메서드
   /// - Parameter notification: 키보드 관련 정보를 포함한 알림 객체
   @objc private func handleKeyboardWillHide(_ notification: NSNotification) {
       // notification에서 애니메이션 시간 추출
       guard let duration: Double = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
           return
       }
       
       print("⬇️ Moving view back to original position")
       // 설정된 시간동안 부드럽게 화면을 원래 위치로 되돌리는 애니메이션 실행
       UIView.animate(withDuration: duration) {
           self.view.frame.origin.y = 0  // 화면을 원래 위치로 복원
       }
   }
    
    func showConfirmAlert(mainTitle: String, subTitle: String, confirmTitle: String, centerButtonHandler: (() -> Void)? = nil) {
        
        let customAlertViewController = CustomAlertViewController(
            alertType: .onlyConfirm, mainTitle: mainTitle,
            subTitle: subTitle, confirmTitle: confirmTitle,
            centerButtonHandler: centerButtonHandler)
        
        customAlertViewController.modalPresentationStyle = .overFullScreen
        present(customAlertViewController, animated: false)
    }
    
    func showConfirmCancelAlert(mainTitle: String, subTitle: String, rightButtonTitle: String, leftButtonTitle: String, leftButtonHandler: (() -> Void)? = nil, rightButtonHandler: (() -> Void)? = nil) {
        
        let customAlertViewController = CustomAlertViewController(
            alertType: .confirmCancel, mainTitle: mainTitle,
            subTitle: subTitle, rightButtonTitle: rightButtonTitle, leftButtonTitle: leftButtonTitle, leftButtonHandler: leftButtonHandler , rightButtonHandler: rightButtonHandler)
        
        customAlertViewController.modalPresentationStyle = .overFullScreen
        present(customAlertViewController, animated: false)
    }
    
    func showBookmarkToastMessage(isBookmark: Bool) {
        let toastView = ToastMessageView(isBookmark: isBookmark)
        view.addSubview(toastView)
        
        // 위치 설정
        toastView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(view.convertByHeightRatio(97))
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

