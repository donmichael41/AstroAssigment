//
//  Endpoint.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/1/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import Foundation

public struct ServiceConfig {
	
	/// Endpoint is a struct which encapsulate all the informations
	/// we need to perform a setup of our Networking Layer.
	/// may also want to include any SSL certificate or wethever you need.
	
	var name: String
	var host: String
	var headers: [String: Any] = [:]
	
	var cachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy
	
	init(_ name: String, host: String) {
		self.name = name
		self.host = host
	}
}
