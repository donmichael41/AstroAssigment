//
//  ChannelCollectionViewCell.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/2/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var logoImage: UIImageView!
	
	override func prepareForReuse() {
		nameLabel.text = ""
		logoImage.image = nil
		generation += 1
	}
	
	private var generation = 0
	
	func config(channelExtRef: ChannelsResponse.Channel.ChannelExtRef, and indexPath: IndexPath) {
		nameLabel.text = channelExtRef.system + "\(indexPath.section) == \(indexPath.row)"
		let currentGeneration = self.generation
		self.logoImage.alpha = 0
		Cache.shared.loadImage(with: channelExtRef.value) { [weak self] (image) in
			guard currentGeneration == self?.generation else {
				return
			}
			DispatchQueue.main.async {
				self?.logoImage.image = image
				UIView.animate(withDuration: 0.3) {
					self?.logoImage.alpha = 1
				}
			}
		}
	}
}
