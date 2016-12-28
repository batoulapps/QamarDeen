//
//  Prayer+CoreDataProperties.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/25/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import Foundation
import CoreData


extension Prayer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Prayer> {
        return NSFetchRequest<Prayer>(entityName: "Prayer");
    }

    @NSManaged public var type: NSNumber?
    @NSManaged public var method: NSNumber?
    @NSManaged public var day: Day?

}
