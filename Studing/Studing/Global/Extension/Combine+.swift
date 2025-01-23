//
//  Combine+.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import UIKit
import Combine

// MARK: - Combine Extensions

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        Publishers.Merge(
            // editingChanged 이벤트를 String으로 변환
            controlPublisher(for: .editingChanged)
                .compactMap { $0 as? UITextField }
                .map { $0.text ?? "" },
            
            // Notification 이벤트를 String으로 변환
            NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
                .compactMap { _ in self.text ?? "" }
        )
        .eraseToAnyPublisher()
    }
    
    func setText(_ text: String) {
        self.text = text
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)
    }
}

extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        controlPublisher(for: .touchUpInside)
                    .map { _ in }
                    .eraseToAnyPublisher()
    }
    
    var tapDebouncePublisher: AnyPublisher<Void, Never> {
            tapPublisher.debounce(for: 0.1, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
}

extension UITextView {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidChangeNotification, object: self
        )
        .compactMap{ $0.object as? UITextView}
        .map{
            return $0.text ?? ""
        }
        .eraseToAnyPublisher()
    }
    
    func setText(_ text: String) {
         self.text = text
         NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self)
     }
}
