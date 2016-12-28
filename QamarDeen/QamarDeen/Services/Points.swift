//
//  Points.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/28/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import Foundation

/// Points
/// class which holds the points calculation
private class Points {
    
    static func `for`(_ fast: Fast) -> Int {
        
        guard let rawValue = fast.type, let fastKind = Fast.Kind(rawValue: rawValue) else {
            return 0
        }
        
        switch fastKind {
        case .none:         return 0
        case .forgiveness:  return 100
        case .vow:          return 250
        case .reconcile:    return 400
        case .voluntary:    return 500
        case .mandatory:    return 500
        }
    }
    
    static func `for`(_ charity: Charity) -> Int {
        
        guard let rawValue = charity.type, let charityKind = Charity.Kind(rawValue: rawValue) else {
            return 0
        }
        
        switch charityKind {
        case .smile:    return 25
        default:        return 100
        }
    }
    
    static func `for`(_ prayer: Prayer) -> Int {
        
        guard let methodValue = prayer.method,
            let method = Prayer.Method(rawValue: methodValue),
            let kindValue = prayer.type,
            let kind = Prayer.Kind(rawValue: kindValue)
            else
        {        
            return 0
        }
        
        switch (method, kind) {
        case (.alone, .shuruq): return 200
        case (.alone, .qiyam):  return 300
        case (.alone, _):       return 100
            
        case (.group, .qiyam):  return 300
        case (.group, _):       return 400
            
        case (.aloneWithVoluntary, _):  return 200
        case (.groupWithVoluntary, _):  return 500
            
        case (.late, _):    return 25
        case (.excused, _): return 300
            
        default:    return 0
        }
    }
    
    static func `for`(_ reading: Reading) -> Int {
        return reading.ayahCount * 2
    }
}

/// Extensions
/// convenience access to point calculation through model classes

// MARK: CountableAction
extension Collection where Iterator.Element: CountableAction {
    
    var points: Int {
        return map { $0.points }
            .reduce(0, +)
    }
}

// MARK: Fasting
extension Fast: CountableAction {
    
    var points: Int {
        return Points.for(self)
    }
}

// MARK: Charity
extension Charity: CountableAction {
    
    var points: Int {
        return Points.for(self)
    }
}

// MARK: Prayer
extension Prayer: CountableAction {
    
    var points: Int {
        return Points.for(self)
    }
}

/// MARK: Reading
extension Reading: CountableAction {
    
    var points: Int {
        return Points.for(self)
    }
}

// MARK: Day
extension Day: CountableAction {
    
    var charityCollection: [Charity] {
        return charities?.flatMap { $0 as? Charity } ?? []
    }
    
    var prayerCollection: [Prayer] {
        return prayers?.flatMap { $0 as? Prayer } ?? []
    }
    
    var readingsCollection: [Reading] {
        return readings?.flatMap { $0 as? Reading } ?? []
    }
    
    var points: Int {
        return [
            fast?.points ?? 0,
            prayerCollection.points,
            charityCollection.points,
            readingsCollection.points
        ].reduce(0, +)
    }    
}
