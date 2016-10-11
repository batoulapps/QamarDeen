//
//  BAQuranViewController.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/2/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BADateTableViewController.h"
#import "BAQuranSurahSelector.h"

@interface BAQuranViewController : BADateTableViewController <SurahSelectorDelegate, UIActionSheetDelegate>
{
	IBOutlet UISegmentedControl *modeControl;
	IBOutlet UILabel *quranHeader;
	IBOutlet UILabel *quranAyahHeader;	
	IBOutlet UIPickerView *dailyPicker;
	IBOutlet UILabel *pickerInstructions;
	IBOutlet UIButton *pickerCancel;
	IBOutlet UIButton *pickerNone;
	IBOutlet UIButton *pickerDone;
	NSArray *surahs;
	int logSurah;
	int logAyah;
}

- (IBAction)setDailySurah:(id)sender;
- (IBAction)deleteDailySurah:(id)sender;
- (IBAction)toggleMode:(id)sender;
- (void)logFromUrlForSurah:(int)surah andAyah:(int)ayah;
- (void)logDailySurah:(int)surah andAyah:(int)ayah;
- (void)logExtraSurah:(int)surah;

@end
