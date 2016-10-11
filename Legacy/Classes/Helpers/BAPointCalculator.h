//
//  BAPointCalculator.h
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/30/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fast.h"
#import "Charity.h"
#import	"Prayer.h"


@interface BAPointCalculator : NSObject {

}

+ (NSInteger)pointsForFastingType:(FastingType)type;
+ (NSInteger)pointsForPrayerMethod:(PrayerMethod)method type:(PrayerType)type;
+ (NSInteger)pointsForAyahs:(NSInteger)numberOfAyahs;
+ (NSInteger)pointsForCharityType:(CharityType)type;

@end
