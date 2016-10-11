// 
//  Prayer.m
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/1/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "Prayer.h"

#import "Day.h"

@implementation Prayer 

@dynamic day;

- (id)initAndInsertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Prayer" inManagedObjectContext:context];
	self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
	return self;
}

- (PrayerMethod)method
{
	[self willAccessValueForKey:@"method"];
	NSInteger aMethod = method;
	[self didAccessValueForKey:@"method"];
	return aMethod;
}

- (void)setMethod:(PrayerMethod)aMethod
{
	[self willChangeValueForKey:@"method"];
	method = aMethod;
	[self didChangeValueForKey:@"method"];
}

- (PrayerType)type
{
	[self willAccessValueForKey:@"type"];
	NSInteger aType = type;
	[self didAccessValueForKey:@"type"];
	return aType;
}

- (void)setType:(PrayerType)aType
{
	[self willChangeValueForKey:@"type"];
	type = aType;
	[self didChangeValueForKey:@"type"];
}

@end
