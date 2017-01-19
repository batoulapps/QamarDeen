//
//  Day+CoreDataClass.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/25/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import Foundation
import CoreData

@objc(Day)
public class Day: NSManagedObject {

    /// USAGE: 
    /// used stricly for creating actions, such as pray, fast, ... etc.
    /// using this function will ensure there is a day backing the action.
    class func fetchOrCreate(forDate date: Date) -> Day {
        
        let query: NSFetchRequest<Day> = Day.fetchRequest()
        query.predicate = NSPredicate(format: "gregorianDate = %@", date as NSDate)
        
        let result = try! query.execute()
        if let day = result.first {
            return day
        }
        
        let day = Day(context: DataManager.instance.moc)
        day.gregorianDate = date as NSDate
        day.hijriDate = date as NSDate
        
        return day
    }
    
    /// USAGE:
    /// convenience query for retrieving a range of days for displaying information
    /// some days may have not been created, for which they will be nil
    class func fetchRange(startDate: Date, endDate: Date) -> [Date:Day] {
        assert(startDate <= endDate, "please ensure start date preceeds endDate")
        
        let query: NSFetchRequest<Day> = Day.fetchRequest()
        query.relationshipKeyPathsForPrefetching = ["charities", "prayers", "readings", "fast"]
        query.predicate = NSPredicate(format: "gregorianDate >= %@ AND gregorianDate <= %@",
                                      startDate as NSDate, endDate as NSDate)
        
        var daysDict: [Date:Day] = [:]
        (try! query.execute()).forEach { daysDict[$0.gregorianDate! as Date] = $0 }

        return daysDict
    }
}
