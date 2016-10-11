//
//  BASurahCell.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 5/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BASurahCell.h"
#import "BASurahCellView.h"

@interface BASurahCell (Private)

- (void)redisplay;

@end

@implementation BASurahCell

@synthesize cellView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		
		CGRect cvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		cellView = [[BASurahCellView alloc] initWithFrame:cvFrame];
		cellView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:cellView];
	}
	
	return self;
}

- (void)setIsChecked:(BOOL)isChecked {
	cellView.isChecked = isChecked;
	[self redisplay];
}

- (void)setSurah:(NSString *)surah {
	cellView.surah = surah;
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
