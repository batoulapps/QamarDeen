//
//  Reading.h
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/1/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Day;

@interface Reading :  NSManagedObject  
{
}

- (id)initAndInsertIntoManagedObjectContext:(NSManagedObjectContext *)context;
- (void)deleteReading;

+ (Reading *)previousReadingFromDate:(NSDate *)date WithManagedObjectContext:(NSManagedObjectContext *)context;
+ (Reading *)nextReadingFromDate:(NSDate *)date WithManagedObjectContext:(NSManagedObjectContext *)context;
+ (Reading *)dailyReadingForReadings:(NSSet *)readings;
+ (NSArray *)exceptionalReadingsForReadings:(NSSet *)readings;
+ (int)ayahDifferenceBetweenAyah:(int)sAyah ofSurah:(int)sSurah andAyah:(int)eAyah ofSurah:(int)eSurah withSurahArray:(NSArray *)surahs;

@property (nonatomic, retain) NSNumber * endSurah;
@property (nonatomic, retain) NSNumber * startSurah;
@property (nonatomic, retain) NSNumber * startAyah;
@property (nonatomic, retain) NSNumber * endAyah;
@property (nonatomic, retain) NSNumber * isExceptional;
@property (nonatomic, retain) Day * day;

@end



