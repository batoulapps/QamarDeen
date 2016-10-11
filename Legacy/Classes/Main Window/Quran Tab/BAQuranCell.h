//
//  BAQuranCell.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/14/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BAQuranCellView;

@interface BAQuranCell : UITableViewCell {
	BAQuranCellView *cellView;
}

@property (nonatomic, retain) BAQuranCellView *cellView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setDay:(NSString *)day;
- (void)setDate:(NSString *)date;
- (void)setIsToday:(NSNumber *)isToday;
- (void)setSurah:(NSString *)surah andAyah:(NSString *)ayah andNumberRead:(NSString *)read;
- (void)setExceptionalReading:(NSString *)exceptionalReading;

@end
