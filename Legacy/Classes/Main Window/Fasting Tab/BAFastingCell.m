//
//  BAFastingCell.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAFastingCell.h"
#import "BAFastingCellView.h"

@interface BAFastingCell (Private)

- (void)redisplay;

@end

@implementation BAFastingCell

@synthesize cellView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		
		CGRect cvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		cellView = [[BAFastingCellView alloc] initWithFrame:cvFrame];
		cellView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:cellView];
	}
	
	return self;
}

- (void)setDay:(NSString *)day {
	cellView.day = day;
	[self redisplay];
}

- (void)setDate:(NSString *)date {
	cellView.date = date;
	[self redisplay];
}

- (void)setHijriMonth:(NSString *)hijriMonth andHijriDate:(NSString *)hijriDate {
	cellView.hijriDate = hijriDate;
	cellView.hijriMonth = hijriMonth;
	[self redisplay];
}

- (void)setIsToday:(NSNumber *)isToday {
	cellView.isToday = isToday;
	[self redisplay];
}

- (void)setFastingType:(int)fastingType {
	cellView.fastingType = fastingType;
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
