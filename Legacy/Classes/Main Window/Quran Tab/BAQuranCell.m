//
//  BAQuranCell.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAQuranCell.h"
#import "BAQuranCellView.h"

@interface BAQuranCell (Private)

- (void)redisplay;

@end

@implementation BAQuranCell

@synthesize cellView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		
		CGRect cvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		cellView = [[BAQuranCellView alloc] initWithFrame:cvFrame];
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

- (void)setIsToday:(NSNumber *)isToday {
	cellView.isToday = isToday;
	[self redisplay];
}

- (void)setSurah:(NSString *)surah andAyah:(NSString *)ayah andNumberRead:(NSString *)read {
	cellView.surah = surah;
	cellView.ayah = ayah;
	cellView.read = read;
	[self redisplay];
}

- (void)setExceptionalReading:(NSString *)exceptionalReading
{
	cellView.exceptionalReading = exceptionalReading;
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
