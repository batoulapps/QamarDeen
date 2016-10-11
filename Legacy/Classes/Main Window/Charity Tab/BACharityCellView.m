//
//  BACharityCellView.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BACharityCellView.h"
#import "Charity.h"

@implementation BACharityCellView

@synthesize highlighted, 
			cellBackgroundLeft,
			cellBackgroundLeftToday,
			cellBackgroundLeftSelected,
			cellBackgroundRight,
			cellBackgroundRightSelected,
			day, 
			date,
			isToday,
			offImage,
			iconMoney,
			iconEffort,
			iconFood,
			iconClothes,
			iconSmile,
			iconOther,
			charities;

- (id)initWithFrame:(CGRect)frame 
{	
	if (self = [super initWithFrame:frame])
	{
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
		self.cellBackgroundLeft = [UIImage imageNamed:@"tablerow-left.png"];
		self.cellBackgroundLeftToday = [UIImage imageNamed:@"tablerow-left-today.png"];
		self.cellBackgroundLeftSelected = [UIImage imageNamed:@"tablerow-left-selected.png"];
		self.cellBackgroundRight = [UIImage imageNamed:@"tablerow-right.png"];
		self.cellBackgroundRightSelected = [UIImage imageNamed:@"tablerow-right-selected.png"];
		self.offImage = [UIImage imageNamed:@"prayer-button-notset.png"];
		
		self.iconMoney = [UIImage imageNamed:@"sadaqah-icon-money.png"];
		self.iconEffort = [UIImage imageNamed:@"sadaqah-icon-effort.png"];
		self.iconFood = [UIImage imageNamed:@"sadaqah-icon-food.png"];
		self.iconClothes = [UIImage imageNamed:@"sadaqah-icon-clothes.png"];
		self.iconSmile = [UIImage imageNamed:@"sadaqah-icon-smile.png"];
		self.iconOther = [UIImage imageNamed:@"sadaqah-icon-other.png"];
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
	
	if ([self.charities count] > 0)
	{
		int xpos = 40;
		for(Charity *charity in charities) {
			
			switch (charity.type) {
				case CharityTypeMoney:
					[iconMoney drawAtPoint:CGPointMake(xpos, 0)];
					break;
				case CharityTypeEffort:
					[iconEffort drawAtPoint:CGPointMake(xpos, 0)];
					break;
				case CharityTypeFeeding:
					[iconFood drawAtPoint:CGPointMake(xpos, 0)];
					break;
				case CharityTypeClothes:
					[iconClothes drawAtPoint:CGPointMake(xpos, 0)];
					break;
				case CharityTypeSmile:
					[iconSmile drawAtPoint:CGPointMake(xpos, 0)];
					break;
				case CharityTypeOther:
					[iconOther drawAtPoint:CGPointMake(xpos, 0)];
					break;
				default:
					break;
			}
			
			xpos += 40;
		}
	}
	else
	{
		[offImage drawInRect:CGRectMake(40, 0, 40, 44)];
	}
}

- (void)dealloc 
{
	[self.cellBackgroundLeft release];
	[self.cellBackgroundLeftToday release];
	[self.cellBackgroundLeftSelected release];
	[self.cellBackgroundRight release];
	[self.cellBackgroundRightSelected release];
	[self.offImage release];
	
	[self.iconMoney release];
	[self.iconEffort release];
	[self.iconFood release];
	[self.iconClothes release];
	[self.iconSmile release];
	[self.iconOther release];
	
	[self.charities release];
	[self.day release];
	[self.date release];
	[self.isToday release];
    [super dealloc];
}

@end
