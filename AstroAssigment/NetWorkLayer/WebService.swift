//
//  Webservice.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/1/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import Foundation

final class WebService {
	static let shared = WebService()
	private lazy var decoder: JSONDecoder = {
		return JSONDecoder()
	}()
	
	private init() { }
	
	private lazy var session: URLSession = {
		let config = URLSessionConfiguration.default
		return URLSession(configuration: config)
	}()
	
	private let channelListURL = "http://ams-api.astro.com.my/ams/v3/getChannelList"
	private let channelsURL = "http://ams-api.astro.com.my/ams/v3/getChannels"
}

// MARK: ChannelListViewController
extension WebService {
	func fetchChannelList(completion handler: @escaping (ChannelListReponse?) -> Void) {
		guard let url = URL(string: channelListURL) else {
			handler(nil)
			return
		}
		
		let task = session.dataTask(with: url) { [weak self] (data, _, error) in
			guard error == nil,
			let data = data, let decoder = self?.decoder else {
				handler(nil)
				return
			}
			
			let reponse = try? decoder.decode(ChannelListReponse.self, from: data)
			handler(reponse)
		}
		task.resume()
	}
	
	func loadChannelList(completion handler: @escaping ([Channel]?) -> Void) {
		let coreDataStack = CoreDataStack.shared
		// First get data from core data
		let channels = coreDataStack.getChannel()
		handler(channels)
		
		// Now fetch data
		self.fetchChannelList { (channelListResponse) in
			guard let channels = channelListResponse?.channels else {
				return
			}
			coreDataStack.saveInBackground(channels: channels) {  (error) in
				guard error == nil else {
					print("Error when save \(String(describing: error?.localizedDescription))")
					return
				}
				// Get databack from core data
				let channel = coreDataStack.getChannel()
				handler(channel)
			}
		}
		
	}
}

// MARK: ChannelsViewController

extension WebService {
	func getChannels(with channelsID: [Int]? = nil, completion handler: @escaping (ChannelsResponse?) -> Void)  {
		var parameterString: String? = nil
		if let channelsID = channelsID {
			parameterString = channelsID.map {
				String.init(format: "%d", $0)
				}.joined(separator: ",")
		}
		
		var channelListURL = self.channelsURL
		if let parameterString = parameterString {
			channelListURL.append("?channelId=" + parameterString)
		}
		
		guard let url = URL(string: channelListURL) else { return  }
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		
		let task = session.dataTask(with: request) { [weak self] (data, response, error) in
			guard error == nil else { return }
			
			guard let data = data, let decoder = self?.decoder  else {
				return
			}
			
			do {
				let reponse = try decoder.decode(ChannelsResponse.self, from: data)
				handler(reponse)
			} catch {
				fatalError("Decode wrong ChannelsResponse: ")
			}
		}
		task.resume()
	}
}
