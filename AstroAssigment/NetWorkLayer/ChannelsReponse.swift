//
//  ChannelsReponse.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/2/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import Foundation

struct ChannelsResponse: Codable {
	struct Channel: Codable {
		struct ChannelExtRef: Codable {
			var system: String
			var subSystem: String
			var value: String
		}
		var channelId: Int64
		var siChannelId: String
		var channelTitle: String
		var channelStbNumber: String
		var channelExtRef: [ChannelExtRef]
	}
	
	var responseCode: String
	var responseMessage: String
	var channel: [Channel]
}
