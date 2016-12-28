//
//  ReadingTests.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/28/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import XCTest
@testable import QamarDeen


class ReadingTests: XCTestCase {
    
    
    private func createReading() -> Reading {
        return Reading(context: DataManager.instance.moc)
    }
    

    func testAyahCountWithNilValues() {
        
        let reading = createReading()
        XCTAssertEqual(reading.ayahCount, 0)
    }
    
    func testAyahCountWithEndAfterStart() {
        
        let reading = createReading()
        
        reading.startSurah = 2
        reading.startAyah = 1
        
        reading.endSurah = 1
        reading.endAyah = 1
        
        XCTAssertEqual(reading.ayahCount, 0)
    }
    
    func testAyahCountWithinTheSameSurah() {
        
        let reading = createReading()
        
        reading.startSurah = 10
        reading.startAyah = 5
        
        reading.endSurah = 10
        reading.endAyah = 25
        
        XCTAssertEqual(reading.ayahCount, 20)
    }
    
    func testAyahCountWithDifferentStartAndEndSurahs() {
        
        let reading = createReading()
        
        reading.startSurah = 1
        reading.startAyah = 52
        
        reading.endSurah = 2
        reading.endAyah = 8
        
        let firstSurahAyahs = Quran.instance.surahs[1].ayahCount - 52
        
        XCTAssertEqual(reading.ayahCount, firstSurahAyahs + 8)
    }
    
}
