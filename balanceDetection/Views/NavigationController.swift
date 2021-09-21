//
//  NavigationController.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 26.05.21.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        self.setViewControllers([HomeViewController()], animated: true)
        
        //MARK: Customize NavigationBar
        let navigationBarAppearence = UINavigationBarAppearance()
        navigationBarAppearence.shadowColor = .clear
        navigationBarAppearence.backgroundColor = UIColor(named: "BackgroundSecondary")
        navigationBar.standardAppearance = navigationBarAppearence
    }

}

