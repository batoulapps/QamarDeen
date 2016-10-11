//
//  BASettingsViewController.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 4/30/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCSwitchOnOff.h"

@interface BASettingsViewController : UIViewController
{
	IBOutlet UILabel *viewTitle;
	IBOutlet RCSwitchOnOff *genderButton;
	IBOutlet UILabel *genderLabel;
	IBOutlet UISwitch *arabicButton;
	IBOutlet UILabel *arabicLabel;
	IBOutlet UISwitch *sevenDayButton;
	IBOutlet UILabel *extraPrayersLabel;
	IBOutlet UIButton *aboutButton;
	IBOutlet UIButton *moreBatoulAppsButton;
	IBOutlet UIButton *quranAppButton;
	IBOutlet UILabel *quranAppValue;
	IBOutlet UILabel *protectionLabel;
	IBOutlet UISwitch *protectionToggle;
	IBOutlet UIButton *passcodeCancel;
	IBOutlet UIView *passcodeView;
	IBOutlet UITextField *passcodeField;
	IBOutlet UITextField *repasscodeField;
	IBOutlet UIImageView *passNum1;
	IBOutlet UIImageView *passNum2;
	IBOutlet UIImageView *passNum3;
	IBOutlet UIImageView *passNum4;
	IBOutlet UIImageView *repassNum1;
	IBOutlet UIImageView *repassNum2;
	IBOutlet UIImageView *repassNum3;
	IBOutlet UIImageView *repassNum4;
	IBOutlet UIView *passcodeGroup1;
	IBOutlet UIView *passcodeGroup2;
	IBOutlet UILabel *passcode1Title;
	IBOutlet UILabel *passcode2Title;
}

- (void)localizeUI;
- (IBAction)genderButtonToggle:(id)sender;
- (IBAction)arabicModeToggle:(id)sender;
- (IBAction)sevenDayButtonToggle:(id)sender;
- (IBAction)aboutButtonAction:(id)sender;
- (IBAction)moreBatoulApps:(id)sender;
- (IBAction)quranAppAction:(id)sender;
- (IBAction)protectionAction:(id)sender;
- (IBAction)protectionActionCancel:(id)sender;
- (IBAction)passcodeUpdate:(id)sender;
- (IBAction)repasscodeUpdate:(id)sender;
- (void)resetPasscodeFields;

@property (nonatomic,retain) RCSwitchOnOff *genderButton;
@property (nonatomic,retain) UISwitch *sevenDayButton;

@end
