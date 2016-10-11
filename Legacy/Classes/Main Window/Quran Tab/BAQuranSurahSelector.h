//
//  BAQuranSurahSelector.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 5/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SurahSelectorDelegate <NSObject>
@optional
- (void)refreshTable;
- (NSArray *)currentExceptionalReadings;
- (void)saveExceptionalReadings:(NSArray *)readings;
@end

@interface BAQuranSurahSelector : UIViewController {
	id delegate;
	NSArray *surahs;
	NSArray *juz;
	NSMutableArray *checkedSurahs;
	NSNumberFormatter *numberFormatter;
	IBOutlet UIButton *cancelButton;
	IBOutlet UIButton *doneButton;
	IBOutlet UILabel *viewTitle;
}

- (IBAction)selectorDone:(id)sender;
- (IBAction)selectorCancel:(id)sender;
- (int)surahIndexForIndexPath:(NSIndexPath *)indexPath;
- (void)requiresRefresh;

@property (nonatomic, assign) id <SurahSelectorDelegate> delegate;

@end
