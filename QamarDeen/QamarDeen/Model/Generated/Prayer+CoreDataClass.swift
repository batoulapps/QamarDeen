//
//  Prayer+CoreDataClass.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/25/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import Foundation
import CoreData

@objc(Prayer)
public class Prayer: NSManagedObject {

}

// MARK: Prayer.Method

extension Prayer {

    enum Method: NSNumber {
        
        case none
        case alone
        case aloneWithVoluntary
        case group
        case groupWithVoluntary
        case late
        case excused
    }
}

// MARK: Prayer.Kind

extension Prayer {
    
    enum Kind: NSNumber {
        
        case fajr
        case shuruq
        case dhuhr
        case asr
        case maghrib
        case isha
        case qiyam
    }
}
