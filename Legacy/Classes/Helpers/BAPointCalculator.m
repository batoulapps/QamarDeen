//
//  BAPointCalculator.m
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/30/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAPointCalculator.h"


@implementation BAPointCalculator

+ (NSInteger)pointsForFastingType:(FastingType)type
{
	NSInteger points = 0;
	switch (type) {
		case FastingTypeVow:
			points = 250;
			break;
		case FastingTypeForgiveness:
			points = 100;
			break;
		case FastingTypeReconcile:
			points = 400;
			break;
		case FastingTypeVoluntary:
			points = 500;
			break;
		case FastingTypeMandatory:
			points = 500;
			break;
		case FastingTypeNone:
		default:
			points = 0;
			break;
	}
	return points;
}

+ (NSInteger)pointsForCharityType:(CharityType)type
{
	NSInteger points = 0;
	switch (type) {
		case CharityTypeSmile:
			points = 25;
			break;
		default:
			points = 100;
			break;
	}
	return points;
}

+ (NSInteger)pointsForPrayerMethod:(PrayerMethod)method type:(PrayerType)type
{
	NSInteger points = 0;
	switch (method) {
		case PrayerMethodAlone:
			if (type == PrayerTypeShuruq) points = 200;
			else if (type == PrayerTypeQiyam) points = 300;
			else points = 100;
			break;
		case PrayerMethodAloneWithVoluntary:
			points = 200;
			break;
		case PrayerMethodGroup:
			if (type == PrayerTypeQiyam) points = 300;
			else points = 400;
			break;
		case PrayerMethodGroupWithVoluntary:
			points = 500;
			break;
		case PrayerMethodLate:
			points = 25;
			break;
		case PrayerMethodExcused:
			points = 300;
			break;
		case PrayerMethodNone:
		default:
			points = 0;
			break;
	}
	return points;
}

+ (NSInteger)pointsForAyahs:(NSInteger)numberOfAyahs
{
	NSInteger points = 0;
	points = numberOfAyahs * 2;
	return points;
}

@end
