//
//  BALocalizer.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 7/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAQamarDeenAppDelegate.h"

@interface BALocalizer : NSObject {

}

+ (NSString *)localizedNumber:(NSNumber *)number;
+ (NSString *)localizedInteger:(int)intNumber;
+ (NSString *)localizedString:(NSString *)key;
+ (NSString *)localizedDay:(NSDate *)date;
+ (NSString *)localizedWeekday:(NSDate *)date;

@end
