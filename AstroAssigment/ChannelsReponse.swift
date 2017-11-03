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
		var channelId: Int64
		var channelTitle: String
		var channelStbNumber: Int64
	}
	
	var responseCode: String
	var responseMessage: String
	var channels: [Channel]
}
