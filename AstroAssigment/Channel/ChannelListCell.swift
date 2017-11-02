//
//  ChannelListCell.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/2/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import UIKit

class ChannelListCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var idLabel: UILabel!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		nameLabel.text = ""
		numberLabel.text = ""
		idLabel.text = ""
		accessoryType = .none
	}

	func configCell(with channel: ChannelReponse.Channel)  {
		nameLabel.text = channel.channelTitle
		numberLabel.text = String(describing: channel.channelStbNumber)
		idLabel.text = String(describing: channel.channelId)
	}
}
