//
//  BAPrayerCellView.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAPrayerCell.h"
#import "Prayer.h"

@interface BAPrayerCellView : UIView {
	BOOL highlighted;
	UIImage *cellBackgroundLeft;
	UIImage *cellBackgroundLeftToday;
	UIImage *cellBackgroundLeftSelected;
	UIImage *prayerCellBackgroundRight;
	UIImage *prayerCellBackgroundRightSelected;
	UIImage *prayerIconNone;
	UIImage *prayerIconAlone;
	UIImage *prayerIconAloneWithVoluntary;
	UIImage *prayerIconGroup;
	UIImage *prayerIconGroupWithVoluntary;
	UIImage *prayerIconLate;
	UIImage *prayerIconExcused;
	NSString *day;
	NSString *date;
	BAPrayerCellType cellType;
	BOOL isToday;
	PrayerMethod fajrPrayerMethod;
	PrayerMethod shuruqPrayerMethod;
	PrayerMethod dhuhrPrayerMethod;
	PrayerMethod asrPrayerMethod;
	PrayerMethod maghribPrayerMethod;
	PrayerMethod ishaPrayerMethod;
	PrayerMethod qiyamPrayerMethod;
}

- (id)initWithFrame:(CGRect)frame type:(BAPrayerCellType)aType gender:(BAPrayerCellGender)aGender;

@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, retain) UIImage *cellBackgroundLeft;
@property (nonatomic, retain) UIImage *cellBackgroundLeftToday;
@property (nonatomic, retain) UIImage *cellBackgroundLeftSelected;
@property (nonatomic, retain) UIImage *prayerCellBackgroundRight;
@property (nonatomic, retain) UIImage *prayerCellBackgroundRightSelected;
@property (nonatomic, retain) UIImage *prayerIconNone;
@property (nonatomic, retain) UIImage *prayerIconAlone;
@property (nonatomic, retain) UIImage *prayerIconAloneWithVoluntary;
@property (nonatomic, retain) UIImage *prayerIconGroup;
@property (nonatomic, retain) UIImage *prayerIconGroupWithVoluntary;
@property (nonatomic, retain) UIImage *prayerIconLate;
@property (nonatomic, retain) UIImage *prayerIconExcused;
@property (nonatomic, retain) NSString *day;
@property (nonatomic, retain) NSString *date;
@property (nonatomic) BAPrayerCellType cellType;
@property (nonatomic) BOOL isToday;
@property (nonatomic) PrayerMethod fajrPrayerMethod;
@property (nonatomic) PrayerMethod shuruqPrayerMethod;
@property (nonatomic) PrayerMethod dhuhrPrayerMethod;
@property (nonatomic) PrayerMethod asrPrayerMethod;
@property (nonatomic) PrayerMethod maghribPrayerMethod;
@property (nonatomic) PrayerMethod ishaPrayerMethod;
@property (nonatomic) PrayerMethod qiyamPrayerMethod;

@end
