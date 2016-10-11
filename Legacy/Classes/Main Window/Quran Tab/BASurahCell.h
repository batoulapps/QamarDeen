//
//  BASurahCell.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 5/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BASurahCellView;

@interface BASurahCell : UITableViewCell {
	BASurahCellView *cellView;
}

@property (nonatomic, retain) BASurahCellView *cellView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setIsChecked:(BOOL)isChecked;
- (void)setSurah:(NSString *)surah;

@end
