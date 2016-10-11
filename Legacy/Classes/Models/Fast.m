// 
//  Fast.m
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/1/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "Fast.h"

#import "Day.h"

@implementation Fast 

@dynamic day;

- (id)initAndInsertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fast" inManagedObjectContext:context];
	self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
	return self;
}

- (FastingType)type
{
	[self willAccessValueForKey:@"type"];
	NSInteger aType = type;
	[self didAccessValueForKey:@"type"];
	return aType;
}

- (void)setType:(FastingType)aType
{
	[self willChangeValueForKey:@"type"];
	type = aType;
	[self didChangeValueForKey:@"type"];
}

@end
