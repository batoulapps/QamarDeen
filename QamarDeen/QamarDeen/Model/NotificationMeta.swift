//
//  NotificationMeta.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 1/19/17.
//  Copyright © 2017 Batoul Apps. All rights reserved.
//

import Foundation


/// meta data describing a notification
struct NotificationMeta {
    
    var message: String
    var date: Date
    var frequency: NSCalendar.Unit
}
