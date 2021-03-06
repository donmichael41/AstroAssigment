//
//  ChannelListViewController.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/1/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import UIKit

protocol ChannelListViewControllerDelegate: class {
	func goToUserViewController()
}

class ChannelListViewController: UIViewController {
	
	weak var delegate: ChannelListViewControllerDelegate?

	@IBOutlet weak var segmentControl: UISegmentedControl!
	@IBOutlet weak var tableView: UITableView!
	
	var observationSegment: NSKeyValueObservation!
	
	var channels: [Channel]? {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	// MARK: - UIProperties
	var stackView = UIStackView.autolayoutView()
	var titleStackView = UIStackView.autolayoutView()
	var actionButton = UIButton.autolayoutView()
	var stateImageView = UIImageView.autolayoutView()
	
	lazy var dataStateSubtitleLabel: UILabel = {
		let label = UILabel.autolayoutView()
		label.textColor = .gray
		return label
	}()
	
	lazy var spinner: UIActivityIndicatorView = {
		return UIActivityIndicatorView(activityIndicatorStyle: .gray)
	}()
	
	
	var buttonAction: (() -> Void)?
	
	var currentState = TableState.unknown {
		didSet {
			DispatchQueue.main.async {
				self.change(with: self.currentState)
			}
		}
	}
	
	
	var favourite = [String: Any]()
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupTableState()
	}
	
	var stateViewCenterPositionOffset = CGPoint(x: 0.0, y: 0.0)
	
	// MARK: - Setup UI
	func setupTableState() {
		titleStackView.axis = .vertical
		titleStackView.distribution = .equalSpacing
		titleStackView.alignment = .center
		titleStackView.spacing = 8.0
		
		stackView.axis = .vertical
		stackView.distribution = .equalSpacing
		stackView.alignment = .center
		stackView.spacing = 16.0
		
		titleStackView.addArrangedSubview(dataStateSubtitleLabel)
		
		stackView.addArrangedSubview(spinner)
		stackView.addArrangedSubview(stateImageView)
		stackView.addArrangedSubview(titleStackView)
		
		view.addSubview(stackView)
		//Constraints
		stackView._setCenterAlignWith(view: self.tableView, offset: stateViewCenterPositionOffset)
	}
	
	// MARK: - View Cicle
	override func viewDidLoad() {
        super.viewDidLoad()
		setupTable()
		setupObservation()
		NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillTerminate, object: nil, queue: nil) { [weak self] (_) in
			if let favourite = self?.favourite {
				
				UserDefaults.standard.set(favourite, forKey: kFavouriteChannel)
			}
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetch()
	}
	
	// MARK: - Fetch data
	
	private func fetch() {
		currentState = .loading(message: "Loading")
		WebService.shared.loadChannelList() { [weak self] channels in
			guard let channels = channels else {
				if let _ = self?.channels  {
					self?.currentState = .dataAvaible
				} else {
					self?.currentState = .showMess(image: "server_error", title: "SERVER ERROR", message: "We will be back soon")
				}
				return
			}
			self?.channels = channels
			self?.currentState = .dataAvaible
		}
		if let favourite = UserDefaults.standard.dictionary(forKey: kFavouriteChannel) {
			self.favourite = favourite
		}
	}
}

// MARK: - Helper method
extension ChannelListViewController {
	private func setupTable() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.allowsMultipleSelection = true
		
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
	
	func sort(by sortType: SortType, with channels: [Channel]) -> [Channel] {
		switch sortType {
		case .channelNumber:
			return channels.sorted { (lhs, rhs)  in
				lhs.channelStbNumber < rhs.channelStbNumber
			}
		case .name:
			return channels.sorted { (lhs, rhs)  in
				lhs.channelTitle!.localizedCaseInsensitiveCompare(rhs.channelTitle!) == ComparisonResult.orderedAscending
			}
		}
	}
}

// MARK: - UITableViewDelegate
extension ChannelListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		
		let isLogin = UserDefaults.standard.bool(forKey: kIsUserLogin)
		
		guard isLogin else {
			delegate?.goToUserViewController()
			
			return
		}
		
		guard let channel = channels?[indexPath.row] else { return }
		channel.favourite = true
		CoreDataStack.shared.trySave()
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.accessoryType = .none
		guard let channel = channels?[indexPath.row] else { return }
		
		channel.favourite = false
		CoreDataStack.shared.trySave()
	}
}

// MARK: - UITableViewDataSource
extension ChannelListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let channels = channels, !channels.isEmpty else {
			tableView.separatorStyle = .none
			return 0
		}
		tableView.separatorStyle = .singleLine
		return channels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: channelListCellIndentifier, for: indexPath) as! ChannelListCell
		
		guard let channels = channels else { return cell }
		
		cell.configCell(with: channels[indexPath.row])
		
		return cell
	}
}
