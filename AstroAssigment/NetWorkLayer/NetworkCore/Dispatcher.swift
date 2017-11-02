//
//  Dispatcher.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/1/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import Foundation
import PromiseKit

protocol Service {
	
	/// Configure the dispatcher with an environment
	///
	/// - Parameter environment: environment configuration
	init(environment: ServiceConfig)
	
	
	/// This function execute the request and provide a Promise
	/// with the response.
	///
	/// - Parameter request: request to execute
	
	func execute(request: Request) throws
	
}
