//
//  ProtectedViewController.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 6/10/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "ProtectedViewController.h"
#import "BAQamarDeenAppDelegate.h"

@implementation ProtectedViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[passField becomeFirstResponder];
	[enterPass setText:[BALocalizer localizedString:@"EnterYourPasscode"]];
	[wrongPass setText:[BALocalizer localizedString:@"PasscodeIncorrect"]];
	[wrongPass setAlpha:0.0];	
}

- (IBAction)checkPassword:(id)sender
{
	if([passField.text length] >= 4) {
		passNum4.image = [UIImage imageNamed:@"pass-box-on.png"];
		//validate password here
		if([passField.text isEqualToString:[[[BAQamarDeenAppDelegate sharedDelegate] userSettings] stringForKey:@"ProtectionCode"]]) {
			passScreen.image = [UIImage imageNamed:@"pass-top-unlocked.png"];
			[enterPass setText:[BALocalizer localizedString:@"PasscodeCorrect"]];
			enterPass.alpha = 1.0;
			wrongPass.alpha = 0.0;
			[self performSelector:@selector(dismissScreen) withObject:nil afterDelay:0.15];
			
		} else {
			passScreen.image = [UIImage imageNamed:@"pass-top-wrong.png"];
			enterPass.alpha = 0.0;
			wrongPass.alpha = 1.0;
			
			CGRect boxFrame1 = passNum1.frame;
			CGRect boxFrame2 = passNum2.frame;
			CGRect boxFrame3 = passNum3.frame;
			CGRect boxFrame4 = passNum4.frame;
			
			[UIView beginAnimations:@"IncorrectShake" context:nil];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(finalShake)];
			[UIView setAnimationDuration:0.08];
			[UIView setAnimationRepeatAutoreverses:YES];
			[UIView setAnimationRepeatCount:2];
			boxFrame1.origin.x = boxFrame1.origin.x - 10;
			boxFrame2.origin.x = boxFrame2.origin.x - 10;
			boxFrame3.origin.x = boxFrame3.origin.x - 10;
			boxFrame4.origin.x = boxFrame4.origin.x - 10;
			
			passNum1.frame = boxFrame1;
			passNum2.frame = boxFrame2;
			passNum3.frame = boxFrame3;
			passNum4.frame = boxFrame4;
			[UIView commitAnimations];	
		}
	} else {
		passNum4.image = [UIImage imageNamed:@"pass-box-off.png"];
	}

	if([passField.text length] >= 3) {
		passNum3.image = [UIImage imageNamed:@"pass-box-on.png"];		
	} else {
		passNum3.image = [UIImage imageNamed:@"pass-box-off.png"];
	}

	if([passField.text length] >= 2) {
		passNum2.image = [UIImage imageNamed:@"pass-box-on.png"];		
	} else {
		passNum2.image = [UIImage imageNamed:@"pass-box-off.png"];
	}

	if([passField.text length] >= 1) {
		passNum1.image = [UIImage imageNamed:@"pass-box-on.png"];		
	} else {
		passNum1.image = [UIImage imageNamed:@"pass-box-off.png"];
	}
}

- (void)finalShake
{
	CGRect boxFrame1 = passNum1.frame;
	CGRect boxFrame2 = passNum2.frame;
	CGRect boxFrame3 = passNum3.frame;
	CGRect boxFrame4 = passNum4.frame;
	
	[UIView beginAnimations:@"IncorrectShake" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(resetPassImages)];
	[UIView setAnimationDuration:0.08];
	boxFrame1.origin.x = boxFrame1.origin.x + 10;
	boxFrame2.origin.x = boxFrame2.origin.x + 10;
	boxFrame3.origin.x = boxFrame3.origin.x + 10;
	boxFrame4.origin.x = boxFrame4.origin.x + 10;
	
	passNum1.frame = boxFrame1;
	passNum2.frame = boxFrame2;
	passNum3.frame = boxFrame3;
	passNum4.frame = boxFrame4;
	[UIView commitAnimations];		
}

- (void)resetPassImages
{
	passNum4.image = [UIImage imageNamed:@"pass-box-off.png"];
	passNum3.image = [UIImage imageNamed:@"pass-box-off.png"];
	passNum2.image = [UIImage imageNamed:@"pass-box-off.png"];
	passNum1.image = [UIImage imageNamed:@"pass-box-off.png"];
	passField.text = @"";
}

- (void)dismissScreen
{
	[QDAppDelegate dismissSecurityScreen];
}

- (void)dealloc {
    [super dealloc];
}


@end
