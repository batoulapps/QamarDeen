//
//  BAPrayerSectionHeader.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/15/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BADateTableSectionHeader.h"


@implementation BADateTableSectionHeader

@synthesize backgroundImage, month;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
		self.backgroundImage = [UIImage imageNamed:@"month-header.png"];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
	[self.backgroundImage drawInRect:rect];
	[[UIColor whiteColor] set];
	[self.month	drawInRect:CGRectMake(0, 4, 40, 20) 
			 withFont:[UIFont boldSystemFontOfSize:15] 
		lineBreakMode:UILineBreakModeClip 
			alignment:UITextAlignmentCenter
	 ];
}


- (void)dealloc
{
	[backgroundImage release];
	[month release];
    [super dealloc];
}


@end
