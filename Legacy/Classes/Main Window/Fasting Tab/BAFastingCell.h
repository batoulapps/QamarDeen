//
//  BAFastingCell.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BAFastingCellView;

@interface BAFastingCell : UITableViewCell {
	BAFastingCellView *cellView;
}

@property (nonatomic, retain) BAFastingCellView *cellView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setDay:(NSString *)day;
- (void)setDate:(NSString *)date;
- (void)setHijriMonth:(NSString *)hijriMonth andHijriDate:(NSString *)hijriDate;
- (void)setIsToday:(NSNumber *)isToday;
- (void)setFastingType:(int)fastingType;

@end
