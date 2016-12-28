//
//  Fast+CoreDataClass.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/25/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import Foundation
import CoreData

@objc(Fast)
public class Fast: NSManagedObject {

}

// MARK: Fast.Kind

extension Fast {
    
    enum Kind: NSNumber {
        
        case none
        case mandatory
        case voluntary
        case reconcile
        case forgiveness
        case vow
    }
}
