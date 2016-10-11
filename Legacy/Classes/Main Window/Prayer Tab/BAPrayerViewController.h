//
//  BAPrayerViewController.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/2/10.
//  Copyright Batoul Apps 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BADateTableViewController.h"
#import "Prayer.h"

@class BAProgressGraphViewController;

@interface BAPrayerViewController : BADateTableViewController
{
	IBOutlet UILabel *viewTitle;
	IBOutlet UIImageView *prayerModalArrow;
	IBOutlet UILabel *fajrColumnLabel;
	IBOutlet UILabel *shuruqColumnLabel;
	IBOutlet UILabel *dhuhrColumnLabel;
	IBOutlet UILabel *asrColumnLabel;
	IBOutlet UILabel *maghribColumnLabel;
	IBOutlet UILabel *ishaColumnLabel;
	IBOutlet UILabel *qiyamColumnLabel;
	IBOutlet UIButton *prayerButtonNone;
	IBOutlet UIButton *prayerButtonAlone;
	IBOutlet UIButton *prayerButtonAloneWithVoluntary;
	IBOutlet UIButton *prayerButtonGroup;
	IBOutlet UIButton *prayerButtonGroupWithVoluntary;
	IBOutlet UIButton *prayerButtonLate;
	IBOutlet UIButton *prayerButtonExcused;
	IBOutlet UIButton *cancelButton;
	IBOutlet UIImageView *leftHudBg;
	IBOutlet UIImageView *rightHudBg;
	BOOL isSevenDay;
	BOOL isMale;
	PrayerType selectedPrayerType;
	
	BOOL isShowingLandscapeView;
	BAProgressGraphViewController *graphViewController;
}

- (IBAction)setPrayerMethod:(id)sender;
- (void)setupFixedTableHeader;
- (void)setupPrayerModalView;
- (void)updateLandscapeView;

@property (nonatomic,retain) BAProgressGraphViewController *graphViewController;
@property (nonatomic,retain) UIImageView *prayerModalArrow;
@property (nonatomic,retain) UILabel *fajrColumnLabel;
@property (nonatomic,retain) UILabel *shuruqColumnLabel;
@property (nonatomic,retain) UILabel *dhuhrColumnLabel;
@property (nonatomic,retain) UILabel *asrColumnLabel;
@property (nonatomic,retain) UILabel *maghribColumnLabel;
@property (nonatomic,retain) UILabel *ishaColumnLabel;
@property (nonatomic,retain) UILabel *qiyamColumnLabel;
@property (nonatomic,retain) UIButton *prayerButtonNone;
@property (nonatomic,retain) UIButton *prayerButtonAlone;
@property (nonatomic,retain) UIButton *prayerButtonAloneWithVoluntary;
@property (nonatomic,retain) UIButton *prayerButtonGroup;
@property (nonatomic,retain) UIButton *prayerButtonGroupWithVoluntary;
@property (nonatomic,retain) UIButton *prayerButtonLate;
@property (nonatomic,retain) UIButton *prayerButtonExcused;
@property (nonatomic) PrayerType selectedPrayerType;

@end
