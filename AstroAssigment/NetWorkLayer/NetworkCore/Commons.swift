//
//  NetworkHelper.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/1/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import Foundation

public protocol Request {
	
	var path		: String				{ get }
	
	var method		: HTTPMethod			{ get }
	
	var parameters	: RequestParams			{ get }
	
	var headers		: [String: Any]?		{ get }
	
	var dataType	: DataType				{ get }
}


public enum HTTPMethod: String {
	case post			= "POST"
	case put			= "PUT"
	case get			= "GET"
	case delete			= "DELETE"
	case patch			= "PATCH"
}

public enum RequestParams {
	case body(_ : [String: Any]?)
	case url(_ : [String: Any]?)
}

public enum DataType {
	case json
	case data
}

public enum NetworkErrors: Error {
	case badInput
	case noData
}
