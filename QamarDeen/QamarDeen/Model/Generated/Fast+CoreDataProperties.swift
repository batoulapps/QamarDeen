//
//  Fast+CoreDataProperties.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/25/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import Foundation
import CoreData


extension Fast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fast> {
        return NSFetchRequest<Fast>(entityName: "Fast");
    }

    @NSManaged public var type: NSNumber?
    @NSManaged public var day: Day?

}
