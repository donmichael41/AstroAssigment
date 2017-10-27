//
//  NetworkLayer.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/1/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import Foundation


final class WebAPI {
	static let shared = WebAPI()
	static let decoder = JSONDecoder()
	
	private init() {}
	
	let endPoint = "http://ams-api.astro.com.my/ams/v3/getChannelList"
	
	func fetch(completion handler: @escaping (ChannelReponse?) -> Void) {
		let urlSession = URLSession.shared
		guard let url = URL(string: endPoint) else { return  }
		
		let task = urlSession.dataTask(with: url) { (data, _, error) in
			guard error == nil else { return }
			
			guard let data = data else { return }
			
			let reponse = try? WebAPI.decoder.decode(ChannelReponse.self, from: data)
			
			print(Thread.isMainThread)
		}
		task.resume()
	}
}
