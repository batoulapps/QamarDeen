//
//  BAFastingViewController.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 4/30/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BADateTableViewController.h"

@interface BAFastingViewController : BADateTableViewController 
{
	NSCalendar *hijriCalendar;
	NSDateFormatter *hijriMonthFormatter;
	NSDateFormatter *hijriDateFormatter;
	IBOutlet UILabel *viewTitle;
	IBOutlet UILabel *hijriDateHeader;
	IBOutlet UILabel *fastingTypeHeader;
	IBOutlet UIButton *fastingNoneButton;
	IBOutlet UIButton *fastingMandatoryButton;
	IBOutlet UIButton *fastingVoluntaryButton;
	IBOutlet UIButton *fastingForgivenessButton;
	IBOutlet UIButton *fastingReconcileButton;
	IBOutlet UIButton *fastingVowButton;
	IBOutlet UIButton *cancelButton;
	IBOutlet UIImageView *leftHudBg;
	IBOutlet UIImageView *rightHudBg;
}

- (void)setSelectedRowFastingType:(FastingType)fastingType;
- (IBAction)setFastingTypeNone:(id)sender;
- (IBAction)setFastingTypeMandatory:(id)sender;
- (IBAction)setFastingTypeVoluntary:(id)sender;
- (IBAction)setFastingTypeReconcile:(id)sender;
- (IBAction)setFastingTypeForgiveness:(id)sender;
- (IBAction)setFastingTypeVow:(id)sender;

@end
