//  
//  Coordinator.swift
//  Map
//
//  Created by Adonay on 21/05/24.
//

import UIKit

public protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
