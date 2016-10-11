//
//  BACharityCellView.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BACharityCellView : UIView {
	BOOL highlighted;
	UIImage *cellBackgroundLeft;
	UIImage *cellBackgroundLeftToday;
	UIImage *cellBackgroundLeftSelected;
	UIImage *cellBackgroundRight;
	UIImage *cellBackgroundRightSelected;
	NSString *day;
	NSString *date;
	NSNumber *isToday;
	UIImage *offImage;
	
	UIImage *iconMoney;
	UIImage *iconEffort;
	UIImage *iconFood;
	UIImage *iconClothes;
	UIImage *iconSmile;
	UIImage *iconOther;
	NSArray *charities;
}

@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, retain) UIImage *cellBackgroundLeft;
@property (nonatomic, retain) UIImage *cellBackgroundLeftToday;
@property (nonatomic, retain) UIImage *cellBackgroundLeftSelected;
@property (nonatomic, retain) UIImage *cellBackgroundRight;
@property (nonatomic, retain) UIImage *cellBackgroundRightSelected;
@property (nonatomic, retain) NSString *day;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSNumber *isToday;
@property (nonatomic, retain) UIImage *offImage;
@property (nonatomic, retain) UIImage *iconMoney;
@property (nonatomic, retain) UIImage *iconEffort;
@property (nonatomic, retain) UIImage *iconFood;
@property (nonatomic, retain) UIImage *iconClothes;
@property (nonatomic, retain) UIImage *iconSmile;
@property (nonatomic, retain) UIImage *iconOther;
@property (nonatomic, retain) NSArray *charities;

@end
