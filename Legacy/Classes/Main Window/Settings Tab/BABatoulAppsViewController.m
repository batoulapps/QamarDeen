//
//  BABatoulAppsViewController.m
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BABatoulAppsViewController.h"
#import "BAQamarDeenAppDelegate.h"

@implementation BABatoulAppsViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad 
{
	//localize header
	[islamicApps setText:[BALocalizer localizedString:@"IslamicApps"]];
	[doneButton setTitle:[BALocalizer localizedString:@"DoneButton"] forState:UIControlStateNormal];
	
	if([QDAppDelegate isRunningOnIpad]) {
		[quranTitle setText:@"Quran Reader HD"];
		[quranButton setImage:[UIImage imageNamed:@"apps-quranreaderhd.png"] forState:UIControlStateNormal];
	} else {
		[quranTitle setText:@"Quran Reader"];
		[quranButton setImage:[UIImage imageNamed:@"apps-quranreader.png"] forState:UIControlStateNormal];
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)doneAction:(id)sender {
	BAQamarDeenAppDelegate *appDelegate = [BAQamarDeenAppDelegate sharedDelegate];
	[appDelegate.navigationController dismissModalViewControllerAnimated:YES];	
}

- (IBAction)viewQuranReader:(id)sender 
{
	if([QDAppDelegate isRunningOnIpad]) {
		// go to quran reader hd
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/quran-reader-hd/id385432976?mt=8"]];
	} else {
		// go to quran reader
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/quran-reader/id305902828&mt=8"]];
	}	
}

- (IBAction)viewGuidance:(id)sender 
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/guidance/id289679295?mt=8"]];
}

- (IBAction)viewSupplications:(id)sender 
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/supplications/id351543694?mt=8"]];	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
