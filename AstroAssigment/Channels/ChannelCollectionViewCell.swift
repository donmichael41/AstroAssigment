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
	
	func config(channel: ChannelsResponse.Channel) {
		nameLabel.text = String.init(describing: channel.channelId)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
	}
}
