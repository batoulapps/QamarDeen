//
//  Reading+CoreDataProperties.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/25/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import Foundation
import CoreData


extension Reading {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reading> {
        return NSFetchRequest<Reading>(entityName: "Reading");
    }

    @NSManaged public var endSurah: NSNumber?
    @NSManaged public var startSurah: NSNumber?
    @NSManaged public var startAyah: NSNumber?
    @NSManaged public var endAyah: NSNumber?
    @NSManaged public var isExceptional: NSNumber?
    @NSManaged public var day: Day?

}
