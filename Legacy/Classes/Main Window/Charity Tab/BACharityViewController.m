//
//  BACharityViewController.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 4/30/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BACharityViewController.h"
#import "BACharityCell.h"

@implementation BACharityViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    if (self = [super initWithNibName:nibName bundle:nibBundle]) {
		// Custom initialization
		self.title = [BALocalizer localizedString:@"SadaqahTab"];
		self.tabBarItem.image = [UIImage imageNamed:@"tabbar-sadaqah.png"];
    }
    return self;
}

- (void)viewDidLoad 
{
	tableBgFilename = @"tablebg.png";
	tableFooterFilename = @"tablefooter.png";
	tableFooterSelectedFilename = @"tablefooter-selected.png";
	
	[self localizeUI];
	
    [super viewDidLoad];
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
	self.title = [BALocalizer localizedString:@"SadaqahTab"];
	
	[viewTitle setText:[BALocalizer localizedString:@"SadaqahTab"]];
	[charityHeader setText:[BALocalizer localizedString:@"CharityHeader"]];
	[cancelButton setTitle:[BALocalizer localizedString:@"CancelButton"] forState:UIControlStateNormal];
	[doneButton setTitle:[BALocalizer localizedString:@"DoneButton"] forState:UIControlStateNormal];
	[buttonMoney setTitle:[BALocalizer localizedString:@"CharityMoney"] forState:UIControlStateNormal];
	[buttonEffort setTitle:[BALocalizer localizedString:@"CharityEffort"] forState:UIControlStateNormal];
	[buttonFood setTitle:[BALocalizer localizedString:@"CharityFood"] forState:UIControlStateNormal];
	[buttonClothes setTitle:[BALocalizer localizedString:@"CharityClothes"] forState:UIControlStateNormal];
	[buttonSmile setTitle:[BALocalizer localizedString:@"CharitySmile"] forState:UIControlStateNormal];
	[buttonOther setTitle:[BALocalizer localizedString:@"CharityOther"] forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	if (![self modalViewIsToggled])
	{
		[tableView setScrollEnabled:NO];
		
		//deselect all buttons
		buttonMoney.selected = NO;
		buttonEffort.selected = NO;
		buttonFood.selected = NO;
		buttonClothes.selected = NO;
		buttonSmile.selected = NO;
		buttonOther.selected = NO;
		
		for (Charity *charity in [[self dayForIndexPath:indexPath] charities]) {
			switch (charity.type) {
				case CharityTypeMoney:
					buttonMoney.selected = YES;
					break;
				case CharityTypeEffort:
					buttonEffort.selected = YES;
					break;
				case CharityTypeFeeding:
					buttonFood.selected = YES;
					break;
				case CharityTypeClothes:
					buttonClothes.selected = YES;
					break;
				case CharityTypeSmile:
					buttonSmile.selected = YES;
					break;
				case CharityTypeOther:
					buttonOther.selected = YES;
					break;
				default:
					break;
			}
		}
		
		
		CGFloat scrollPos = [[dateTable cellForRowAtIndexPath:indexPath] frame].origin.y - [self tableView:dateTable heightForHeaderInSection:[indexPath section]];
		[UIView beginAnimations:nil context:dateTable];
		[UIView setAnimationDelegate:self];
		[self displayModalView];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[[self dateTable] setContentOffset:CGPointMake(0, scrollPos) animated:NO];
		[UIView commitAnimations];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"CharityCell";
    
    BACharityCell *cell = (BACharityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BACharityCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
    }
	
	if(indexPath.row == 0 && indexPath.section == 0) {
		[cell setIsToday:[NSNumber numberWithBool:YES]];
	} else {
		[cell setIsToday:[NSNumber numberWithBool:NO]];		
	}
	
	NSDate *cellDate = [self dateForIndexPath:indexPath];
	[cell setCharities:[[self dayForIndexPath:indexPath] sortedCharities]];
	
	[cell setDate:[BALocalizer localizedDay:cellDate]];
	[cell setDay:[BALocalizer localizedWeekday:cellDate]];
	
    return cell;
}

- (IBAction)doneAction:(id)sender
{
	
	NSSet *currentCharities = [[self dayForIndexPath:[dateTable indexPathForSelectedRow]] charities];
	for(Charity *charity in currentCharities) {
		[charity deleteCharity];
	}
	
	if(buttonMoney.selected == YES) {
		Charity *newCharity = [[Charity alloc] initAndInsertIntoManagedObjectContext:self.managedObjectContext];
		newCharity.day = [self dayForIndexPath:[dateTable indexPathForSelectedRow]];
		newCharity.type = CharityTypeMoney;
		[newCharity release];
	}
	
	if(buttonEffort.selected == YES) {
		Charity *newCharity = [[Charity alloc] initAndInsertIntoManagedObjectContext:self.managedObjectContext];
		newCharity.day = [self dayForIndexPath:[dateTable indexPathForSelectedRow]];
		newCharity.type = CharityTypeEffort;
		[newCharity release];		
	}
	
	if(buttonFood.selected == YES) {
		Charity *newCharity = [[Charity alloc] initAndInsertIntoManagedObjectContext:self.managedObjectContext];
		newCharity.day = [self dayForIndexPath:[dateTable indexPathForSelectedRow]];
		newCharity.type = CharityTypeFeeding;
		[newCharity release];		
	}
	
	if(buttonClothes.selected == YES) {
		Charity *newCharity = [[Charity alloc] initAndInsertIntoManagedObjectContext:self.managedObjectContext];
		newCharity.day = [self dayForIndexPath:[dateTable indexPathForSelectedRow]];
		newCharity.type = CharityTypeClothes;
		[newCharity release];		
	}
	
	if(buttonSmile.selected == YES) {
		Charity *newCharity = [[Charity alloc] initAndInsertIntoManagedObjectContext:self.managedObjectContext];
		newCharity.day = [self dayForIndexPath:[dateTable indexPathForSelectedRow]];
		newCharity.type = CharityTypeSmile;
		[newCharity release];		
	}
	
	if(buttonOther.selected == YES) {
		Charity *newCharity = [[Charity alloc] initAndInsertIntoManagedObjectContext:self.managedObjectContext];
		newCharity.day = [self dayForIndexPath:[dateTable indexPathForSelectedRow]];
		newCharity.type = CharityTypeOther;
		[newCharity release];		
	}
	
	[self setTimePeriod:numberOfDays];
	[dateTable reloadData];	
	
	[self toggleModalView:nil];
}

- (IBAction)enableMoney:(id)sender
{
	if(buttonMoney.selected) {
		buttonMoney.selected = NO;
	} else {
		buttonMoney.selected = YES;
	}
}

- (IBAction)enableEffort:(id)sender
{
	if(buttonEffort.selected) {
		buttonEffort.selected = NO;
	} else {
		buttonEffort.selected = YES;
	}
}

- (IBAction)enableFood:(id)sender
{
	if(buttonFood.selected) {
		buttonFood.selected = NO;
	} else {
		buttonFood.selected = YES;
	}
}

- (IBAction)enableClothes:(id)sender
{
	if(buttonClothes.selected) {
		buttonClothes.selected = NO;
	} else {
		buttonClothes.selected = YES;
	}
}

- (IBAction)enableSmile:(id)sender
{
	if(buttonSmile.selected) {
		buttonSmile.selected = NO;
	} else {
		buttonSmile.selected = YES;
	}
}

- (IBAction)enableOther:(id)sender
{
	if(buttonOther.selected) {
		buttonOther.selected = NO;
	} else {
		buttonOther.selected = YES;
	}
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
    [super dealloc];
}

@end
