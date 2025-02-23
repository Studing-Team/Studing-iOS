//
//  SheetContentConfigurable.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/22/25.
//

import UIKit

protocol SheetContentConfigurable {
    var contentView: UIView { get }
    func setupContent()
}
