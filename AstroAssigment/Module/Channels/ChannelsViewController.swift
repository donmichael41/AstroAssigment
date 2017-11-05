//
//  ChannelsViewController.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/2/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import UIKit

class ChannelsViewController: UIViewController {
	@IBOutlet weak var segmentControl: UISegmentedControl!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var observationSegment: NSKeyValueObservation!
	var trackLoadChannel = [Int]()
	
	private(set) var lastIndexPath: Int?
	
	var channels = [ChannelsResponse.Channel]() {
		didSet {
			DispatchQueue.main.async {
				self.updateLastIndexPath()
				self.collectionView.reloadData()
			}
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupCollectionView()
		setupObservation()
        // Do any additional setup after loading the view.
		loadChannel()
		self.collectionView.register(UINib(nibName: "ChannelCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ChannelCollectionViewCellIdentofer)
    }
	
	private func setupObservation() {
		let keyPath = \UISegmentedControl.selectedSegmentIndex
		
		observationSegment = segmentControl.observe(keyPath) { [weak self] (control, _) in
			guard let channels = self?.channels else  {
				return
			}
			if control.selectedSegmentIndex == 0 {
				if let channelsSorted = (self?.sort(by: .name, with: channels)) {
					self?.channels = channelsSorted
				}
				
			} else if control.selectedSegmentIndex == 1  {
				if let channelsSorted = self?.sort(by: .channelNumber, with: channels) {
					self?.channels = channelsSorted
				}
			}
		}
	}
}

// MARK: - Helper method
extension ChannelsViewController {
	private func setupCollectionView() {
		collectionView.dataSource = self
		collectionView.delegate = self
	}
	
	
	// MARK: - Load channel by page of 5
	private func loadChannel() {
		trackLoadChannel = calculateNewChannel(currenChannel: trackLoadChannel)
		
		print("LOAD CHANNEL: \(trackLoadChannel)")
		print("================")
		WebService.shared.getChannels(with: trackLoadChannel) { [weak self] (channelResponse) in
			if let channelResponse = channelResponse, channelResponse.channel.count > 0 {
				self?.channels.append(contentsOf: channelResponse.channel)
			}
		}
	}
	
	// MARK: Calculate for next page
	private func calculateNewChannel(currenChannel:  [Int]) -> [Int] {
		var newChannel = [Int]()
		let maxIndex = currenChannel.last ?? 0
		
		for i in 1...2 {
			newChannel.append(i + maxIndex)
		}
		return newChannel
	}
	
	private func updateLastIndexPath() {
		if  channels.isEmpty {
			lastIndexPath = nil
		} else {
			lastIndexPath = calculateLastIndexPath()
		}
	}
	
	private func calculateLastIndexPath() -> Int? {
		guard channels.count > 0 else { return nil }
		return channels.count - 1
	}
}


// MARK: - UICollectionViewDataSource
extension ChannelsViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return channels.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return channels[section].channelExtRef.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelCollectionViewCellIdentofer, for: indexPath) as! ChannelCollectionViewCell
		cell.config(channelExtRef: channels[indexPath.section].channelExtRef[indexPath.row], and: indexPath)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
		case UICollectionElementKindSectionHeader:
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ChannelCollectionViewCellIdentofer, for: indexPath) as! ChannelCollectionReusableView
			headerView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 40)
			headerView.backgroundColor = UIColor.blue
			return headerView
		default:
			assert(false, "Unexpected element kind")
		}
	}
}


// MARK: - UICollectionViewDelegate

extension ChannelsViewController: UICollectionViewDelegate {
	
	// MARK: - Load new channel in needed
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if indexPath.section == lastIndexPath {
			loadChannel()
		}
	}
}
