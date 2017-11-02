//
//  Webservice.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/1/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import Foundation

final class WebAPI {
	static let shared = WebAPI()
	private lazy var decoder: JSONDecoder = {
		return JSONDecoder()
	}()
	
	private init() { }
	
	private lazy var session: URLSession = {
		let config = URLSessionConfiguration.default
		return URLSession(configuration: config)
	}()
	
	private let channelListURL = "http://ams-api.astro.com.my/ams/v3/getChannelList"
	
	func fetchChannelList(completion handler: @escaping (ChannelReponse?) -> Void) {
		
		guard let url = URL(string: channelListURL) else { return  }
		
		let task = session.dataTask(with: url) { [weak self] (data, _, error) in
			guard error == nil else { return }
			
			guard let data = data, let decoder = self?.decoder  else { return }
			
			let reponse = try? decoder.decode(ChannelReponse.self, from: data)
			handler(reponse)
			print(Thread.isMainThread)
		}
		task.resume()
	}
}


public class WebService: Service {
	
	private var environment: ServiceConfig
	
	private var session: URLSession
	
	required public init(environment: ServiceConfig) {
		self.environment = environment
		self.session = URLSession(configuration: URLSessionConfiguration.default)
	}
	
	func execute(request: Request) throws {
		
	}
	
	private func prepareURLRequest(for request: Request) throws -> URLRequest {
		// Compose the url
		let fullURL = "\(environment.host)/\(request.path)"
		var urlRequest = URLRequest(url: URL(string: fullURL)!)
		
		// Working with parameters
		switch request.parameters {
		case .body(let params):
			// Parameters are part of the body
			if let params = params as? [String: String] { // just to simplify
				urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))
			} else {
				throw NetworkErrors.badInput
			}
		case .url(let params):
			// Parameters are part of the url
			if let params = params as? [String: String] { // just to simplify
				let query_params = params.map({ (element) -> URLQueryItem in
					return URLQueryItem(name: element.key, value: element.value)
				})
				guard var components = URLComponents(string: fullURL) else {
					throw NetworkErrors.badInput
				}
				components.queryItems = query_params
				urlRequest.url = components.url
			} else {
				throw NetworkErrors.badInput
			}
		}
		
		// Add headers from enviornment and request
		environment.headers.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
		
		request.headers?.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
		
		// Setup HTTP method
		urlRequest.httpMethod = request.method.rawValue
		
		return urlRequest
	}

}
