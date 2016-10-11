//
//  BAPrayerViewController.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/2/10.
//  Copyright Batoul Apps 2010. All rights reserved.
//

#import "BAPrayerViewController.h"
#import "BAPrayerCell.h"
#import "BAQamarDeenAppDelegate.h"
#import "BAProgressGraphViewController.h"

#define COLUMN_HEADER_FONT_SMALL 10
#define COLUMN_HEADER_FONT_LARGE 12

@interface BAPrayerViewController (Private)

- (void)setSelectedPrayerMethod:(PrayerMethod)method;

@end

@implementation BAPrayerViewController

@synthesize prayerModalArrow, selectedPrayerType;
@synthesize fajrColumnLabel, shuruqColumnLabel, dhuhrColumnLabel, asrColumnLabel, maghribColumnLabel, ishaColumnLabel, qiyamColumnLabel;
@synthesize prayerButtonNone, prayerButtonAlone, prayerButtonAloneWithVoluntary, prayerButtonGroup, prayerButtonGroupWithVoluntary, prayerButtonLate, prayerButtonExcused;
@synthesize graphViewController;

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    if (self = [super initWithNibName:nibName bundle:nibBundle])
	{
		// Custom initialization
		self.title = [BALocalizer localizedString:@"PrayersTab"];
		self.tabBarItem.image = [UIImage imageNamed:@"tabbar-prayers.png"];
    }
    return self;
}

- (void)orientationChanged:(NSNotification *)notification
{
    // We must add a delay here, otherwise we'll swap in the new view
	// too quickly and we'll get an animation glitch
    [self performSelector:@selector(updateLandscapeView) withObject:nil afterDelay:0];
}

- (void)updateLandscapeView
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !isShowingLandscapeView && [[[BAQamarDeenAppDelegate sharedDelegate] tabBarController] selectedIndex] != 4)
	{
        [[QDAppDelegate navigationController] presentModalViewController:self.graphViewController animated:YES];
        isShowingLandscapeView = YES;
    }
	else if (deviceOrientation == UIDeviceOrientationPortrait && isShowingLandscapeView)
	{
		if([[QDAppDelegate navigationController] visibleViewController] == graphViewController) {
			[[QDAppDelegate navigationController] dismissModalViewControllerAnimated:YES];
		}
        isShowingLandscapeView = NO;
    }    
}

// override to allow orientations other than the default portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait); // support only portrait
}

	
- (void)viewDidLoad 
{
	BAProgressGraphViewController *viewController = [[BAProgressGraphViewController alloc]
											   initWithNibName:@"BAProgressGraphView" bundle:nil];
	self.graphViewController = viewController;
	[viewController release];
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
												 name:UIDeviceOrientationDidChangeNotification object:nil];
	
	isSevenDay = [[QDAppDelegate userSettings] boolForKey:@"IsSevenDay"];
	isMale = [[QDAppDelegate userSettings] boolForKey:@"IsMale"];
	
	if (isSevenDay)
	{
		tableBgFilename = @"prayer7-tablebg.png";
		tableFooterFilename = @"prayer7-tablefooter.png";
		tableFooterSelectedFilename = @"prayer7-tablefooter-selected.png";
	}
	else
	{
		tableBgFilename = @"prayer5-tablebg.png";
		tableFooterFilename = @"prayer5-tablefooter.png";
		tableFooterSelectedFilename = @"prayer5-tablefooter-selected.png";
	}
	
	[super viewDidLoad];
	[self localizeUI];
	[self setupPrayerModalView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
		
	CGRect frame = [modalView frame];
	frame.origin.y = 411;
	[modalView setFrame:frame];
	[dateTable setScrollEnabled:YES];
	[dateTable deselectRowAtIndexPath:[dateTable indexPathForSelectedRow] animated:NO];
	
	if (isSevenDay != [[QDAppDelegate userSettings] boolForKey:@"IsSevenDay"] || isMale != [[QDAppDelegate userSettings] boolForKey:@"IsMale"])
	{
		isSevenDay = [[QDAppDelegate userSettings] boolForKey:@"IsSevenDay"];
		isMale = [[QDAppDelegate userSettings] boolForKey:@"IsMale"];
		
		if (isSevenDay)
		{
			tableBgFilename = @"prayer7-tablebg.png";
			tableFooterFilename = @"prayer7-tablefooter.png";
			tableFooterSelectedFilename = @"prayer7-tablefooter-selected.png";
		}
		else
		{
			tableBgFilename = @"prayer5-tablebg.png";
			tableFooterFilename = @"prayer5-tablefooter.png";
			tableFooterSelectedFilename = @"prayer5-tablefooter-selected.png";
		}
		
		dateTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:tableBgFilename]];
		[moreButton setImage:[UIImage imageNamed:tableFooterFilename] forState:UIControlStateNormal];
		[moreButton setImage:[UIImage imageNamed:tableFooterSelectedFilename] forState:UIControlStateHighlighted];
		[moreButton setImage:[UIImage imageNamed:tableFooterSelectedFilename] forState:UIControlStateSelected];
		
		[self setupFixedTableHeader];
		[self setupPrayerModalView];
		[dateTable reloadData];
	}
}

- (void)localizeUI
{
	self.title = [BALocalizer localizedString:@"PrayersTab"];
	
	//localize header
	[viewTitle setText:[BALocalizer localizedString:@"PrayersTab"]];
	[fajrColumnLabel setText:[BALocalizer localizedString:@"Fajr"]];
	[shuruqColumnLabel setText:[BALocalizer localizedString:@"Shuruq"]];
	[dhuhrColumnLabel setText:[BALocalizer localizedString:@"Dhuhr"]];
	[asrColumnLabel setText:[BALocalizer localizedString:@"Asr"]];
	[maghribColumnLabel setText:[BALocalizer localizedString:@"Maghrib"]];
	[ishaColumnLabel setText:[BALocalizer localizedString:@"Isha"]];
	[qiyamColumnLabel setText:[BALocalizer localizedString:@"Qiyam"]];
	
	//localize button names
	[prayerButtonNone setTitle:[BALocalizer localizedString:@"prayerButtonNone"] forState:UIControlStateNormal];
	[prayerButtonAlone setTitle:[BALocalizer localizedString:@"prayerButtonAlone"] forState:UIControlStateNormal];
	[prayerButtonAloneWithVoluntary setTitle:[BALocalizer localizedString:@"prayerButtonAloneWithVoluntary"] forState:UIControlStateNormal];
	[prayerButtonGroup setTitle:[BALocalizer localizedString:@"prayerButtonGroup"] forState:UIControlStateNormal];
	[prayerButtonGroupWithVoluntary setTitle:[BALocalizer localizedString:@"prayerButtonGroupWithVoluntary"] forState:UIControlStateNormal];
	[prayerButtonLate setTitle:[BALocalizer localizedString:@"prayerButtonLate"] forState:UIControlStateNormal];
	[prayerButtonExcused setTitle:[BALocalizer localizedString:@"prayerButtonExcused"] forState:UIControlStateNormal];	
	[cancelButton setTitle:[BALocalizer localizedString:@"CancelButton"] forState:UIControlStateNormal];
	
	[self setupFixedTableHeader];
	
	[self.graphViewController localizeUI];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (![self modalViewIsToggled])
	{
		[tableView setScrollEnabled:NO];
	}
	
	CGPoint contentViewTouchPoint = [[tableView cellForRowAtIndexPath:indexPath] convertPoint:touchPoint fromView:tableView];
	
	[UIView beginAnimations:nil context:tableView];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	if (![self modalViewIsToggled])
	{
		CGFloat scrollPos = [[tableView cellForRowAtIndexPath:indexPath] frame].origin.y - [self tableView:tableView heightForHeaderInSection:[indexPath section]];
		[self displayModalView];
		[tableView setContentOffset:CGPointMake(0, scrollPos) animated:NO];
	}

	CGFloat arrowCenter = 0;
	int index = 0;
	if (isSevenDay)
	{
		index = (contentViewTouchPoint.x - 40) / 40;
		if (index < 0) index = 0;
		arrowCenter = 60 + 40 * index;
	}
	else
	{
		index = (contentViewTouchPoint.x - 40) / 56;
		if (index < 0) index = 0;
		arrowCenter = 68 + 56 * index;
	}
	
	if (!isSevenDay && index >= PrayerTypeShuruq) index++;
	self.selectedPrayerType = index;
	
	if (isSevenDay && self.selectedPrayerType == PrayerTypeShuruq)
	{
		[[self prayerButtonGroup] setEnabled:NO];
		[[self prayerButtonAloneWithVoluntary] setEnabled:NO];
		[[self prayerButtonGroupWithVoluntary] setEnabled:NO];
		[[self prayerButtonExcused] setEnabled:NO];
		[[self prayerButtonLate] setEnabled:NO];
	}
	else if(isSevenDay && self.selectedPrayerType == PrayerTypeQiyam)
	{
		[[self prayerButtonGroup] setEnabled:YES];
		[[self prayerButtonAloneWithVoluntary] setEnabled:NO];
		[[self prayerButtonGroupWithVoluntary] setEnabled:NO];
		[[self prayerButtonExcused] setEnabled:NO];
		[[self prayerButtonLate] setEnabled:NO];
	}
	else
	{
		[[self prayerButtonGroup] setEnabled:YES];
		[[self prayerButtonAloneWithVoluntary] setEnabled:YES];
		[[self prayerButtonGroupWithVoluntary] setEnabled:YES];
		[[self prayerButtonExcused] setEnabled:YES];
		[[self prayerButtonLate] setEnabled:YES];
	}
	
	self.prayerModalArrow.center = CGPointMake(arrowCenter, self.prayerModalArrow.center.y);
	[UIView commitAnimations];
	
	// highlight currently selected value
	leftHudBg.center = CGPointMake(leftHudBg.center.x, -900);
	rightHudBg.center = CGPointMake(rightHudBg.center.x, -900);
	NSSet *prayers = [[self dayForIndexPath:[dateTable indexPathForSelectedRow]] prayers];
	
	//[[days objectAtIndex:[self dayIndexForIndexPath:[dateTable indexPathForSelectedRow]]] prayers];
	for (Prayer *prayer in prayers)
	{
		if ([prayer type] == self.selectedPrayerType)
		{
			switch (prayer.method) {
				case PrayerMethodAlone:
					rightHudBg.center = CGPointMake(rightHudBg.center.x, prayerButtonAlone.center.y);
					break;
				case PrayerMethodAloneWithVoluntary:
					leftHudBg.center = CGPointMake(leftHudBg.center.x, prayerButtonAloneWithVoluntary.center.y);
					break;
				case PrayerMethodGroup:
					rightHudBg.center = CGPointMake(rightHudBg.center.x, prayerButtonGroup.center.y);
					break;
				case PrayerMethodGroupWithVoluntary:
					leftHudBg.center = CGPointMake(leftHudBg.center.x, prayerButtonGroupWithVoluntary.center.y);
					break;
				case PrayerMethodLate:
					leftHudBg.center = CGPointMake(leftHudBg.center.x, prayerButtonLate.center.y);
					break;
				case PrayerMethodExcused:
					if(!isMale) {
						leftHudBg.center = CGPointMake(leftHudBg.center.x, prayerButtonExcused.center.y);
					} else {
						rightHudBg.center = CGPointMake(rightHudBg.center.x, prayerButtonNone.center.y);
					}
					break;
				default:
				case PrayerMethodNone:
					rightHudBg.center = CGPointMake(rightHudBg.center.x, prayerButtonNone.center.y);
					break;
			}
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	NSString *CellIdentifier = [NSString stringWithFormat:@"PrayerCell %d-%d", isSevenDay, isMale];
    
    BAPrayerCell *cell = (BAPrayerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[BAPrayerCell alloc] initWithReuseIdentifier:CellIdentifier type:(isSevenDay)?BAPrayerCellTypeSeven:BAPrayerCellTypeFive gender:(isMale)?BAPrayerCellGenderMale:BAPrayerCellGenderFemale] autorelease];
    }
	
	[cell setIsToday:(indexPath.row == 0 && indexPath.section == 0)];
	
	NSDate *cellDate = [self dateForIndexPath:indexPath];
	[cell setDate:[BALocalizer localizedDay:cellDate]];
	[cell setDay:[BALocalizer localizedWeekday:cellDate]];
	
	NSSet *prayers = [[self dayForIndexPath:indexPath] prayers];
	for (Prayer *prayer in prayers)
	{
		[cell setPrayerMethod:[prayer method] forType:[prayer type]];
	}
			
    return cell;
}

- (void)setSelectedPrayerMethod:(PrayerMethod)method
{
	NSSet *prayers = [[self dayForIndexPath:[dateTable indexPathForSelectedRow]] prayers];
	for (Prayer *prayer in prayers)
	{
		if ([prayer type] == self.selectedPrayerType)
		{
			[prayer setMethod:method];
			break;
		}
	}
	
	[self setTimePeriod:numberOfDays];
	[dateTable reloadData];	
	
	if ([self modalViewIsToggled])
	{
		[self toggleModalView:self];
	}
}

- (IBAction)setPrayerMethod:(id)sender 
{
	PrayerMethod method = PrayerMethodNone;
	if (sender == prayerButtonNone) method = PrayerMethodNone;
	if (sender == prayerButtonAlone) method = PrayerMethodAlone;
	if (sender == prayerButtonAloneWithVoluntary) method = PrayerMethodAloneWithVoluntary;
	if (sender == prayerButtonGroup) method = PrayerMethodGroup;
	if (sender == prayerButtonGroupWithVoluntary) method = PrayerMethodGroupWithVoluntary;
	if (sender == prayerButtonLate) method = PrayerMethodLate;
	if (sender == prayerButtonExcused) method = PrayerMethodExcused;
	[self setSelectedPrayerMethod:method];
}

- (void)setupFixedTableHeader
{
	CGFloat width = isSevenDay ? 40 : 56;
	
	fajrColumnLabel.frame = CGRectMake(fajrColumnLabel.frame.origin.x, fajrColumnLabel.frame.origin.y, width, fajrColumnLabel.frame.size.height);
	shuruqColumnLabel.frame = CGRectMake(shuruqColumnLabel.frame.origin.x, shuruqColumnLabel.frame.origin.y, width, shuruqColumnLabel.frame.size.height);
	dhuhrColumnLabel.frame = CGRectMake(dhuhrColumnLabel.frame.origin.x, dhuhrColumnLabel.frame.origin.y, width, dhuhrColumnLabel.frame.size.height);
	asrColumnLabel.frame = CGRectMake(asrColumnLabel.frame.origin.x, asrColumnLabel.frame.origin.y, width, asrColumnLabel.frame.size.height);
	maghribColumnLabel.frame = CGRectMake(maghribColumnLabel.frame.origin.x, maghribColumnLabel.frame.origin.y, width, maghribColumnLabel.frame.size.height);
	ishaColumnLabel.frame = CGRectMake(ishaColumnLabel.frame.origin.x, ishaColumnLabel.frame.origin.y, width, ishaColumnLabel.frame.size.height);
	qiyamColumnLabel.frame = CGRectMake(qiyamColumnLabel.frame.origin.x, qiyamColumnLabel.frame.origin.y, width, qiyamColumnLabel.frame.size.height);
	
	int smallFontSize = COLUMN_HEADER_FONT_SMALL;
	int largeFontSize = COLUMN_HEADER_FONT_LARGE;
	
	if([[BALocalizer localizedString:@"SystemLanguage"] isEqualToString:@"Arabic"]) {
		//use larger fonts if UI is set to Arabic
		smallFontSize += 3;
		largeFontSize += 2;
	}
	
	if(isSevenDay)
	{
		fajrColumnLabel.center = CGPointMake(60, 58);
		fajrColumnLabel.font = [UIFont systemFontOfSize:smallFontSize];
		shuruqColumnLabel.center = CGPointMake(100, 58);
		shuruqColumnLabel.font = [UIFont systemFontOfSize:smallFontSize];
		dhuhrColumnLabel.center = CGPointMake(140, 58);
		dhuhrColumnLabel.font = [UIFont systemFontOfSize:smallFontSize];
		asrColumnLabel.center = CGPointMake(180, 58);
		asrColumnLabel.font = [UIFont systemFontOfSize:smallFontSize];
		maghribColumnLabel.center = CGPointMake(221, 58);
		maghribColumnLabel.font = [UIFont systemFontOfSize:smallFontSize];
		ishaColumnLabel.center = CGPointMake(260, 58);
		ishaColumnLabel.font = [UIFont systemFontOfSize:smallFontSize];
		qiyamColumnLabel.center = CGPointMake(300, 58);
		qiyamColumnLabel.font = [UIFont systemFontOfSize:smallFontSize];
	}
	else
	{
		[fajrColumnLabel setCenter:CGPointMake(68, 58)];
		[fajrColumnLabel setFont:[UIFont systemFontOfSize:largeFontSize]];
		[shuruqColumnLabel setCenter:CGPointMake(-80, -80)];
		[shuruqColumnLabel setFont:[UIFont systemFontOfSize:largeFontSize]];
		[dhuhrColumnLabel setCenter:CGPointMake(124, 58)];
		[dhuhrColumnLabel setFont:[UIFont systemFontOfSize:largeFontSize]];
		[asrColumnLabel setCenter:CGPointMake(180, 58)];
		[asrColumnLabel setFont:[UIFont systemFontOfSize:largeFontSize]];
		[maghribColumnLabel setCenter:CGPointMake(236, 58)];
		[maghribColumnLabel setFont:[UIFont systemFontOfSize:largeFontSize]];
		[ishaColumnLabel setCenter:CGPointMake(292, 58)];
		[ishaColumnLabel setFont:[UIFont systemFontOfSize:largeFontSize]];
		[qiyamColumnLabel setCenter:CGPointMake(-80, -80)];
		[qiyamColumnLabel setFont:[UIFont systemFontOfSize:largeFontSize]];
	}
	
	fajrColumnLabel.frame = CGRectIntegral(fajrColumnLabel.frame);
	shuruqColumnLabel.frame = CGRectIntegral(shuruqColumnLabel.frame);
	dhuhrColumnLabel.frame = CGRectIntegral(dhuhrColumnLabel.frame);
	asrColumnLabel.frame = CGRectIntegral(asrColumnLabel.frame);
	maghribColumnLabel.frame = CGRectIntegral(maghribColumnLabel.frame);
	ishaColumnLabel.frame = CGRectIntegral(ishaColumnLabel.frame);
	qiyamColumnLabel.frame = CGRectIntegral(qiyamColumnLabel.frame);
}

- (void)setupPrayerModalView
{
	if (isMale)
	{
		self.prayerButtonExcused.hidden = YES;
		[[self prayerButtonAlone] setBackgroundImage:[UIImage imageNamed:@"prayer-hud-alone-m.png"] forState:UIControlStateNormal];
		[[self prayerButtonAloneWithVoluntary] setBackgroundImage:[UIImage imageNamed:@"prayer-hud-aloneWithVoluntary-m.png"] forState:UIControlStateNormal];
		[[self prayerButtonGroup] setBackgroundImage:[UIImage imageNamed:@"prayer-hud-group-m.png"] forState:UIControlStateNormal];
		[[self prayerButtonGroupWithVoluntary] setBackgroundImage:[UIImage imageNamed:@"prayer-hud-groupWithVoluntary-m.png"] forState:UIControlStateNormal];
	}
	else
	{
		self.prayerButtonExcused.hidden = NO;
		[[self prayerButtonAlone] setBackgroundImage:[UIImage imageNamed:@"prayer-hud-alone-f.png"] forState:UIControlStateNormal];
		[[self prayerButtonAloneWithVoluntary] setBackgroundImage:[UIImage imageNamed:@"prayer-hud-aloneWithVoluntary-f.png"] forState:UIControlStateNormal];
		[[self prayerButtonGroup] setBackgroundImage:[UIImage imageNamed:@"prayer-hud-group-f.png"] forState:UIControlStateNormal];
		[[self prayerButtonGroupWithVoluntary] setBackgroundImage:[UIImage imageNamed:@"prayer-hud-groupWithVoluntary-f.png"] forState:UIControlStateNormal];
	}
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
	self.graphViewController = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	
	[graphViewController release];
	[prayerModalArrow release];
	[fajrColumnLabel release];
	[shuruqColumnLabel release];
	[dhuhrColumnLabel release];
	[asrColumnLabel release];
	[maghribColumnLabel release];
	[ishaColumnLabel release];
	[qiyamColumnLabel release];
	[prayerButtonNone release];
	[prayerButtonAlone release];
	[prayerButtonAloneWithVoluntary release];
	[prayerButtonGroup release];
	[prayerButtonGroupWithVoluntary release];
	[prayerButtonLate release];
	[prayerButtonExcused release];
    [super dealloc];
}

@end
