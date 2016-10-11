//
//  BAPrayerCell.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prayer.h"

typedef enum {
	BAPrayerCellTypeSeven,
	BAPrayerCellTypeFive
} BAPrayerCellType;

typedef enum {
	BAPrayerCellGenderMale,
	BAPrayerCellGenderFemale
} BAPrayerCellGender;

@class BAPrayerCellView;

@interface BAPrayerCell : UITableViewCell {
	BAPrayerCellView *cellView;
}

@property (nonatomic, retain) BAPrayerCellView *cellView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(BAPrayerCellType)type gender:(BAPrayerCellGender)gender;
- (void)setDay:(NSString *)day;
- (void)setDate:(NSString *)date;
- (void)setIsToday:(BOOL)isToday;
- (void)setPrayerMethod:(PrayerMethod)method forType:(PrayerType)type;

@end
