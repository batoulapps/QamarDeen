//
//  BAFastingCellView.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAFastingCellView.h"


@implementation BAFastingCellView

@synthesize highlighted, 
			cellBackgroundLeft,
			cellBackgroundLeftToday,
			cellBackgroundLeftSelected,
			cellBackgroundRight,
			cellBackgroundRightSelected,
			fastingTypeMandatory,
			fastingTypeVoluntary,
			fastingTypeReconcile,
			fastingTypeForgiveness,
			fastingTypeVow,
			fastingTypeSelected,
			day, 
			date,
			hijriDate,
			hijriMonth,
			fastingType,
			typeName,
			isToday;

- (id)initWithFrame:(CGRect)frame 
{	
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
		self.cellBackgroundLeft = [UIImage imageNamed:@"tablerow-left.png"];
		self.cellBackgroundLeftToday = [UIImage imageNamed:@"tablerow-left-today.png"];
		self.cellBackgroundLeftSelected = [UIImage imageNamed:@"tablerow-left-selected.png"];
		self.cellBackgroundRight = [UIImage imageNamed:@"tablerow-right.png"];
		self.cellBackgroundRightSelected = [UIImage imageNamed:@"tablerow-right-selected.png"];
		
		self.fastingTypeMandatory = [[UIImage imageNamed:@"fasting-row-fareedah.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
		self.fastingTypeVoluntary = [[UIImage imageNamed:@"fasting-row-tatawou.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
		self.fastingTypeReconcile = [[UIImage imageNamed:@"fasting-row-qadaa.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
		self.fastingTypeForgiveness = [[UIImage imageNamed:@"fasting-row-kaffarah.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
		self.fastingTypeVow = [[UIImage imageNamed:@"fasting-row-nazr.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
		
		self.fastingTypeSelected = [[UIImage imageNamed:@"fasting-row-selected.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
		
		self.typeName = @"";
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
	

	if(self.highlighted) {
		[fastingTypeSelected drawInRect:CGRectMake(47, 8, 265, 27)];
		[[UIColor whiteColor] set];
	} else {
		switch (fastingType) {
			case FastingTypeMandatory:
				[fastingTypeMandatory drawInRect:CGRectMake(47, 8, 265, 27)];
				[[UIColor colorWithRed:60.0/255.0 green:136.0/255.0 blue:42.0/255.0 alpha:1.0] set];
				typeName = [BALocalizer localizedString:@"FastingTypeMandatory"];
				break;
			case FastingTypeVoluntary:
				[fastingTypeVoluntary drawInRect:CGRectMake(47, 8, 265, 27)];
				[[UIColor colorWithRed:39.0/255.0 green:107.0/255.0 blue:187.0/255.0 alpha:1.0] set];
				typeName = [BALocalizer localizedString:@"FastingTypeVoluntary"];
				break;
			case FastingTypeReconcile:
				[fastingTypeReconcile drawInRect:CGRectMake(47, 8, 265, 27)];
				[[UIColor colorWithRed:189.0/255.0 green:58.0/255.0 blue:66.0/255.0 alpha:1.0] set];
				typeName = [BALocalizer localizedString:@"FastingTypeReconcile"];
				break;
			case FastingTypeForgiveness:
				[fastingTypeForgiveness drawInRect:CGRectMake(47, 8, 265, 27)];
				[[UIColor colorWithRed:184.0/255.0 green:116.0/255.0 blue:18.0/255.0 alpha:1.0] set];
				typeName = [BALocalizer localizedString:@"FastingTypeForgiveness"];
				break;
			case FastingTypeVow:
				[fastingTypeVow drawInRect:CGRectMake(47, 8, 265, 27)];
				[[UIColor colorWithRed:131.0/255.0 green:72.0/255.0 blue:163.0/255.0 alpha:1.0] set];
				typeName = [BALocalizer localizedString:@"FastingTypeVow"];
				break;
			case FastingTypeNone:
			default:
				[[UIColor blackColor] set];
				typeName = @"";
				break;
		}
	}
	
	
	[hijriMonth	drawInRect:CGRectMake(60, 12, 160, 20)
			withFont:[UIFont boldSystemFontOfSize:14] 
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
	 ];
	
	[hijriDate	drawInRect:CGRectMake(60, 12, 120, 20)
				 withFont:[UIFont boldSystemFontOfSize:14] 
			lineBreakMode:UILineBreakModeClip 
				alignment:UITextAlignmentRight
	 ];
	
	[typeName	drawInRect:CGRectMake(160, 12, 135, 20)
				 withFont:[UIFont boldSystemFontOfSize:14] 
			lineBreakMode:UILineBreakModeClip 
				alignment:UITextAlignmentRight
	 ];
	
}

- (void)dealloc 
{
	[self.cellBackgroundLeft release];
	[self.cellBackgroundLeftToday release];
	[self.cellBackgroundLeftSelected release];
	[self.cellBackgroundRight release];
	[self.cellBackgroundRightSelected release];
	
	[self.fastingTypeMandatory release];
	[self.fastingTypeVoluntary release];
	[self.fastingTypeReconcile release];
	[self.fastingTypeForgiveness release];
	[self.fastingTypeVow release];
	[self.fastingTypeSelected release];
	
	[self.typeName release];
	
	[self.day release];
	[self.date release];
	[self.hijriDate release];
	[self.hijriMonth release];
	[self.isToday release];
    [super dealloc];
}

@end
