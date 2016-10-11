//
//  BAQuranSurahSelector.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 5/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAQuranSurahSelector.h"
#import "BAQamarDeenAppDelegate.h"
#import "BASurahCell.h"
#import "Reading.h"

@implementation BAQuranSurahSelector

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[viewTitle setText:[BALocalizer localizedString:@"SurahSelectorTitle"]];
	[cancelButton setTitle:[BALocalizer localizedString:@"PickerCancel"] forState:UIControlStateNormal];
	[doneButton setTitle:[BALocalizer localizedString:@"PickerDone"] forState:UIControlStateNormal];
	
	NSString *surahPlist = [[QDAppDelegate userSettings] boolForKey:@"ArabicMode"] ? @"ArabicSurahs" : @"Surahs";
	surahs = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:surahPlist ofType:@"plist"]];
	juz = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Juz" ofType:@"plist"]];
	checkedSurahs = [[NSMutableArray alloc] initWithCapacity:114];
	
	numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	NSArray *currentReadings = [delegate currentExceptionalReadings];
	for(Reading *reading in currentReadings) {
		[checkedSurahs addObject:reading.endSurah];
	}
	
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
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if([checkedSurahs containsObject:[NSNumber numberWithInt:[self surahIndexForIndexPath:indexPath]+1]]) {
		[checkedSurahs removeObject:[NSNumber numberWithInt:[self surahIndexForIndexPath:indexPath]+1]];
		BASurahCell *cell = (BASurahCell *)[tableView cellForRowAtIndexPath:indexPath];
		[cell setIsChecked:NO];
	} else {
		[checkedSurahs addObject:[NSNumber numberWithInt:[self surahIndexForIndexPath:indexPath]+1]];
		BASurahCell *cell = (BASurahCell *)[tableView cellForRowAtIndexPath:indexPath];
		[cell setIsChecked:YES];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	NSString *CellIdentifier = @"SurahCell";
    
    BASurahCell *cell = (BASurahCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[BASurahCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
    }
	
	[cell setSurah:[NSString stringWithFormat:@"%@. %@",
					[BALocalizer localizedInteger:[self surahIndexForIndexPath:indexPath]+1],
					[[surahs objectAtIndex:[self surahIndexForIndexPath:indexPath]] objectForKey:@"Name"]
				]
	 ];
	
	
	if([checkedSurahs containsObject:[NSNumber numberWithInt:[self surahIndexForIndexPath:indexPath]+1]]) {
		[cell setIsChecked:YES];
	} else {
		[cell setIsChecked:NO];		
	}
	
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [juz count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[juz objectAtIndex:section] intValue];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{	
	NSMutableArray *titles = [NSMutableArray arrayWithCapacity:30];
	for (NSInteger i = 1; i <= 30; i++)
	{
		[titles addObject:[BALocalizer localizedInteger:i]];
	}

	return [NSArray arrayWithArray:titles];
}

- (int)surahIndexForIndexPath:(NSIndexPath *)indexPath
{
	int surahIndex = indexPath.row;
	int i;
	
	for(i = 0; i < indexPath.section; i++) {
		surahIndex += [[juz objectAtIndex:i] intValue];
	}
	
	return surahIndex;
}

- (IBAction)selectorDone:(id)sender
{
	//save exceptional readings
	[self.delegate saveExceptionalReadings:checkedSurahs];
	
	[self.delegate refreshTable];
	
	[[QDAppDelegate navigationController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectorCancel:(id)sender
{
	[self.delegate refreshTable];

	[[QDAppDelegate navigationController] dismissModalViewControllerAnimated:YES];	
}

// override to allow orientations other than the default portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait); // support only portrait
}


- (void)dealloc {
	[numberFormatter release];
	[surahs release];
	[checkedSurahs release];
    [super dealloc];
}


@end
