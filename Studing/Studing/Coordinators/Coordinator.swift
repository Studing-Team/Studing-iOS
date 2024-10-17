//
//  Coordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import UIKit

protocol Coordinator: AnyObject {
    associatedtype NavigationControllerType: UINavigationController
    var navigationController: NavigationControllerType { get set }
    var childCoordinators: [any Coordinator] { get set }
    func start()
}
