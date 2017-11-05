//
//  CoreDataLayer.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/4/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
	static let shared = CoreDataStack()
	
	lazy var appplicationDocumentDirectory: URL = {
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls.last!
	}()
	
	lazy var persistenContainer: NSPersistentContainer = {
		let _persistenContainer = NSPersistentContainer(name: "Channel")
		_persistenContainer.loadPersistentStores  { (description, error) in
			if let error = error {
				fatalError("Failed to load Core Data stack: \(error)")
			}
		}
		return _persistenContainer
	}()
	
	
	private init() {
	}
}

extension CoreDataStack {
	func trySave() {
		do {
			try self.persistenContainer.viewContext.save()
		} catch {
			print("\(error.localizedDescription)")
		}
	}
	
	func removeData(completion handler: (Error?) -> Void) {
		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Channel")
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
		
		do {
			try self.persistenContainer.viewContext.execute(deleteRequest)
			try self.persistenContainer.viewContext.save()
			handler(nil)
		} catch {
			handler(error)
			print("\(error.localizedDescription)")
		}
	}
	
	func saveInBackground(channels: [ChannelListReponse.Channel], completion handler: @escaping (Error?) -> Void) {
		persistenContainer.performBackgroundTask { (context) in
			do {
				for channel in channels {
					let des = NSEntityDescription.entity(forEntityName: "Channel", in: context)
					let favouriteChannel = Channel(entity: des!, insertInto: context)
					favouriteChannel.channelID = channel.channelId
					favouriteChannel.channelStbNumber = channel.channelStbNumber
					favouriteChannel.channelTitle = channel.channelTitle
					favouriteChannel.favourite =  false
				}
				try context.save()
				handler(nil)
			} catch {
				handler(error)
				print("Error importing messages: \(error.localizedDescription)")
			}
		}
	}
	
	func getChannel() -> [Channel] {
		let fetchRequest: NSFetchRequest<Channel> = Channel.fetchRequest()
		let channels = try! self.persistenContainer.viewContext.fetch(fetchRequest)
		
		return channels
	}
}


