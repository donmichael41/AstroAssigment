//
//  FavouriteChannel+CoreDataProperties.swift
//  
//
//  Created by hungnguyen on 11/4/17.
//
//

import Foundation
import CoreData


extension FavouriteChannel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteChannel> {
        return NSFetchRequest<FavouriteChannel>(entityName: "FavouriteChannel")
    }

    @NSManaged public var channelID: Int64
    @NSManaged public var channelStbNumber: Int64
    @NSManaged public var channelTitle: String?
    @NSManaged public var favourite: Bool

}
