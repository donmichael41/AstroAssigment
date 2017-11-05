//
//  File.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/5/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import UIKit

final class Cache {
	typealias imageBlock = (UIImage) -> Void
	static let shared = Cache()
	
	private init() {}
	
	lazy var cached: NSCache<NSURL, UIImage> = {
		let cache = NSCache<NSURL, UIImage>()
		cache.name = "MyImageCache"
		cache.countLimit = 200
		cache.totalCostLimit = 100*1024*1024
		return cache
	}()
	
	lazy var session: URLSession = {
		return URLSession(configuration: .ephemeral)
	}()
}

// MARK: - Cached load image

extension Cache {
	func loadImage(with urlString: String, needCached: Bool = true, completion:  @escaping imageBlock) {
		guard let url = URL.init(string: urlString) else {
			completion(#imageLiteral(resourceName: "no_data"))
			return
		}
		guard let image = cached.object(forKey: url as NSURL), needCached else {
			let task = session.dataTask(with: url) { [weak self] (data, _, _) in
				guard let data = data, let image = UIImage(data: data) else {
					completion(#imageLiteral(resourceName: "no_data"))
					return
				}
				self?.cached.setObject(image, forKey: url as NSURL)
				completion(image)
			}
			task.resume()
			return
		}
		completion(image)
	}
}
