//
//  BAPrayerCell.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAPrayerCell.h"
#import "BAPrayerCellView.h"
#import "Prayer.h"

@interface BAPrayerCell (Private)

- (void)redisplay;

@end

@implementation BAPrayerCell

@synthesize cellView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(BAPrayerCellType)type gender:(BAPrayerCellGender)gender {
	
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		
		CGRect cvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		cellView = [[BAPrayerCellView alloc] initWithFrame:cvFrame type:type gender:gender];
		cellView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:cellView];
	}
	
	return self;
}

- (void)setPrayerMethod:(PrayerMethod)method forType:(PrayerType)type
{
	switch (type) {
		case PrayerTypeFajr:
			cellView.fajrPrayerMethod = method;
			break;
		case PrayerTypeShuruq:
			cellView.shuruqPrayerMethod = method;
			break;
		case PrayerTypeDhuhr:
			cellView.dhuhrPrayerMethod = method;
			break;
		case PrayerTypeAsr:
			cellView.asrPrayerMethod = method;
			break;
		case PrayerTypeMaghrib:
			cellView.maghribPrayerMethod = method;
			break;
		case PrayerTypeIsha:
			cellView.ishaPrayerMethod = method;
			break;
		case PrayerTypeQiyam:
			cellView.qiyamPrayerMethod = method;
			break;
		default:
			break;
	}
}

- (void)setDay:(NSString *)day {
	cellView.day = day;
	[self redisplay];
}

- (void)setDate:(NSString *)date {
	cellView.date = date;
	[self redisplay];
}

- (void)setIsToday:(BOOL)isToday {
	cellView.isToday = isToday;
	[self redisplay];
}

- (void)redisplay {
	[cellView setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
	[cellView setNeedsDisplay];
}

- (void)dealloc {
	[cellView release];
    [super dealloc];
}


@end
