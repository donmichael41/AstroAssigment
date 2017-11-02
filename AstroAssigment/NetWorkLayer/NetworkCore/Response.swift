//
//  Response.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/1/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import Foundation

public enum Response {
	case json(_: Data)
	case data(_: Data)
	case error(_: Int?, _: Error?)
	
	init(_ response: (r: HTTPURLResponse?, data: Data?, error: Error?), for request: Request) {
		guard response.r?.statusCode == 200, response.error == nil else {
			self = .error(response.r?.statusCode, response.error)
			return
		}
		
		guard let data = response.data else {
			self = .error(response.r?.statusCode, NetworkErrors.noData)
			return
		}
		
		switch request.dataType {
		case .data:
			self = .data(data)
		case .json:
			self = .json(data)
		}
	}
}
