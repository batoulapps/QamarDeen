//
//  Charity.h
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/1/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef enum {
	CharityTypeMoney,
	CharityTypeEffort,
	CharityTypeFeeding,
	CharityTypeClothes,
	CharityTypeSmile,
	CharityTypeOther
} CharityType;

@class Day;

@interface Charity :  NSManagedObject  
{
	CharityType	type;
}

- (id)initAndInsertIntoManagedObjectContext:(NSManagedObjectContext *)context;
- (void)deleteCharity;
+ (NSArray *)sortedCharitiesForCharities:(NSSet *)charities;

@property CharityType type;
@property (nonatomic, retain) Day * day;

@end



