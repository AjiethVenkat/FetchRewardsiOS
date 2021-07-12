//
//  FavID+CoreDataProperties.swift
//  FetchRewards
//
//  Created by AjiethVenkat on 7/9/21.
//
//

import Foundation
import CoreData


extension FavID {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavID> {
        return NSFetchRequest<FavID>(entityName: "FavID")
    }

    @NSManaged public var id: Int64

}

extension FavID : Identifiable {

}
