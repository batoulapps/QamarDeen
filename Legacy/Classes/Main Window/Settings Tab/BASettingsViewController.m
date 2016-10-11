//
//  BASettingsViewController.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 4/30/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BASettingsViewController.h"
#import "BAQamarDeenAppDelegate.h"
#import "BAAboutViewController.h"
#import "BABatoulAppsViewController.h"
#import "BAQuranAppSetting.h"

@implementation BASettingsViewController

@synthesize genderButton;
@synthesize sevenDayButton;

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    if (self = [super initWithNibName:nibName bundle:nibBundle]) {
		// Custom initialization
		self.title = [BALocalizer localizedString:@"SettingsTab"];
		self.tabBarItem.image = [UIImage imageNamed:@"tabbar-settings.png"];
    }
    return self;
}

- (void)viewDidLoad 
{
	[self localizeUI];
}

- (void)viewWillAppear:(BOOL)animated
{	
	[sevenDayButton setOn:[[QDAppDelegate userSettings] boolForKey:@"IsSevenDay"]];
	[genderButton setOn:[[QDAppDelegate userSettings] boolForKey:@"IsMale"] animated:NO];
	[protectionToggle setOn:[[QDAppDelegate userSettings] boolForKey:@"ProtectionEnabled"] animated:NO];
	[arabicButton setOn:[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"] animated:NO];
	
	switch ([[[BAQamarDeenAppDelegate sharedDelegate] userSettings] integerForKey:@"QuranApp"]) {
		case 3:
			[quranAppValue setText:@"Al Mus'haf"];
			break;
		case 2:
			[quranAppValue setText:@"iQuran"];
			break;
		case 1:
		default:
			if([QDAppDelegate isRunningOnIpad]) {
				[quranAppValue setText:@"Quran Reader HD"];				
			} else {
				[quranAppValue setText:@"Quran Reader"];
			}
			break;
	}
	
	if([NSLocalizedString(@"SystemLanguage",@"") isEqualToString:@"Arabic"]) {
		[arabicButton setOn:YES animated:NO];
		[arabicButton setEnabled:NO];
	}
}

- (void)localizeUI
{
	self.title = [BALocalizer localizedString:@"SettingsTab"];
	
	[viewTitle setText:[BALocalizer localizedString:@"SettingsTab"]];
	[arabicLabel setText:[BALocalizer localizedString:@"ArabicModeLabel"]];
	[genderLabel setText:[BALocalizer localizedString:@"UserGenderLabel"]];
	[extraPrayersLabel setText:[BALocalizer localizedString:@"ExtraPrayersLabel"]];
	[aboutButton setTitle:[BALocalizer localizedString:@"AboutQamarDeen"] forState:UIControlStateNormal];
	[moreBatoulAppsButton setTitle:[BALocalizer localizedString:@"MoreBatoulApps"] forState:UIControlStateNormal];
	[quranAppButton setTitle:[BALocalizer localizedString:@"QuranApp"] forState:UIControlStateNormal];
	[protectionLabel setText:[BALocalizer localizedString:@"ProtectionButton"]];
	[passcode1Title setText:[BALocalizer localizedString:@"EnterPasscode"]];
	[passcode2Title setText:[BALocalizer localizedString:@"EnterPasscodeVerify"]];
}

- (IBAction)genderButtonToggle:(id)sender
{
	[[QDAppDelegate userSettings] setBool:[genderButton isOn] forKey:@"IsMale"];
}

- (IBAction)arabicModeToggle:(id)sender
{
	[[QDAppDelegate userSettings] setBool:[arabicButton isOn] forKey:@"ArabicMode"];
	
	for(UIViewController *viewController in [[QDAppDelegate tabBarController] viewControllers]) {
		if([viewController respondsToSelector:@selector(localizeUI)]) {
			[viewController performSelector:@selector(localizeUI)];
		}
		
		if([viewController respondsToSelector:@selector(reloadTable)]) {
			[viewController performSelector:@selector(reloadTable)];
		}
	}
}
	
- (IBAction)sevenDayButtonToggle:(id)sender
{
	[[QDAppDelegate userSettings] setBool:[sevenDayButton isOn] forKey:@"IsSevenDay"];
}

- (IBAction)aboutButtonAction:(id)sender
{
	BAQamarDeenAppDelegate *appDelegate = [BAQamarDeenAppDelegate sharedDelegate];
	BAAboutViewController *aboutViewController = [[BAAboutViewController alloc] initWithNibName:@"BAAboutView" bundle:nil];
		
	UINavigationController *customNavigationController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
	customNavigationController.navigationBarHidden = YES;
	[appDelegate.navigationController presentModalViewController:customNavigationController animated:YES];	
	
	[customNavigationController release];
	[aboutViewController release];	
}

- (IBAction)moreBatoulApps:(id)sender {
	BAQamarDeenAppDelegate *appDelegate = [BAQamarDeenAppDelegate sharedDelegate];
	BABatoulAppsViewController *batoulAppsViewController = [[[BABatoulAppsViewController alloc] initWithNibName:@"BABatoulAppsView" bundle:nil] autorelease];
	[batoulAppsViewController setHidesBottomBarWhenPushed:YES];
	[appDelegate.navigationController presentModalViewController:batoulAppsViewController animated:YES];	
}

- (IBAction)quranAppAction:(id)sender {
	BAQamarDeenAppDelegate *appDelegate = [BAQamarDeenAppDelegate sharedDelegate];
	BAQuranAppSetting *quranAppSetting = [[[BAQuranAppSetting alloc] initWithNibName:@"BAQuranAppSetting" bundle:nil] autorelease];
	[quranAppSetting setHidesBottomBarWhenPushed:YES];
	[appDelegate.navigationController presentModalViewController:quranAppSetting animated:YES];		
}

- (IBAction)protectionAction:(id)sender
{
	if([protectionToggle isOn]) {
		//show password protection screen
		passcodeCancel.alpha = 1.0;
		viewTitle.text = @"Passcode";
		[passcode1Title setText:[BALocalizer localizedString:@"EnterPasscode"]];
		CGRect frameRect = passcodeView.frame;
		
		[UIView beginAnimations:@"PasscodeSlide" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.30];
			frameRect.origin.y = 44;
			passcodeView.frame = frameRect;
		[UIView commitAnimations];	
		
		[passcodeField becomeFirstResponder];
	} else {
		[[[BAQamarDeenAppDelegate sharedDelegate] userSettings] setBool:[protectionToggle isOn] forKey:@"ProtectionEnabled"];
		[[[BAQamarDeenAppDelegate sharedDelegate] userSettings] setObject:@"" forKey:@"ProtectionCode"];
	}
}

- (IBAction)protectionActionCancel:(id)sender
{
	passcodeCancel.alpha = 0.0;	
	[viewTitle setText:[BALocalizer localizedString:@"SettingsTab"]];
	
	[UIView beginAnimations:@"PasscodeSlide" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.30];
	[UIView setAnimationDidStopSelector:@selector(resetPasscodeFields)];
	passcodeView.center = CGPointMake(passcodeView.center.x, 550.0);
	[UIView commitAnimations];
	
	[passcodeField resignFirstResponder];
	[repasscodeField resignFirstResponder];
	
	protectionToggle.on = NO;
	[[[BAQamarDeenAppDelegate sharedDelegate] userSettings] setBool:[protectionToggle isOn] forKey:@"ProtectionEnabled"];
	[[[BAQamarDeenAppDelegate sharedDelegate] userSettings] setObject:@"" forKey:@"ProtectionCode"];

}

- (void)resetPasscodeFields
{
	passcodeField.text = @"";
	repasscodeField.text = @"";

	passNum1.image = [UIImage imageNamed:@"pass-box-off.png"];
	passNum2.image = [UIImage imageNamed:@"pass-box-off.png"];
	passNum3.image = [UIImage imageNamed:@"pass-box-off.png"];
	passNum4.image = [UIImage imageNamed:@"pass-box-off.png"];
	
	repassNum1.image = [UIImage imageNamed:@"pass-box-off.png"];
	repassNum2.image = [UIImage imageNamed:@"pass-box-off.png"];
	repassNum3.image = [UIImage imageNamed:@"pass-box-off.png"];
	repassNum4.image = [UIImage imageNamed:@"pass-box-off.png"];
	
	CGRect frameRectGroup1 = passcodeGroup1.frame;
	frameRectGroup1.origin.x = 0;
	passcodeGroup1.frame = frameRectGroup1;
	
	CGRect frameRectGroup2 = passcodeGroup2.frame;
	frameRectGroup2.origin.x = 320;
	passcodeGroup2.frame = frameRectGroup2;
	
}

- (IBAction)passcodeUpdate:(id)sender
{
	if([passcodeField.text length] >= 4) {
		passNum4.image = [UIImage imageNamed:@"pass-box-on.png"];
		[repasscodeField becomeFirstResponder];
		
		CGRect frameRectGroup1 = passcodeGroup1.frame;
		CGRect frameRectGroup2 = passcodeGroup2.frame;
		
		[UIView beginAnimations:@"PasscodeSlide" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.30];
		frameRectGroup1.origin.x = -320;
		frameRectGroup2.origin.x = 0;
		passcodeGroup1.frame = frameRectGroup1;
		passcodeGroup2.frame = frameRectGroup2;
		[UIView commitAnimations];	
		
	} else {
		passNum4.image = [UIImage imageNamed:@"pass-box-off.png"];
	}
	
	if([passcodeField.text length] >= 3) {
		passNum3.image = [UIImage imageNamed:@"pass-box-on.png"];		
	} else {
		passNum3.image = [UIImage imageNamed:@"pass-box-off.png"];
	}
	
	if([passcodeField.text length] >= 2) {
		passNum2.image = [UIImage imageNamed:@"pass-box-on.png"];		
	} else {
		passNum2.image = [UIImage imageNamed:@"pass-box-off.png"];
	}
	
	if([passcodeField.text length] >= 1) {
		passNum1.image = [UIImage imageNamed:@"pass-box-on.png"];		
	} else {
		passNum1.image = [UIImage imageNamed:@"pass-box-off.png"];
	}
}

- (IBAction)repasscodeUpdate:(id)sender
{
	if([repasscodeField.text length] >= 4) {
		repassNum4.image = [UIImage imageNamed:@"pass-box-on.png"];
		
		if([repasscodeField.text isEqualToString:passcodeField.text]) {
			passcodeCancel.alpha = 0.0;	
			[viewTitle setText:[BALocalizer localizedString:@"SettingsTab"]];
			
			[UIView beginAnimations:@"PasscodeSlide" context:nil];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDuration:0.30];
			[UIView setAnimationDidStopSelector:@selector(resetPasscodeFields)];
			passcodeView.center = CGPointMake(passcodeView.center.x, 550.0);
			[UIView commitAnimations];
			
			[passcodeField resignFirstResponder];
			[repasscodeField resignFirstResponder];
			
			protectionToggle.on = YES;
			
			//update the users settings
			[[[BAQamarDeenAppDelegate sharedDelegate] userSettings] setBool:[protectionToggle isOn] forKey:@"ProtectionEnabled"];
			[[[BAQamarDeenAppDelegate sharedDelegate] userSettings] setObject:repasscodeField.text forKey:@"ProtectionCode"];
			
		} else {
			[passcodeField becomeFirstResponder];
			[passcode1Title setText:[BALocalizer localizedString:@"PasscodeMismatch"]];
			passNum1.image = [UIImage imageNamed:@"pass-box-off.png"];
			passNum2.image = [UIImage imageNamed:@"pass-box-off.png"];
			passNum3.image = [UIImage imageNamed:@"pass-box-off.png"];
			passNum4.image = [UIImage imageNamed:@"pass-box-off.png"];
			
			CGRect frameRectGroup1 = passcodeGroup1.frame;
			CGRect frameRectGroup2 = passcodeGroup2.frame;
			
			[UIView beginAnimations:@"PasscodeSlide" context:nil];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(resetPasscodeFields)];
			[UIView setAnimationDuration:0.30];
			frameRectGroup1.origin.x = 0;
			frameRectGroup2.origin.x = 320;
			passcodeGroup1.frame = frameRectGroup1;
			passcodeGroup2.frame = frameRectGroup2;
			[UIView commitAnimations];	
		}
		
		
	} else {
		repassNum4.image = [UIImage imageNamed:@"pass-box-off.png"];
	}
	
	if([repasscodeField.text length] >= 3) {
		repassNum3.image = [UIImage imageNamed:@"pass-box-on.png"];		
	} else {
		repassNum3.image = [UIImage imageNamed:@"pass-box-off.png"];
	}
	
	if([repasscodeField.text length] >= 2) {
		repassNum2.image = [UIImage imageNamed:@"pass-box-on.png"];		
	} else {
		repassNum2.image = [UIImage imageNamed:@"pass-box-off.png"];
	}
	
	if([repasscodeField.text length] >= 1) {
		repassNum1.image = [UIImage imageNamed:@"pass-box-on.png"];		
	} else {
		repassNum1.image = [UIImage imageNamed:@"pass-box-off.png"];
	}
}

// override to allow orientations other than the default portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait); // support only portrait
}

- (void)dealloc {
	[genderButton release];
	[sevenDayButton release];
    [super dealloc];
}


@end
