// 
//  Charity.m
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/1/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "Charity.h"

#import "Day.h"

@implementation Charity 

@dynamic day;

- (id)initAndInsertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Charity" inManagedObjectContext:context];
	self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
	return self;
}

- (void)deleteCharity
{
	[[self managedObjectContext] deleteObject:self];
}

+ (NSArray *)sortedCharitiesForCharities:(NSSet *)charities
{
	NSArray *sortedCharities;
	NSSortDescriptor *sortByType = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
	sortedCharities = [[charities allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByType]];
	[sortByType release];
	return sortedCharities;
}

- (CharityType)type
{
	[self willAccessValueForKey:@"type"];
	NSInteger aType = type;
	[self didAccessValueForKey:@"type"];
	return aType;
}

- (void)setType:(CharityType)aType
{
	[self willChangeValueForKey:@"type"];
	type = aType;
	[self didChangeValueForKey:@"type"];
}

@end
