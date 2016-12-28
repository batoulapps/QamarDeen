//
//  Reading+CoreDataClass.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/25/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import Foundation
import CoreData

@objc(Reading)
public class Reading: NSManagedObject {

}

// MARK: Calculations

extension Reading {
    
    var ayahCount: Int {
        
        guard let sAyah = startAyah?.intValue,
            let sSurah = startSurah?.intValue,
            let eAyah = endAyah?.intValue,
            let eSurah = endSurah?.intValue,
            eSurah >= sSurah
            else
        {
            return 0
        }
        
        return (eAyah - sAyah) + (sSurah..<eSurah)
            .map { Quran.instance.surahs[$0] }
            .map { $0.ayahCount }
            .reduce(0, +)
    }
}
