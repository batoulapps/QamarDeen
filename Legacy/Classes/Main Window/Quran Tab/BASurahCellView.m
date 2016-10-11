//
//  BASurahCellView.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 5/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BASurahCellView.h"

@implementation BASurahCellView

@synthesize highlighted;
@synthesize surah;
@synthesize isChecked;
@synthesize uncheckedIcon;
@synthesize checkedIcon;

- (id)initWithFrame:(CGRect)frame 
{	
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
		self.uncheckedIcon = [UIImage imageNamed:@"quran-picker-edit.png"];
		self.checkedIcon = [UIImage imageNamed:@"quran-picker-edit-on.png"];
	}
	return self;
}

- (void)setHighlighted:(BOOL)lit {
	// If highlighted state changes, need to redisplay.
	if (highlighted != lit) {
		highlighted = lit;	
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect 
{	
	if(isChecked) {
		[checkedIcon drawInRect:CGRectMake(10, 2, 43, 44)];	
	} else {
		[uncheckedIcon drawInRect:CGRectMake(10, 2, 43, 44)];
	}
	
	if(self.highlighted) [[UIColor whiteColor] set];
	else [[UIColor blackColor] set];
	
	[surah	drawInRect:CGRectMake(60, 14, 300, 20) 
		   withFont:[UIFont boldSystemFontOfSize:16] 
	  lineBreakMode:UILineBreakModeClip 
		  alignment:UITextAlignmentLeft
	 ];
}


- (void)dealloc 
{
	[self.surah release];
	[self.uncheckedIcon release];
	[self.checkedIcon release];
    [super dealloc];
}

@end
