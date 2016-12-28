//
//  Quran.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/28/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import Foundation

/// Quran
/// it is the holy book of Islam. It is divided in two ways:
/// 1. Into Surahs, which are further split into Ayahs
/// 2. Into Juzs, which are a collections of Page Faces
class Quran {
    
    static let instance = Quran()

    
    lazy var surahs: [Surah] = {
        
        let plist = Bundle.main.url(forResource: "Surahs", withExtension: "plist")!
        return (NSArray(contentsOf: plist) as! [[String:Any]])
            .map { Surah(ayahCount: $0["Ayahs"] as! Int, name: $0["Name"] as! String) }
    }()
    
}

// MARK: Surah

extension Quran {
    
    struct Surah {
        let ayahCount: Int
        let name: String
    }
}
