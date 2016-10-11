    //
//  BAAboutViewController.m
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAAboutViewController.h"
#import "BAQamarDeenAppDelegate.h"
#import "BACreditsView.h"

@implementation BAAboutViewController

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[appName setText:[BALocalizer localizedString:@"AppName"]];
	[versionLabel setText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
	[copyrightLabel setText:[BALocalizer localizedString:@"CopyrightLabel"]];
	[bandarButton setTitle:[BALocalizer localizedString:@"DesignByButton"] forState:UIControlStateNormal];
	[moreButton setTitle:[BALocalizer localizedString:@"MoreButton"] forState:UIControlStateNormal];
	[backButton setTitle:[BALocalizer localizedString:@"BackButton"] forState:UIControlStateNormal];
}

- (IBAction)batoulAppsButtonAction:(id)sender;
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://batoulapps.com/"]];
}

- (IBAction)bandarButtonAction:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://bandar.raffah.com/wp/"]];
}

- (IBAction)moreButtonAction:(id)sender
{
	BACreditsView *creditsView = [[[BACreditsView alloc] initWithNibName:@"BACreditsView" bundle:nil] autorelease];
	[self.navigationController pushViewController:creditsView animated:YES];
}

- (IBAction)backButtonAction:(id)sender
{
	BAQamarDeenAppDelegate *appDelegate = [BAQamarDeenAppDelegate sharedDelegate];
	[appDelegate.navigationController dismissModalViewControllerAnimated:YES];
}

// override to allow orientations other than the default portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait); // support only portrait
}

- (void)dealloc
{
	[bandarButton release];
	[moreButton release];
	[backButton release];
	[copyrightLabel release];
	[versionLabel release];
    [super dealloc];
}


@end
