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

	@IBOutlet weak var segmentControl: UISegmentedControl!
	@IBOutlet weak var tableView: UITableView!
	
	var observationSegment: NSKeyValueObservation!
	
	var channels: [ChannelReponse.Channel]? {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	var favourite = [String: Any]()
	
	// MARK: - View Cicle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupTable()
		
		setupObservation()
		
		WebAPI.shared.fetchChannelList() { [weak self] channelReponse in
			guard let channelReponse = channelReponse else { return }
			self?.channels = channelReponse.channels
		}
		if let favourite = UserDefaults.standard.dictionary(forKey: "favouriteChannel") {
			self.favourite = favourite
		}
		
		
		NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillTerminate, object: nil, queue: nil) { [weak self] (_) in
			if let favourite = self?.favourite {
				
				UserDefaults.standard.set(favourite, forKey: "favouriteChannel")
			}
			
			NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
		}
		
    }
	
	

}
enum SortType {
	case name, channelNumber
}
// MARK: - Helper method
extension ChannelListViewController {
	private func setupTable() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.allowsMultipleSelection = true
		tableView.separatorStyle = .none
	}
	
	func setupObservation() {
		let keyPath = \UISegmentedControl.selectedSegmentIndex
		
		observationSegment = segmentControl.observe(keyPath) { [weak self] (control, _) in
			guard let channels = self?.channels else  {
				return
			}
			if control.selectedSegmentIndex == 0 {
				self?.channels = self?.sort(by: .name, with: channels)
			} else if control.selectedSegmentIndex == 1  {
				self?.channels = self?.sort(by: .channelNumber, with: channels)
			}
		}
	}
	
	func sort(by sortType: SortType, with channels: [ChannelReponse.Channel]) -> [ChannelReponse.Channel] {
		switch sortType {
		case .channelNumber:
			return channels.sorted { (lhs, rhs)  in
				lhs.channelStbNumber < rhs.channelStbNumber
			}
		case .name:
			return channels.sorted { (lhs, rhs)  in
				lhs.channelTitle.localizedCaseInsensitiveCompare(rhs.channelTitle) == ComparisonResult.orderedAscending
			}
		}
	}
}

// MARK: - UITableViewDelegate
extension ChannelListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		guard let id = channels?[indexPath.row].channelId else { return }
		favourite["\(id)"] = id
		
		
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.accessoryType = .none
		guard let id = channels?[indexPath.row].channelId else { return }
		favourite["\(id)"] = nil
	}

//	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//		if let oldIndex = tableView.indexPathForSelectedRow {
//			tableView.cellForRow(at: oldIndex)?.accessoryType = .none
//		}
//		tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//
//		return indexPath
//	}
}

// MARK: - UITableViewDataSource
extension ChannelListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let channels = channels else { return 0 }
		
		return channels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: channelListCellIndentifier, for: indexPath) as! ChannelListCell
		
		guard let channels = channels else { return cell }
		
		cell.configCell(with: channels[indexPath.row])
		
		
		if let _ = favourite["\(channels[indexPath.row].channelId)"] {
			cell.accessoryType = .checkmark
		}
		
		return cell
	}
}
