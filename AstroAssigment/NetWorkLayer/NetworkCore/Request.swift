//
//  ChanelRequest.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/1/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import Foundation

let baseURL = "http://ams-api.astro.com.my/ams/v3"

enum ChanelRequest {
	case listChannel
	case channel
}


extension ChanelRequest: Request {
	var path: String {
		switch self {
		case .listChannel:
			return "/getChannelList"
		default:
			return ""
		}
	}
	
	var method: HTTPMethod {
		switch self {
		default:
			return .get
		}
	}
	
	var parameters: RequestParams {
		switch self {
		default:
			return .url(nil)
		}
	}
	
	var headers: [String : Any]? {
		return nil
	}
	
	var dataType: DataType {
		return .json
	}
}





