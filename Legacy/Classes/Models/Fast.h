//
//  Fast.h
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/1/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef enum {
	FastingTypeNone,
	FastingTypeMandatory,
	FastingTypeVoluntary,
	FastingTypeReconcile,
	FastingTypeForgiveness,
	FastingTypeVow
} FastingType;

@class Day;

@interface Fast :  NSManagedObject  
{
	FastingType type;
}

- (id)initAndInsertIntoManagedObjectContext:(NSManagedObjectContext *)context;

@property FastingType type;
@property (nonatomic, retain) Day * day;

@end



