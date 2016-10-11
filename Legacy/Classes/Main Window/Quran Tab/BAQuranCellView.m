//
//  BAQuranCellView.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAQuranCellView.h"


@implementation BAQuranCellView

@synthesize highlighted, 
			cellBackgroundLeft,
			cellBackgroundLeftToday,
			cellBackgroundLeftSelected,
			cellBackgroundRight,
			cellBackgroundRightSelected,
			quranAction,
			quranIcon,
			quranIconNone,
			day, 
			date,
			surah,
			ayah,
			read,
			exceptionalReading,
			isToday;

- (id)initWithFrame:(CGRect)frame 
{	
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
		self.cellBackgroundLeft = [UIImage imageNamed:@"tablerow-left.png"];
		self.cellBackgroundLeftToday = [UIImage imageNamed:@"tablerow-left-today.png"];
		self.cellBackgroundLeftSelected = [UIImage imageNamed:@"tablerow-left-selected.png"];
		self.cellBackgroundRight = [UIImage imageNamed:@"quran-tablerow-right.png"];
		self.cellBackgroundRightSelected = [UIImage imageNamed:@"tablerow-right-selected.png"];
		self.quranAction = [UIImage imageNamed:@"quran-open.png"];
		self.quranIcon = [UIImage imageNamed:@"quran-aya.png"];
		self.quranIconNone = [UIImage imageNamed:@"prayer-button-notset.png"];
	}
	return self;
}


- (void)drawRect:(CGRect)rect 
{	
	if(self.highlighted) {
		[cellBackgroundLeftSelected drawInRect:CGRectMake(0, 0, 40, 44)];
		[cellBackgroundRightSelected drawInRect:CGRectMake(40, 0, 280, 44)];
	} else if([self.isToday boolValue]) {
		[cellBackgroundLeftToday drawInRect:CGRectMake(0, 0, 40, 44)];
		[cellBackgroundRight drawInRect:CGRectMake(40, 0, 280, 44)];
	} else {
		[cellBackgroundLeft drawInRect:CGRectMake(0, 0, 40, 44)];
		[cellBackgroundRight drawInRect:CGRectMake(40, 0, 280, 44)];
	}
	
	if(self.highlighted || [self.isToday boolValue]) {
		[[UIColor whiteColor] set];	
	} 
	
	if(!self.highlighted && ![self.isToday boolValue]) [[UIColor colorWithRed:212.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0] set];
	if([day length] <= 3) {
		[day	drawInRect:CGRectMake(0, 6, 39, 14) 
			   withFont:[UIFont boldSystemFontOfSize:13] 
		  lineBreakMode:UILineBreakModeClip 
			  alignment:UITextAlignmentCenter
		 ];
	} else {
		[day	drawInRect:CGRectMake(0, 6, 39, 14) 
			   withFont:[UIFont boldSystemFontOfSize:11] 
		  lineBreakMode:UILineBreakModeClip 
			  alignment:UITextAlignmentCenter
		 ];		
	}
	
	if(!self.highlighted && ![self.isToday boolValue]) [[UIColor colorWithRed:255.0/255.0 green:88.0/255.0 blue:88.0/255.0 alpha:1.0] set];
	[date	drawInRect:CGRectMake(0, 20, 39, 20) 
			withFont:[UIFont boldSystemFontOfSize:14] 
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentCenter
	 ];
	
	if(ayah != nil) {
		[quranIcon drawInRect:CGRectMake(40, 0, 44, 44)];
		[[UIColor blackColor] set];	

		[surah	drawInRect:CGRectMake(80, 13, 160, 40) 
				withFont:[UIFont boldSystemFontOfSize:14] 
		   lineBreakMode:UILineBreakModeClip 
			   alignment:UITextAlignmentLeft
		 ];
		
		[ayah	drawInRect:CGRectMake(42, 15, 40, 40) 
				 withFont:[UIFont boldSystemFontOfSize:11]
			lineBreakMode:UILineBreakModeClip 
				alignment:UITextAlignmentCenter
		 ];
		
		[[UIColor darkGrayColor] set];
		[read	drawInRect:CGRectMake(160, 15, 70, 40)
				withFont:[UIFont boldSystemFontOfSize:12]
		   lineBreakMode:UILineBreakModeClip 
			   alignment:UITextAlignmentRight
		 ];
		
		[quranAction drawInRect:CGRectMake(260, 0, 44, 44)];
		
	} else if(exceptionalReading != nil) {	
		[[UIColor blackColor] set];	
		
		CGRect exceptionalRect;
		CGSize exceptionalSize = [exceptionalReading sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, 300)];
		
		if(exceptionalSize.height > 20) {
			exceptionalRect = CGRectMake(50, 4, 260, 40);
		} else {
			exceptionalRect = CGRectMake(50, 14, 260, 20);			
		}
		
		[exceptionalReading	drawInRect:exceptionalRect
				 withFont:[UIFont systemFontOfSize:14] 
			lineBreakMode:UILineBreakModeTailTruncation
				alignment:UITextAlignmentLeft
		 ];
	} else {		
		[quranIconNone drawInRect:CGRectMake(40, 0, 40, 44)];
	}

	
}

- (void)dealloc 
{
	[self.cellBackgroundLeft release];
	[self.cellBackgroundLeftToday release];
	[self.cellBackgroundLeftSelected release];
	[self.cellBackgroundRight release];
	[self.cellBackgroundRightSelected release];
	[self.quranAction release];
	[self.quranIcon release];
	[self.quranIconNone release];
	
	[self.surah release];
	[self.ayah release];
	[self.read release];
	[self.exceptionalReading release];
	
	[self.day release];
	[self.date release];
	[self.isToday release];
    [super dealloc];
}

@end
