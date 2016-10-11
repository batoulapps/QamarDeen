//
//  BASurahCellView.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 5/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BASurahCellView : UIView {
	BOOL highlighted;
	BOOL isChecked;
	NSString *surah;
	UIImage *uncheckedIcon;
	UIImage *checkedIcon;
}

@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, retain) NSString *surah;
@property (nonatomic, retain) UIImage *uncheckedIcon;
@property (nonatomic, retain) UIImage *checkedIcon;

@end
