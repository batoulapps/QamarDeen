//
//  BADSTFix.m
//  QamarDeen
//
//  Created by Matthew Crenshaw on 11/2/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BADSTFix.h"
#import "Day.h"


@implementation BADSTFix

+ (void)fixDSTDuplicatesInManagedObjectContext:(NSManagedObjectContext *)context
{
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSArray *days = [Day daysBetween:[NSDate distantPast] and:[NSDate distantFuture] inManagedObjectContext:context];

	for (Day *day in days)
	{
		NSDateComponents *comps = [cal components:NSHourCalendarUnit fromDate:[[day gregorianDate] addTimeInterval:-1*[[NSTimeZone localTimeZone] secondsFromGMTForDate:[day gregorianDate]]]];
		if ([comps hour] != 0)
		{
			[context deleteObject:day];
		}
	}
	
	[cal release];
}

+ (void)fixGMTDuplicatesInManagedObjectContext:(NSManagedObjectContext *)context
{
	
	NSArray *days = [Day daysBetween:[NSDate distantPast] and:[NSDate distantFuture] inManagedObjectContext:context];
	
	NSMutableDictionary *properDays = [[NSMutableDictionary alloc] initWithCapacity:[days count]];
	
	for (Day *day in days)
	{
		if([properDays objectForKey:[day.gregorianDate description]] == nil) {
			[properDays setObject:day forKey:[day.gregorianDate description]];
		} else {
			if([[properDays objectForKey:[day.gregorianDate description]] totalPoints] < [day totalPoints]) {
				[properDays removeObjectForKey:[day.gregorianDate description]];
				[properDays setObject:day forKey:[day.gregorianDate description]];
			}
		}
	}
	
	for (Day *day in days)
	{	
		if(![[properDays objectForKey:[day.gregorianDate description]] isEqual:day]) {
			[context deleteObject:day];
		}
			
	}
	
	[properDays release];
}

@end
