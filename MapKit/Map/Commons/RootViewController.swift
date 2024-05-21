//  
//  RootViewController.swift
//  Map
//
//  Created by Adonay on 21/05/24.
//

import UIKit

class RootViewController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        presentedViewController ?? visibleViewController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        (presentedViewController ?? visibleViewController)?.preferredStatusBarStyle ?? .darkContent
    }
}