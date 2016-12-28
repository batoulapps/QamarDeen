//
//  Charity+CoreDataClass.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/25/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import Foundation
import CoreData

@objc(Charity)
public class Charity: NSManagedObject {

}

// MARK: Charity.Kind

extension Charity {
    
    enum Kind: NSNumber {
        
        case money
        case effort
        case feeding
        case clothes
        case smile
        case other
    }
}
