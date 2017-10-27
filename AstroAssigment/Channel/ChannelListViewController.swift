//
//  ChannelListViewController.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/1/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import UIKit

 let channelListCellIndentifier = "ChannelListCellIndentifier"

class ChannelListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	var channels: [ChannelReponse.Channel]? {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: channelListCellIndentifier)
		
		WebAPI.shared.fetch() { [weak self] channelReponse in
			guard let channelReponse = channelReponse else { return }
			self?.channels = channelReponse.channels
		}
    }
}


extension ChannelListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let channels = channels else { return 0 }
		
		return channels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: channelListCellIndentifier, for: indexPath)
		
		guard let channels = channels else { return cell }
		
		cell.textLabel?.text = channels[indexPath.row].channelTitle
		
		return cell
	}
}
