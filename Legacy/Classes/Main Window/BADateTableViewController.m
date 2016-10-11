//
//  BADateTableViewController.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 5/2/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BADateTableViewController.h"
#import "BATouchView.h"
#import "BADateTableSectionHeader.h"

@implementation BADateTableViewController

@synthesize managedObjectContext, dateTable, touchPoint, headerViewCache, sectionTitles;

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.headerViewCache = [[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null], nil];
	self.sectionTitles = [[NSMutableArray alloc] initWithCapacity:2];
	
	// Set coredata context
	BAQamarDeenAppDelegate *appDelegate = [BAQamarDeenAppDelegate sharedDelegate];
	self.managedObjectContext = appDelegate.managedObjectContext;
	
	self.dateTable.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.dateTable.backgroundColor = [UIColor grayColor];
	tableDates = [[NSMutableArray arrayWithCapacity:30] retain];
	
	gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	numberOfDays = 30;
	
	[self setTimePeriod:numberOfDays];

	self.dateTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:tableBgFilename]];
	
	UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
	moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[moreButton setFrame:CGRectMake(0, 0, 320, 66)];
	[moreButton setImage:[UIImage imageNamed:tableFooterFilename] forState:UIControlStateNormal];
	[moreButton setImage:[UIImage imageNamed:tableFooterSelectedFilename] forState:UIControlStateHighlighted];
	[moreButton setImage:[UIImage imageNamed:tableFooterSelectedFilename] forState:UIControlStateSelected];
	[moreButton addTarget:self action:@selector(showMoreRows) forControlEvents:UIControlEventTouchUpInside];
	[tableFooterView addSubview:moreButton];
	
	UILabel *showMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 280, 15)];
	showMoreLabel.textAlignment = UITextAlignmentCenter;
	showMoreLabel.text = [BALocalizer localizedString:@"ShowMoreButton"];
	showMoreLabel.font = [UIFont systemFontOfSize:14];
	showMoreLabel.textColor = [UIColor darkGrayColor];
	showMoreLabel.backgroundColor = [UIColor clearColor];
	[tableFooterView addSubview:showMoreLabel];
	[showMoreLabel release];
	
	self.dateTable.tableFooterView = tableFooterView;
	[tableFooterView release];
	
	BATouchView *touchView = [[[BATouchView alloc] initWithFrame:[self.dateTable frame]] autorelease];
	[touchView setController:self];
	[touchView setTargetView:self.dateTable];
	[[self view] addSubview:touchView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(requiresRefresh)
												 name:NSCurrentLocaleDidChangeNotification 
											   object:NULL];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(requiresRefresh)
												 name:UIApplicationSignificantTimeChangeNotification 
											   object:NULL];
}

- (void)requiresRefresh
{
	[numberFormatter release];
	numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	[self setTimePeriod:numberOfDays];
	[self.dateTable reloadData];
	if([self modalViewIsToggled]) {
		[self toggleModalView:nil];
	}
}

- (void)setTimePeriod:(int)numOfDays
{	
	NSDate *today;
	today = [Day midnightForDate:[NSDate date]];
	
	NSDate *earlier = [[Day midnightForDate:[NSDate date]] addTimeInterval:(numOfDays-1)*-86400];
	
	NSArray *fectchedDays = [[NSArray alloc] initWithArray:[Day daysBetween:[earlier addTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:today]] and:[today addTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:today]] inManagedObjectContext:self.managedObjectContext]];
	
	[tableDates removeAllObjects];
	int currentMonth = [[gregorianCalendar components:(NSMonthCalendarUnit) fromDate:[NSDate date]] month];
	NSMutableArray *monthDates = [NSMutableArray arrayWithCapacity:1];
	int i;
	
	//get months
	for(i = 0; i < numOfDays; i++)
	{
		NSDate *newDate = [Day midnightForDate:[NSDate dateWithTimeIntervalSinceNow:i*-86400]];
		int newMonth = [[gregorianCalendar components:(NSMonthCalendarUnit) fromDate:newDate] month];
		if(newMonth != currentMonth)
		{
			[tableDates addObject:[NSArray arrayWithArray:monthDates]];
			currentMonth = newMonth;
			[monthDates removeAllObjects];
		}
		
		NSMutableArray *dayArray = [[NSMutableArray alloc] initWithCapacity:2];
		[dayArray addObject:newDate];
		
		//if day doesn't exist, create it
		BOOL dayExists = NO;
		for(Day *dayCheck in fectchedDays)
		{
			if([dayCheck.gregorianDate isEqualToDate:[newDate addTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:newDate]]])
			{
				[dayArray addObject:dayCheck];
				dayExists = YES;
			}
		}
		
		if(!dayExists)
		{	
			Day *newDay = [[Day alloc] initAndInsertIntoManagedObjectContext:managedObjectContext];
			newDay.gregorianDate = [newDate addTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:newDate]];
			newDay.hijriDate = [newDate addTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:newDate]];
			[dayArray addObject:newDay];
			[newDay release];
		}
		
		[monthDates addObject:dayArray];
		[dayArray release];
	}
	
	if([monthDates count] > 0)
	{
		[tableDates addObject:monthDates];
	}
	

	
	[fectchedDays release];
	
	[sectionTitles removeAllObjects];
	for (NSArray *tableMonth in tableDates)
	{
		NSDate *sectionMonth = [[tableMonth objectAtIndex:0] objectAtIndex:0];
		[sectionTitles addObject:[[[BAQamarDeenAppDelegate sharedDelegate] monthDateFormatter] stringFromDate:sectionMonth]];
	}
}

- (IBAction)goToToday:(id)sender 
{
	[self.dateTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)showMoreRows 
{
	numberOfDays = numberOfDays + 15;
	[self setTimePeriod:numberOfDays];
	[self.dateTable reloadData];
}

- (Day *)dayForIndexPath:(NSIndexPath *)indexPath
{
	return [[[tableDates objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1];
}

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath
{
	return [[[tableDates objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [tableDates count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[tableDates objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{	
	BADateTableSectionHeader *header;
	while ((BADateTableSectionHeader*)[NSNull null] == (header = [headerViewCache objectAtIndex:section%2]))
	{
		BADateTableSectionHeader *newHeader = [[[BADateTableSectionHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 35)] autorelease];
		[newHeader setBackgroundColor:[UIColor clearColor]];
		[headerViewCache replaceObjectAtIndex:section%2 withObject:newHeader];
	}
	
	if (![[header month] isEqualToString:[sectionTitles objectAtIndex:section]])
	{
		[header setMonth:[sectionTitles objectAtIndex:section]];
		[header setNeedsDisplay];
	}
	
    return header;
}

- (BOOL)modalViewIsToggled
{
	return !(modalView.frame.origin.y == 411);
}

- (void)displayModalView
{
	CGRect frame = [modalView frame];	
	frame.origin.y = 107;
	[modalView setFrame:frame];
}

- (IBAction)toggleModalView:(id)sender
{
	[UIView beginAnimations:@"ModalViewSlide" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	CGRect frame = [modalView frame];
	
	if ([self modalViewIsToggled])
	{
		frame.origin.y = 411;
		[dateTable setScrollEnabled:YES];
		[dateTable deselectRowAtIndexPath:[dateTable indexPathForSelectedRow] animated:NO];
	}
	else
	{
		frame.origin.y = 107;
		[dateTable setScrollEnabled:NO];
	}
	
	[modalView setFrame:frame];
	[UIView commitAnimations];
}

- (void)reloadTable
{
	[dateTable reloadData];
}

- (void)localizeUI {}

- (void)dealloc 
{
	[headerViewCache release];
	[sectionTitles release];
	[gregorianCalendar release];
	[numberFormatter release];
	[tableDates release];
	[moreButton release];
	[dateTable release];
    [super dealloc];
}

@end