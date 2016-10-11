// 
//  Day.m
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/1/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "Day.h"
#import "BAPointCalculator.h"

@implementation Day 

@dynamic gregorianDate;
@dynamic hijriDate;
@dynamic isModifiedHijriDate;
@dynamic prayers;
@dynamic readings;
@dynamic charities;

- (id)initAndInsertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:context];
	if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context])
	{
		[self willChangeValueForKey:@"fast"];
		fast = [[Fast alloc] initAndInsertIntoManagedObjectContext:context];
		[self didChangeValueForKey:@"fast"];
		
		for (int i = 0; i < 7; i++)
		{
			Prayer *p = [[Prayer alloc] initAndInsertIntoManagedObjectContext:context];
			[p setType:i];
			[p setDay:self];
			[p release];
		}
	}
	
	return self;
}

- (FastingType)fastingType
{
	[self willAccessValueForKey:@"fast"];
	FastingType aFastingType = [fast type];
	[self didAccessValueForKey:@"fast"];
	return aFastingType;
}

- (void)setFastingType:(FastingType)aFastingType
{
	[self willAccessValueForKey:@"fast"];
	[fast setType:aFastingType];
	[self didAccessValueForKey:@"fast"];
}

- (Reading *)dailyReading
{
	Reading *dailyReading = [[Reading dailyReadingForReadings:[self readings]] retain];
	return [dailyReading autorelease];
}

- (NSArray *)exceptionalReadings
{
	NSArray *readings = [[Reading exceptionalReadingsForReadings:[self readings]] retain];
	return [readings autorelease];
}

- (NSArray *)sortedCharities
{
	NSArray *sortCharities = [[Charity sortedCharitiesForCharities:[self charities]] retain];
	return [sortCharities autorelease];
}

+ (NSArray *)daysBetween:(NSDate *)startDate and:(NSDate *)endDate inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSArray *days;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Day" inManagedObjectContext:context]];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gregorianDate >= %@ AND gregorianDate <= %@ ", startDate, endDate];
	[fetchRequest setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gregorianDate" ascending:NO];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
	
	[fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"charity", @"prayers", @"fast", @"readings", nil]];
	
	NSError *error;
	days = [context executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	
	return days;
}

+ (Day *)dayWithPreviousReadingFrom:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
{	
	NSArray *days;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Day" inManagedObjectContext:context]];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gregorianDate < %@ AND (SUBQUERY(readings, $r, $r.isExceptional == NO).@count != 0)", date];
	[fetchRequest setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gregorianDate" ascending:NO];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
	
	[fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"charity", @"prayers", @"fast", @"readings", nil]];
	
	[fetchRequest setFetchLimit:1];
	
	NSError *error;
	days = [context executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	
	if([days count] > 0) {
		return [days objectAtIndex:0];
	}
	
	return nil;
}

+ (Day *)dayWithNextReadingFrom:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
{	
	NSArray *days;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Day" inManagedObjectContext:context]];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gregorianDate > %@ AND (SUBQUERY(readings, $r, $r.isExceptional == NO).@count != 0)", date];
	[fetchRequest setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gregorianDate" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
	
	[fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"charity", @"prayers", @"fast", @"readings", nil]];
	
	[fetchRequest setFetchLimit:1];
	
	NSError *error;
	days = [context executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	
	if([days count] > 0) {
		return [days objectAtIndex:0];
	}
	
	return nil;
}

+ (Day *)dayForDate:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
{
	Day *day;
	
	NSArray *days = [Day daysBetween:date and:date inManagedObjectContext:context];
	
	if ([days count])
	{
		day = [days objectAtIndex:0];
	}
	else
	{
		day = nil;
	}
	
	return day;
}

+ (NSDate *)midnightForDate:(NSDate *)date 
{
	NSCalendar *cal = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:date];
	[comps setHour:00];
	[comps setMinute:00];
	[comps setSecond:00];
	NSDate *midnight = [cal dateFromComponents:comps];
	
	return midnight;
}

+ (void)createDaysBetween:(NSDate *)startDate and:(NSDate *)endDate inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSArray *days = [Day daysBetween:startDate and:endDate inManagedObjectContext:context];
	
	int numOfDays = [endDate timeIntervalSinceDate:startDate] / 86400;
	
	//get months
	for(int i = 0; i < numOfDays; i++)
	{
		NSDate *newDate = [Day midnightForDate:[startDate dateByAddingTimeInterval:i*86400]];
		
		//if day doesn't exist, create it
		BOOL dayExists = NO;
		for(Day *dayCheck in days)
		{
			if([dayCheck.gregorianDate isEqualToDate:newDate])
			{
				dayExists = YES;
			}
		}
		
		if(!dayExists)
		{
			Day *newDay = [[Day alloc] initAndInsertIntoManagedObjectContext:context];
			newDay.gregorianDate = newDate;
			newDay.hijriDate = newDate;
			[newDay release];
		}
	}
}

- (NSInteger)fastingPoints
{
	return [BAPointCalculator pointsForFastingType:self.fastingType];
}

- (NSInteger)charityPoints
{
	NSInteger points = 0;
	for (Charity *charity in self.charities) {
		points += [BAPointCalculator pointsForCharityType:charity.type];
	}
	
	return points;
}

- (NSInteger)prayerPoints
{
	NSInteger points = 0;
	for (Prayer *prayer in self.prayers) {
		points += [BAPointCalculator pointsForPrayerMethod:prayer.method type:prayer.type];
	}
	
	return points;
}

- (NSInteger)quranPoints
{
	NSInteger points = 0;
	for (Reading *reading in self.readings) {
		points += [BAPointCalculator pointsForAyahs:[Reading ayahDifferenceBetweenAyah:[reading.startAyah intValue] ofSurah:[reading.startSurah intValue] andAyah:[reading.endAyah intValue] ofSurah:[reading.endSurah intValue] withSurahArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Surahs" ofType:@"plist"]]]];
	}
	
	return points;
}

- (NSInteger)totalPoints
{
	return [self fastingPoints] + [self prayerPoints] + [self charityPoints] + [self quranPoints];
}

- (NSInteger)ayasRead
{
	NSInteger ayasRead = 0;
	for (Reading *reading in self.readings) {
		ayasRead += [Reading ayahDifferenceBetweenAyah:[reading.startAyah intValue] ofSurah:[reading.startSurah intValue] andAyah:[reading.endAyah intValue] ofSurah:[reading.endSurah intValue] withSurahArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Surahs" ofType:@"plist"]]];
	}
	
	return ayasRead;
}

- (void)dealloc {
	[super dealloc];
}

@end
