//
//  BAFastingCellView.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fast.h"


@interface BAFastingCellView : UIView {
	FastingType fastingType;
	NSString *typeName;
	BOOL highlighted;
	UIImage *cellBackgroundLeft;
	UIImage *cellBackgroundLeftToday;
	UIImage *cellBackgroundLeftSelected;
	UIImage *cellBackgroundRight;
	UIImage *cellBackgroundRightSelected;
	UIImage *fastingTypeMandatory;
	UIImage *fastingTypeVoluntary;
	UIImage *fastingTypeReconcile;
	UIImage *fastingTypeForgiveness;
	UIImage *fastingTypeVow;
	UIImage *fastingTypeSelected;
	NSString *day;
	NSString *date;
	NSString *hijriDate;
	NSString *hijriMonth;
	NSNumber *isToday;
}

@property (nonatomic) FastingType fastingType;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, retain) UIImage *cellBackgroundLeft;
@property (nonatomic, retain) UIImage *cellBackgroundLeftToday;
@property (nonatomic, retain) UIImage *cellBackgroundLeftSelected;
@property (nonatomic, retain) UIImage *cellBackgroundRight;
@property (nonatomic, retain) UIImage *cellBackgroundRightSelected;
@property (nonatomic, retain) UIImage *fastingTypeMandatory;
@property (nonatomic, retain) UIImage *fastingTypeVoluntary;
@property (nonatomic, retain) UIImage *fastingTypeReconcile;
@property (nonatomic, retain) UIImage *fastingTypeForgiveness;
@property (nonatomic, retain) UIImage *fastingTypeVow;
@property (nonatomic, retain) UIImage *fastingTypeSelected;
@property (nonatomic, retain) NSString *day;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *hijriDate;
@property (nonatomic, retain) NSString *hijriMonth;
@property (nonatomic, retain) NSNumber *isToday;
@property (nonatomic, retain) NSString *typeName;

@end
