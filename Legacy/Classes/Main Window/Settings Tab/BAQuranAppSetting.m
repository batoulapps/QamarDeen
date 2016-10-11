//
//  BAQuranAppSetting.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 6/2/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAQuranAppSetting.h"
#import "BAQamarDeenAppDelegate.h"

@implementation BAQuranAppSetting

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//localize
	[header setText:[BALocalizer localizedString:@"QuranApp"]];
	[doneButton setTitle:[BALocalizer localizedString:@"PickerDone"] forState:UIControlStateNormal];
	
	if([QDAppDelegate isRunningOnIpad]) {
		[quranReaderButton setTitle:@"Quran Reader HD" forState:UIControlStateNormal];
	} else {
		[quranReaderButton setTitle:@"Quran Reader" forState:UIControlStateNormal];
	}
	
	switch ([[QDAppDelegate userSettings] integerForKey:@"QuranApp"]) {
		case 3:
			checkmark.center = CGPointMake(checkmark.center.x, mushafButton.center.y);
			break;
		case 2:
			checkmark.center = CGPointMake(checkmark.center.x, iquranButton.center.y);
			break;
		case 1:
		default:
			checkmark.center = CGPointMake(checkmark.center.x, quranReaderButton.center.y);
			break;
	}

}

- (IBAction)doneAction:(id)sender
{
	[[QDAppDelegate navigationController] dismissModalViewControllerAnimated:YES];	
}

- (IBAction)setQuranReader:(id)sender
{
	[[QDAppDelegate userSettings] setInteger:1 forKey:@"QuranApp"];
	checkmark.center = CGPointMake(checkmark.center.x, quranReaderButton.center.y);
}

- (IBAction)setiQuran:(id)sender
{
	[[QDAppDelegate userSettings] setInteger:2 forKey:@"QuranApp"];
	checkmark.center = CGPointMake(checkmark.center.x, iquranButton.center.y);	
}

- (IBAction)setAlMushaf:(id)sender
{
	[[QDAppDelegate userSettings] setInteger:3 forKey:@"QuranApp"];
	checkmark.center = CGPointMake(checkmark.center.x, mushafButton.center.y);
}

- (void)dealloc {
    [super dealloc];
}


@end
