//
//  Coordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: CustomSignUpNavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}
