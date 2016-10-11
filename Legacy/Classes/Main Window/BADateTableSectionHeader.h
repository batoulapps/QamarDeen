//
//  BAPrayerSectionHeader.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/15/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BADateTableSectionHeader : UIView {
	UIImage *backgroundImage;
	NSString *month;
}

@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) NSString *month;

@end
