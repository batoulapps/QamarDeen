//
//  BAPrayerCellView.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAPrayerCellView.h"

@interface BAPrayerCellView (Private)

- (UIImage *)imageForPrayerIndex:(NSInteger)index;

@end

@implementation BAPrayerCellView

@synthesize highlighted, 
			cellBackgroundLeft,
			cellBackgroundLeftToday,
			cellBackgroundLeftSelected,
			prayerCellBackgroundRight,
			prayerCellBackgroundRightSelected,
			prayerIconNone,
			prayerIconAlone,
			prayerIconAloneWithVoluntary,
			prayerIconGroup,
			prayerIconGroupWithVoluntary,
			prayerIconLate,
			prayerIconExcused,
			day, 
			date, 
			cellType,
			isToday,
			fajrPrayerMethod,
			shuruqPrayerMethod,
			dhuhrPrayerMethod,
			asrPrayerMethod,
			maghribPrayerMethod,
			ishaPrayerMethod,
			qiyamPrayerMethod;

- (id)initWithFrame:(CGRect)frame type:(BAPrayerCellType)aType gender:(BAPrayerCellGender)aGender
{	
	if ((self = [super initWithFrame:frame]))
	{
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
		self.cellType = aType;
		self.cellBackgroundLeft				= [UIImage imageNamed:@"tablerow-left.png"];
		self.cellBackgroundLeftToday		= [UIImage imageNamed:@"tablerow-left-today.png"];
		self.cellBackgroundLeftSelected		= [UIImage imageNamed:@"tablerow-left-selected.png"];
		self.prayerIconNone					= [UIImage imageNamed:@"prayer-button-notset.png"];
		self.prayerIconLate					= [UIImage imageNamed:@"prayer-button-late.png"];
		
		if (aGender == BAPrayerCellGenderMale)
		{
			self.prayerIconAlone				= [UIImage imageNamed:@"prayer-button-alone-m.png"];
			self.prayerIconAloneWithVoluntary	= [UIImage imageNamed:@"prayer-button-aloneWithVoluntary-m.png"];
			self.prayerIconGroup				= [UIImage imageNamed:@"prayer-button-group-m.png"];
			self.prayerIconGroupWithVoluntary	= [UIImage imageNamed:@"prayer-button-groupWithVoluntary-m.png"];
			self.prayerIconExcused				= [UIImage imageNamed:@"prayer-button-notset.png"];
		}
		else
		{
			self.prayerIconAlone				= [UIImage imageNamed:@"prayer-button-alone-f.png"];
			self.prayerIconAloneWithVoluntary	= [UIImage imageNamed:@"prayer-button-aloneWithVoluntary-f.png"];
			self.prayerIconGroup				= [UIImage imageNamed:@"prayer-button-group-f.png"];
			self.prayerIconGroupWithVoluntary	= [UIImage imageNamed:@"prayer-button-groupWithVoluntary-f.png"];
			self.prayerIconExcused				= [UIImage imageNamed:@"prayer-button-excused.png"];
		}
		
		if (self.cellType == BAPrayerCellTypeSeven)
		{
			self.prayerCellBackgroundRight = [UIImage imageNamed:@"prayer7-tablerow-right.png"];
			self.prayerCellBackgroundRightSelected = [UIImage imageNamed:@"prayer7-tablerow-right-selected.png"];
		}
		else
		{
			self.prayerCellBackgroundRight = [UIImage imageNamed:@"prayer5-tablerow-right.png"];
			self.prayerCellBackgroundRightSelected = [UIImage imageNamed:@"prayer5-tablerow-right-selected.png"];
		}
	}
	return self;
}


- (void)drawRect:(CGRect)rect 
{	
	if(self.highlighted)
	{
		[cellBackgroundLeftSelected drawAtPoint:CGPointMake(0, 0)];
		[prayerCellBackgroundRightSelected drawAtPoint:CGPointMake(40, 0)];
	}
	else
	{
		if(self.isToday)
		{
			[cellBackgroundLeftToday drawAtPoint:CGPointMake(0, 0)];
		}
		else
		{
			[cellBackgroundLeft drawAtPoint:CGPointMake(0, 0)];
		}
		[prayerCellBackgroundRight drawAtPoint:CGPointMake(40, 0)];
	}
	
	if (self.highlighted || isToday) [[UIColor whiteColor] set];
	
	if (!self.highlighted && !isToday) [[UIColor colorWithRed:212.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0] set];
	
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
	
	if (!self.highlighted && !isToday) [[UIColor colorWithRed:255.0/255.0 green:88.0/255.0 blue:88.0/255.0 alpha:1.0] set];
	
	[date	drawInRect:CGRectMake(0, 20, 39, 20) 
			withFont:[UIFont boldSystemFontOfSize:14] 
			lineBreakMode:UILineBreakModeClip 
			alignment:UITextAlignmentCenter
	 ];
	
	// draw prayer icons
	if (self.cellType == BAPrayerCellTypeSeven)
	{
		int p = 0;
		for (int i = 40; i <= 280; i+=40)
		{
			[[self imageForPrayerIndex:p++] drawAtPoint:CGPointMake(i, 0)];
		}
	}
	else
	{
		int p = 0;
		for (int i = 40; i <= 280; i+=56)
		{
			if (p == PrayerTypeShuruq) p++;
			[[self imageForPrayerIndex:p++] drawAtPoint:CGPointMake(i+8, 0)];
		}
	}
}

- (UIImage *)imageForPrayerIndex:(NSInteger)index
{
	PrayerMethod method = 0;
	UIImage *image = prayerIconNone;
	
	switch (index) {
		case PrayerTypeFajr:
			method = self.fajrPrayerMethod;
			break;
		case PrayerTypeShuruq:
			method = self.shuruqPrayerMethod;
			break;
		case PrayerTypeDhuhr:
			method = self.dhuhrPrayerMethod;
			break;
		case PrayerTypeAsr:
			method = self.asrPrayerMethod;
			break;
		case PrayerTypeMaghrib:
			method = self.maghribPrayerMethod;
			break;
		case PrayerTypeIsha:
			method = self.ishaPrayerMethod;
			break;
		case PrayerTypeQiyam:
			method = self.qiyamPrayerMethod;
			break;
		default:
			break;
	}
	switch (method) {
		case PrayerMethodNone:
			image = prayerIconNone;
			break;
		case PrayerMethodAlone:
			image = prayerIconAlone;
			break;
		case PrayerMethodAloneWithVoluntary:
			image = prayerIconAloneWithVoluntary;
			break;
		case PrayerMethodGroup:
			image = prayerIconGroup;
			break;
		case PrayerMethodGroupWithVoluntary:
			image = prayerIconGroupWithVoluntary;
			break;
		case PrayerMethodLate:
			image = prayerIconLate;
			break;
		case PrayerMethodExcused:
			image = prayerIconExcused;
			break;
		default:
			break;
	}
	return image;
}

- (void)dealloc 
{
	[self.cellBackgroundLeft release];
	[self.cellBackgroundLeftToday release];
	[self.cellBackgroundLeftSelected release];
	[self.prayerCellBackgroundRight release];
	[self.prayerCellBackgroundRightSelected release];
	[self.prayerIconNone release];
	[self.prayerIconAlone release];
	[self.prayerIconAloneWithVoluntary release];
	[self.prayerIconGroup release];
	[self.prayerIconGroupWithVoluntary release];
	[self.prayerIconLate release];
	[self.prayerIconExcused release];
	
	[self.day release];
	[self.date release];
    [super dealloc];
}

@end
