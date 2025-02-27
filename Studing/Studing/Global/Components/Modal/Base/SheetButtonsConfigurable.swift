//
//  SheetButtonsConfigurable.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/22/25.
//

import UIKit

protocol SheetButtonsConfigurable {
    var buttonContainerView: UIView { get }
    func setupButtons()
    var buttonHeight: CGFloat { get }
}
