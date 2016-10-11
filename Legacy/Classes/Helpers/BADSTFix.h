//
//  BADSTFix.h
//  QamarDeen
//
//  Created by Matthew Crenshaw on 11/2/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BADSTFix : NSObject {

}

+ (void)fixDSTDuplicatesInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)fixGMTDuplicatesInManagedObjectContext:(NSManagedObjectContext *)context;

@end
