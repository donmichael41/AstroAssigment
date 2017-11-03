//
//  ChannelsViewController.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/2/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import UIKit

let ChannelCollectionViewCellIdentofer = "ChannelCollectionViewCell"

class ChannelsViewController: UIViewController {

	var channels: [ChannelsResponse.Channel]? {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	@IBOutlet weak var collectionView: UICollectionView!
	override func viewDidLoad() {
        super.viewDidLoad()
		setupTcollectionView()
        // Do any additional setup after loading the view.
		
		WebAPI.shared.getChannels(with: [1, 2]) { [weak self] (channelResponse) in
			self?.channels = channelResponse?.channels
		}
    }
	
	private(set) var lastIndexPath: IndexPath?
	func updateLastIndexPath(_ channels: [ChannelsResponse.Channel]?) {
		if let channels = channels, channels.isEmpty {
			lastIndexPath = nil
		} else {
			lastIndexPath = calculateLastIndexPath()
		}
	}
	
	private func calculateLastIndexPath() -> IndexPath? {
//		guard let lastPage = productPages.last else { return nil }
//		let section = lastPage.pageNumber
//		let row = lastPage.results.count - 1
//		return IndexPath(row: row, section: section)
		return nil
	}
}

// MARK: - Helper method
extension ChannelsViewController {
	private func setupTcollectionView() {
		collectionView.dataSource = self
		collectionView.delegate = self
		
		
	}
}


// MARK: - UICollectionViewDataSource
extension ChannelsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let channels = channels else { return 0 }
		return channels.count
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelCollectionViewCellIdentofer, for: indexPath) as! ChannelCollectionViewCell
		
		if let channel = channels?[indexPath.row] {
			cell.config(channel: channel)
		}

		return cell
	}
	
}


// MARK: - UICollectionViewDelegate
extension ChannelsViewController: UICollectionViewDelegate {
	
}
