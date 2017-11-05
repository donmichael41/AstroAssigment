//
//  UserViewController.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/4/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import UIKit
import FacebookLogin

class UserViewController: UIViewController {

	@IBOutlet weak var inforLabel: UILabel! {
		didSet {
			updateState()
		}
	}
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		let loginButton = LoginButton(readPermissions: [ .publicProfile ])
		loginButton.center = view.center
		loginButton.delegate = self
		view.addSubview(loginButton)
    }


	private func updateState() {
		inforLabel.isHidden = UserDefaults.standard.bool(forKey: kIsUserLogin)
	}
}

extension UserViewController: LoginButtonDelegate {
	func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
		switch result {
		case .success(_, _,let token):
			print("Token:\(token)")
			UserDefaults.standard.set(true, forKey: kIsUserLogin)
			updateState()
		default:
			print("Fails")
			updateState()
		}
	}
	

	func loginButtonDidLogOut(_ loginButton: LoginButton) {
		UserDefaults.standard.set(false, forKey: kIsUserLogin)
		CoreDataStack.shared.removeData { (error) in
			if error == nil {
				UserDefaults.standard.set(false, forKey: kIsUserLogin)
				updateState()
			} else {
				print(error?.localizedDescription)
			}
		}
		updateState()
	}
}

