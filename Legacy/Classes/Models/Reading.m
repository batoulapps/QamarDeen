// 
//  Reading.m
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/1/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "Reading.h"

#import "Day.h"

@implementation Reading 

@dynamic endSurah;
@dynamic startSurah;
@dynamic startAyah;
@dynamic endAyah;
@dynamic isExceptional;
@dynamic day;

- (id)initAndInsertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reading" inManagedObjectContext:context];
	self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
	return self;
}

- (void)deleteReading
{
	[[self managedObjectContext] deleteObject:self];
}

+ (Reading *)previousReadingFromDate:(NSDate *)date WithManagedObjectContext:(NSManagedObjectContext *)context
{
	Reading *previousReading = nil;
	Day *previousDay = [Day dayWithPreviousReadingFrom:date inManagedObjectContext:context];
	if(previousDay != nil) {
		previousReading = [[previousDay dailyReading] retain];
	}

	return [previousReading autorelease];
}

+ (Reading *)nextReadingFromDate:(NSDate *)date WithManagedObjectContext:(NSManagedObjectContext *)context
{
	Reading *nextReading = nil;
	Day *nextDay = [Day dayWithNextReadingFrom:date inManagedObjectContext:context];
	if(nextDay != nil) {
		nextReading = [[nextDay dailyReading] retain];
	}

	return [nextReading autorelease];
}

+ (Reading *)dailyReadingForReadings:(NSSet *)readings
{
	Reading *dailyReading = nil;
	for (Reading *reading in readings) {
		if([reading.isExceptional boolValue] == NO) {
			dailyReading = [reading retain];
			break;
		}
	}
	
	return [dailyReading autorelease];
}

+ (NSArray *)exceptionalReadingsForReadings:(NSSet *)readings
{
	NSArray *exceptionalReadings;
	NSSortDescriptor *sortBySurah = [[NSSortDescriptor alloc] initWithKey:@"endSurah" ascending:YES];
	NSSortDescriptor *sortByAyah = [[NSSortDescriptor alloc] initWithKey:@"endAyah" ascending:YES];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isExceptional == 1"];
	exceptionalReadings = [[[readings allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortBySurah, sortByAyah, nil]] filteredArrayUsingPredicate:predicate];
	[sortBySurah release];
	[sortByAyah release];
	return exceptionalReadings;
}

+ (int)ayahDifferenceBetweenAyah:(int)sAyah ofSurah:(int)sSurah andAyah:(int)eAyah ofSurah:(int)eSurah withSurahArray:(NSArray *)surahs 
{
	int ayahDifference = eSurah >= sSurah ? eAyah - sAyah : 0;
	int surahCount;
	
	for(surahCount = sSurah; surahCount < eSurah; surahCount++) {
		ayahDifference += [[[surahs objectAtIndex:surahCount-1] objectForKey:@"Ayahs"] intValue];
	}
		
	return ayahDifference;
}

@end
