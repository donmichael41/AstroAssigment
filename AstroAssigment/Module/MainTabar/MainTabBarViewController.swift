//
//  MainTabBarViewController.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/5/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

		self.delegate = self
        // Do any additional setup after loading the view.
		if let channelListVC = self.viewControllers?[0] as? ChannelListViewController {
			channelListVC.delegate = self
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
}

extension MainTabBarViewController: UITabBarControllerDelegate {
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		return true
	}
}

extension MainTabBarViewController: ChannelListViewControllerDelegate {
	func goToUserViewController() {
		_ = self.delegate?.tabBarController!(self, shouldSelect:  (self.viewControllers?[2])!)
		self.selectedIndex = 2
	}
}
