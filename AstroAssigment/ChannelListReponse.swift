//
//  Model.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/1/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import Foundation


struct ChannelListReponse: Codable {
	struct Channel: Codable {
		var channelId: Int64
		var channelStbNumber: Int64
		var channelTitle: String
	}

	var responseMessage: String
	var responseCode: String
	var channels: [Channel]
}
