//
//  BALocalizer.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 7/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BALocalizer.h"

@implementation BALocalizer

+ (NSString *)localizedNumber:(NSNumber *)number
{
	if(	[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"]) {
		return [[QDAppDelegate arabicNumberFormatter] stringFromNumber:number];
	} else {
		return [[QDAppDelegate localNumberFormatter] stringFromNumber:number];		
	}
}

+ (NSString *)localizedInteger:(int)intNumber
{
	return [BALocalizer localizedNumber:[NSNumber numberWithInt:intNumber]];	
}

+ (NSString *)localizedString:(NSString *)key
{
	if(	[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"] && [[QDAppDelegate arabicStrings] objectForKey:key] != nil) {
		return [[QDAppDelegate arabicStrings] objectForKey:key];
	} else {
		return NSLocalizedString(key, @"");
	}
}

+ (NSString *)localizedDay:(NSDate *)date
{
	if(	[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"]) {
		return [[QDAppDelegate arabicDateDateFormatter] stringFromDate:date];
	} else {
		return [[QDAppDelegate dateDateFormatter] stringFromDate:date];
	}
}

+ (NSString *)localizedWeekday:(NSDate *)date
{
	if(	[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"]) {
		return [[QDAppDelegate arabicDayDateFormatter] stringFromDate:date];
	} else {
		return [[QDAppDelegate dayDateFormatter] stringFromDate:date];
	}
}


@end
