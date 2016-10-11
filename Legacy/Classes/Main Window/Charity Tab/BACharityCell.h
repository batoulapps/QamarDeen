//
//  BACharityCell.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BACharityCellView;

@interface BACharityCell : UITableViewCell 
{
	IBOutlet UILabel *viewTitle;
	BACharityCellView *cellView;
}

@property (nonatomic, retain) BACharityCellView *cellView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setDay:(NSString *)day;
- (void)setDate:(NSString *)date;
- (void)setIsToday:(NSNumber *)isToday;
- (void)setCharities:(NSArray *)charities;

@end
