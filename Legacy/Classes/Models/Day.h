//
//  Day.h
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/1/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Fast.h"
#import "Charity.h"
#import "Prayer.h"
#import "Reading.h"

@interface Day :  NSManagedObject  
{
	Fast *fast;
}

@property (nonatomic, retain) NSDate *hijriDate;
@property (nonatomic, retain) NSDate *gregorianDate;
@property (nonatomic, retain) NSNumber *isModifiedHijriDate;
@property (nonatomic, retain) NSSet *prayers;
@property FastingType fastingType;
@property (nonatomic, retain) NSSet *readings;
@property (nonatomic, retain) NSSet *charities;

- (id)initAndInsertIntoManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)daysBetween:(NSDate *)startDate and:(NSDate *)endDate inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)createDaysBetween:(NSDate *)startDate and:(NSDate *)endDate inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Day *)dayForDate:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;
- (Reading *)dailyReading;
- (NSArray *)exceptionalReadings;
- (NSArray *)sortedCharities;
+ (NSDate *)midnightForDate:(NSDate *)date;
+ (Day *)dayWithPreviousReadingFrom:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Day *)dayWithNextReadingFrom:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;

- (NSInteger)totalPoints;
- (NSInteger)fastingPoints;
- (NSInteger)charityPoints;
- (NSInteger)prayerPoints;
- (NSInteger)quranPoints;
- (NSInteger)ayasRead;

@end


@interface Day (CoreDataGeneratedAccessors)
- (void)addPrayersObject:(NSManagedObject *)value;
- (void)removePrayersObject:(NSManagedObject *)value;
- (void)addPrayers:(NSSet *)value;
- (void)removePrayers:(NSSet *)value;

- (void)addReadingsObject:(NSManagedObject *)value;
- (void)removeReadingsObject:(NSManagedObject *)value;
- (void)addReadings:(NSSet *)value;
- (void)removeReadings:(NSSet *)value;

@end

