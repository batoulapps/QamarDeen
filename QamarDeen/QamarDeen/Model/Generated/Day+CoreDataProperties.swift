//
//  Day+CoreDataProperties.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/25/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day");
    }

    @NSManaged public var hijriDate: NSDate?
    @NSManaged public var gregorianDate: NSDate?
    @NSManaged public var isModifiedHijriDate: NSNumber?
    @NSManaged public var charities: NSSet?
    @NSManaged public var fast: Fast?
    @NSManaged public var prayers: NSSet?
    @NSManaged public var readings: NSSet?

}

// MARK: Generated accessors for charities
extension Day {

    @objc(addCharitiesObject:)
    @NSManaged public func addToCharities(_ value: Charity)

    @objc(removeCharitiesObject:)
    @NSManaged public func removeFromCharities(_ value: Charity)

    @objc(addCharities:)
    @NSManaged public func addToCharities(_ values: NSSet)

    @objc(removeCharities:)
    @NSManaged public func removeFromCharities(_ values: NSSet)

}

// MARK: Generated accessors for prayers
extension Day {

    @objc(addPrayersObject:)
    @NSManaged public func addToPrayers(_ value: Prayer)

    @objc(removePrayersObject:)
    @NSManaged public func removeFromPrayers(_ value: Prayer)

    @objc(addPrayers:)
    @NSManaged public func addToPrayers(_ values: NSSet)

    @objc(removePrayers:)
    @NSManaged public func removeFromPrayers(_ values: NSSet)

}

// MARK: Generated accessors for readings
extension Day {

    @objc(addReadingsObject:)
    @NSManaged public func addToReadings(_ value: Reading)

    @objc(removeReadingsObject:)
    @NSManaged public func removeFromReadings(_ value: Reading)

    @objc(addReadings:)
    @NSManaged public func addToReadings(_ values: NSSet)

    @objc(removeReadings:)
    @NSManaged public func removeFromReadings(_ values: NSSet)

}
