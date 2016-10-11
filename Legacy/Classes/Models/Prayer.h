//
//  Prayer.h
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/1/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef enum {
	PrayerMethodNone,
	PrayerMethodAlone,
	PrayerMethodAloneWithVoluntary,
	PrayerMethodGroup,
	PrayerMethodGroupWithVoluntary,
	PrayerMethodLate,
	PrayerMethodExcused
} PrayerMethod;

typedef enum {
	PrayerTypeFajr,
	PrayerTypeShuruq,
	PrayerTypeDhuhr,
	PrayerTypeAsr,
	PrayerTypeMaghrib,
	PrayerTypeIsha,
	PrayerTypeQiyam
} PrayerType;

@class Day;

@interface Prayer :  NSManagedObject  
{
	PrayerMethod method;
	PrayerType type;
}

- (id)initAndInsertIntoManagedObjectContext:(NSManagedObjectContext *)context;

@property PrayerMethod method;
@property PrayerType type;
@property (nonatomic, retain) Day * day;

@end



