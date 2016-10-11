//
//  BAFastingViewController.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 4/30/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAFastingViewController.h"
#import "BAFastingCell.h"
#import "Fast.h"

@implementation BAFastingViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    if ((self = [super initWithNibName:nibName bundle:nibBundle])) {
		// Custom initialization
		self.title = [BALocalizer localizedString:@"FastingTab"];
		self.tabBarItem.image = [UIImage imageNamed:@"tabbar-fasting.png"];
    }
    return self;
}

- (void)viewDidLoad 
{
	tableBgFilename = @"tablebg.png";
	tableFooterFilename = @"tablefooter.png";
	tableFooterSelectedFilename = @"tablefooter-selected.png";
	
	[self localizeUI];
	
	hijriCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSIslamicCalendar];
	
	hijriMonthFormatter = [[NSDateFormatter alloc] init];
	if(	[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"]) {
		[hijriMonthFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ar"] autorelease]];
	} else {
		[hijriMonthFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en"] autorelease]];
	}
	[hijriMonthFormatter setCalendar:hijriCalendar];
	[hijriMonthFormatter setDateFormat:@"MMMM"];
	
	hijriDateFormatter = [[NSDateFormatter alloc] init];
	if(	[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"]) {
		[hijriDateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ar"] autorelease]];
	}
	[hijriDateFormatter setCalendar:hijriCalendar];	
	[hijriDateFormatter setDateFormat:@"dd"];
	
    [super viewDidLoad];
}

- (void)requiresRefresh
{
	[self localizeUI];
	[super requiresRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
	CGRect frame = [modalView frame];
	frame.origin.y = 411;
	[modalView setFrame:frame];
	[dateTable setScrollEnabled:YES];
	[dateTable deselectRowAtIndexPath:[dateTable indexPathForSelectedRow] animated:NO];
}

- (void)localizeUI
{
	self.title = [BALocalizer localizedString:@"FastingTab"];
	
	//localize header
	[viewTitle setText:[BALocalizer localizedString:@"FastingTab"]];
	[hijriDateHeader setText:[BALocalizer localizedString:@"HijriDate"]];
	[fastingTypeHeader setText:[BALocalizer localizedString:@"FastingType"]];
	
	//localize button names
	[fastingNoneButton setTitle:[BALocalizer localizedString:@"FastingTypeNone"] forState:UIControlStateNormal];
	[fastingMandatoryButton setTitle:[BALocalizer localizedString:@"FastingTypeMandatory"] forState:UIControlStateNormal];
	[fastingVoluntaryButton setTitle:[BALocalizer localizedString:@"FastingTypeVoluntary"] forState:UIControlStateNormal];
	[fastingForgivenessButton setTitle:[BALocalizer localizedString:@"FastingTypeForgiveness"] forState:UIControlStateNormal];
	[fastingReconcileButton setTitle:[BALocalizer localizedString:@"FastingTypeReconcile"] forState:UIControlStateNormal];
	[fastingVowButton setTitle:[BALocalizer localizedString:@"FastingTypeVow"] forState:UIControlStateNormal];
	[cancelButton setTitle:[BALocalizer localizedString:@"CancelButton"] forState:UIControlStateNormal];
	
	[hijriMonthFormatter release];
	hijriMonthFormatter = [[NSDateFormatter alloc] init];
	if(	[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"]) {
		[hijriMonthFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ar"] autorelease]];
	}
	[hijriMonthFormatter setCalendar:hijriCalendar];
	[hijriMonthFormatter setDateFormat:@"MMMM"];
	
	[hijriDateFormatter release];
	hijriDateFormatter = [[NSDateFormatter alloc] init];
	if(	[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"]) {
		[hijriDateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ar"] autorelease]];
	}
	[hijriDateFormatter setCalendar:hijriCalendar];	
	[hijriDateFormatter setDateFormat:@"dd"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	if (![self modalViewIsToggled])
	{
		[tableView setScrollEnabled:NO];
		
		if ( [[hijriCalendar 
				components:(NSMonthCalendarUnit) 
				fromDate:[self dateForIndexPath:indexPath]] month] == 9) {
			//In ramadan disable all buttons but mandatory and none
			fastingMandatoryButton.enabled = YES;
			fastingNoneButton.enabled = YES;
			fastingVoluntaryButton.enabled = NO;
			fastingForgivenessButton.enabled = NO;
			fastingReconcileButton.enabled = NO;
			fastingVowButton.enabled = NO;
		} else {
			//not ramadan disable mandatory button
			fastingMandatoryButton.enabled = NO;
			fastingNoneButton.enabled = YES;
			fastingVoluntaryButton.enabled = YES;
			fastingForgivenessButton.enabled = YES;
			fastingReconcileButton.enabled = YES;
			fastingVowButton.enabled = YES;
		}
		
		CGFloat scrollPos = [[dateTable cellForRowAtIndexPath:indexPath] frame].origin.y - [self tableView:dateTable heightForHeaderInSection:[indexPath section]];
		[UIView beginAnimations:nil context:dateTable];
		[UIView setAnimationDelegate:self];
		[self displayModalView];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[[self dateTable] setContentOffset:CGPointMake(0, scrollPos) animated:NO];
		[UIView commitAnimations];
		
		// highlight currently selected value
		leftHudBg.center = CGPointMake(leftHudBg.center.x, -900);
		rightHudBg.center = CGPointMake(rightHudBg.center.x, -900);
		
		switch ([[self dayForIndexPath:indexPath] fastingType]) {
			case FastingTypeMandatory:
				leftHudBg.center = CGPointMake(leftHudBg.center.x, fastingMandatoryButton.center.y);
				break;
			case FastingTypeVoluntary:
				rightHudBg.center = CGPointMake(rightHudBg.center.x, fastingVoluntaryButton.center.y);
				break;
			case FastingTypeReconcile:
				leftHudBg.center = CGPointMake(leftHudBg.center.x, fastingReconcileButton.center.y);
				break;
			case FastingTypeForgiveness:
				rightHudBg.center = CGPointMake(rightHudBg.center.x, fastingForgivenessButton.center.y);
				break;
			case FastingTypeVow:
				leftHudBg.center = CGPointMake(leftHudBg.center.x, fastingVowButton.center.y);
				break;
			default:
			case FastingTypeNone:
				rightHudBg.center = CGPointMake(rightHudBg.center.x, fastingVowButton.center.y);
				break;
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"FastingCell";
    
    BAFastingCell *cell = (BAFastingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BAFastingCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
    }
	
	if(indexPath.row == 0 && indexPath.section == 0) {
		[cell setIsToday:[NSNumber numberWithBool:YES]];
	} else {
		[cell setIsToday:[NSNumber numberWithBool:NO]];		
	}

	
	[cell setFastingType:[[self dayForIndexPath:indexPath] fastingType]];

	
	NSDate *cellDate = [self dateForIndexPath:indexPath];
	[cell setDate:[BALocalizer localizedDay:cellDate]];
	[cell setDay:[BALocalizer localizedWeekday:cellDate]];
	
	NSString *hijriDate = [hijriDateFormatter stringFromDate:cellDate];
	
	NSString *hijriMonth = [hijriMonthFormatter stringFromDate:cellDate];
	
	[cell setHijriMonth:hijriMonth andHijriDate:hijriDate];

    return cell;
}

- (void)setSelectedRowFastingType:(FastingType)fastingType {
	[[self dayForIndexPath:[dateTable indexPathForSelectedRow]] setFastingType:fastingType];
	[self setTimePeriod:numberOfDays];
	[dateTable reloadData];	
	
	if ([self modalViewIsToggled])
	{
		[self toggleModalView:self];
	}
}

- (IBAction)setFastingTypeNone:(id)sender
{	
	[self setSelectedRowFastingType:FastingTypeNone];
}


- (IBAction)setFastingTypeMandatory:(id)sender 
{	
	[self setSelectedRowFastingType:FastingTypeMandatory];
}

- (IBAction)setFastingTypeVoluntary:(id)sender
{
	[self setSelectedRowFastingType:FastingTypeVoluntary];	
}

- (IBAction)setFastingTypeReconcile:(id)sender
{
	[self setSelectedRowFastingType:FastingTypeReconcile];	
}

- (IBAction)setFastingTypeForgiveness:(id)sender
{
	[self setSelectedRowFastingType:FastingTypeForgiveness];	
}

- (IBAction)setFastingTypeVow:(id)sender
{
	[self setSelectedRowFastingType:FastingTypeVow];	
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

// override to allow orientations other than the default portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait); // support only portrait
}


- (void)dealloc 
{
	[hijriCalendar release];
	[hijriMonthFormatter release];
	[hijriDateFormatter release];
    [super dealloc];
}

@end
