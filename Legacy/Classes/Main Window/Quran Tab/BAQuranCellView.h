//
//  BAQuranCellView.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BAQuranCellView : UIView {
	BOOL highlighted;
	UIImage *cellBackgroundLeft;
	UIImage *cellBackgroundLeftToday;
	UIImage *cellBackgroundLeftSelected;
	UIImage *cellBackgroundRight;
	UIImage *cellBackgroundRightSelected;
	UIImage *quranAction;
	UIImage *quranIcon;
	UIImage *quranIconNone;
	NSString *day;
	NSString *date;
	NSString *surah;
	NSString *ayah;
	NSString *read;
	NSString *exceptionalReading;
	
	NSNumber *isToday;
}

@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, retain) UIImage *cellBackgroundLeft;
@property (nonatomic, retain) UIImage *cellBackgroundLeftToday;
@property (nonatomic, retain) UIImage *cellBackgroundLeftSelected;
@property (nonatomic, retain) UIImage *cellBackgroundRight;
@property (nonatomic, retain) UIImage *cellBackgroundRightSelected;
@property (nonatomic, retain) UIImage *quranAction;
@property (nonatomic, retain) UIImage *quranIcon;
@property (nonatomic, retain) UIImage *quranIconNone;
@property (nonatomic, retain) NSString *day;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *surah;
@property (nonatomic, retain) NSString *ayah;
@property (nonatomic, retain) NSString *read;
@property (nonatomic, retain) NSString *exceptionalReading;
@property (nonatomic, retain) NSNumber *isToday;

@end
