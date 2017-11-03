//
//  TableView+Extension.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/3/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import UIKit

enum TableState {
	case dataAvaible
	case loading(message: String)
	case showMess(image: String?, title: String?, message: String)
	case showError(image: String?, title: String?, message: String, buttonTitle: String, buttonConfig: (UIButton) -> Void, retryAction: () -> Void)
	case unknown
}


extension ChannelListViewController {
	func change(with state: TableState) {
		switch state {
		case .dataAvaible:
			configShowData()
		case .loading(let message):
			configForLoadingData(message)
		case .showMess(let image, let title, let meess):
			configShowMess(image, title, meess)
		default:
			break
		}
	}
	
	private func configShowData() {
		print("Datavaible")
		stackView.isHidden = true
	}
	
	private func configForLoadingData(_ message: String) {
		print("loading")
		
		stateImageView.isHidden = true
		stackView.isHidden = false
		spinner.startAnimating()
		dataStateSubtitleLabel.text = message
	}
	
	private func configShowMess(_ imageFile: String?,_ title: String?,_ message: String) {
		print("showMess")
		// Image View
		if let imageFile = imageFile {
			stateImageView.isHidden = false
			stateImageView.image = UIImage(named: imageFile)
		} else {
			stateImageView.isHidden  = true
		}
		
		spinner.isHidden = true
		stackView.isHidden = false
		
		dataStateSubtitleLabel.isHidden = false
		dataStateSubtitleLabel.text = message
	}
}
