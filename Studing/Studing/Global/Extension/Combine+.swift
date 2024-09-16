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
        controlPublisher(for: .editingChanged)
                    .compactMap { $0 as? UITextField }
                    .map { $0.text ?? "" }
                    .eraseToAnyPublisher()
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
