//
//  BAQuranViewController.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/2/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAQuranViewController.h"
#import "BAQuranCell.h"
#import "Reading.h"

@implementation BAQuranViewController


- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    if ((self = [super initWithNibName:nibName bundle:nibBundle])) {
		// Custom initialization
		self.title = [BALocalizer localizedString:@"QuranTab"];
		self.tabBarItem.image = [UIImage imageNamed:@"tabbar-quran.png"];
    }
    return self;
}


- (void)viewDidLoad 
{
	tableBgFilename = @"quran-tablebg.png";
	tableFooterFilename = @"quran-tablefooter.png";
	tableFooterSelectedFilename = @"quran-tablefooter-selected.png";
	
	surahs = nil;

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
	self.title = [BALocalizer localizedString:@"QuranTab"];
	
	[modeControl setTitle:[BALocalizer localizedString:@"DailyMode"] forSegmentAtIndex:0];
	[modeControl setTitle:[BALocalizer localizedString:@"ExtraMode"] forSegmentAtIndex:1];
	[quranHeader setText:[BALocalizer localizedString:@"DailyReadings"]];
	[quranAyahHeader setText:[BALocalizer localizedString:@"DailyReadingsAyah"]];
	[pickerInstructions setText:[BALocalizer localizedString:@"PickerInstructions"]];
	
	[pickerCancel setTitle:[BALocalizer localizedString:@"PickerCancel"] forState:UIControlStateNormal];
	[pickerNone setTitle:[BALocalizer localizedString:@"PickerNone"] forState:UIControlStateNormal];
	[pickerDone setTitle:[BALocalizer localizedString:@"PickerDone"] forState:UIControlStateNormal];
	
	if(surahs != nil) {
		[surahs release];
		surahs = nil;
	}
	
	NSString *surahPlist = [[QDAppDelegate userSettings] boolForKey:@"ArabicMode"] ? @"ArabicSurahs" : @"Surahs";
	surahs = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:surahPlist ofType:@"plist"]];

	[dailyPicker reloadComponent:0];
	[dailyPicker reloadComponent:1];
}

- (IBAction)toggleMode:(id)sender {
	if(modeControl.selectedSegmentIndex == 0) {
		[quranHeader setText:[BALocalizer localizedString:@"DailyReadings"]];
		[quranAyahHeader setText:[BALocalizer localizedString:@"DailyReadingsAyah"]];
		[dateTable reloadData];
	} else {
		[quranHeader setText:[BALocalizer localizedString:@"ExtraReadings"]];	
		[quranAyahHeader setText:@""];
		[dateTable reloadData];
	}
}

- (void)logFromUrlForSurah:(int)surah andAyah:(int)ayah
{
	if(surah >= 1 && surah <= 604) {
		int surahAyahCount =  [[[surahs objectAtIndex:surah-1] objectForKey:@"Ayahs"] intValue];
		if(ayah >= 1 && ayah <= surahAyahCount) {
			if(ayah == surahAyahCount) {
				logSurah = surah;
				logAyah = ayah;
				
				// daily or extra?
				UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" 
																		 delegate:self 
																cancelButtonTitle:[BALocalizer localizedString:@"PickerCancel"]
														   destructiveButtonTitle:nil 
																otherButtonTitles:[BALocalizer localizedString:@"Log as Daily"], [BALocalizer localizedString:@"Log as Extra"], nil];
				[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
				[actionSheet showInView:self.parentViewController.view];
				[actionSheet release];				
			} else {
				// daily
				modeControl.selectedSegmentIndex = 0;
				[self logDailySurah:surah andAyah:ayah];
			}
		}
	}
}

- (void)logDailySurah:(int)surah andAyah:(int)ayah
{
	Reading *readingEntry = [[self dayForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] dailyReading];
	
	if(readingEntry == nil) {
		readingEntry = [[[Reading alloc] initAndInsertIntoManagedObjectContext:self.managedObjectContext] autorelease];
		readingEntry.day = [self dayForIndexPath:[dateTable indexPathForSelectedRow]];
	}
	
	readingEntry.startSurah = [NSNumber numberWithInt:1];
	readingEntry.startAyah = [NSNumber numberWithInt:0];
	readingEntry.endSurah = [NSNumber numberWithInt:surah];
	readingEntry.endAyah = [NSNumber numberWithInt:ayah];
	readingEntry.isExceptional = [NSNumber numberWithBool:NO];
	
	Reading *previousReading = [Reading previousReadingFromDate:[[self dayForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] gregorianDate] WithManagedObjectContext:self.managedObjectContext];
	if(previousReading != nil) {
		readingEntry.startSurah = previousReading.endSurah;
		readingEntry.startAyah = previousReading.endAyah;
	}
	
	Reading *nextReading = [Reading nextReadingFromDate:[[self dayForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] gregorianDate] WithManagedObjectContext:self.managedObjectContext];
	if(nextReading != nil) {
		nextReading.startSurah = readingEntry.endSurah;
		nextReading.startAyah = readingEntry.endAyah;
	}
	
	[self setTimePeriod:numberOfDays];
	[dateTable reloadData];	
}

- (void)logExtraSurah:(int)surah
{
	BOOL alreadyLogged = NO;
	
	NSArray *currentReadings = [[self dayForIndexPath:[dateTable indexPathForSelectedRow]] exceptionalReadings];
	for(Reading *reading in currentReadings) {
		if([reading.startSurah intValue] == surah) {
			alreadyLogged = YES;
		}
	}
	
	if(!alreadyLogged) {
		Reading *newExceptional = [[Reading alloc] initAndInsertIntoManagedObjectContext:self.managedObjectContext];
		newExceptional.day = [self dayForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
		newExceptional.isExceptional = [NSNumber numberWithBool:YES];
		newExceptional.startSurah = [NSNumber numberWithInt:surah];
		newExceptional.endSurah = [NSNumber numberWithInt:surah];
		newExceptional.startAyah = [NSNumber numberWithInt:1];
		newExceptional.endAyah = [[surahs objectAtIndex:surah-1] objectForKey:@"Ayahs"];
		[newExceptional release];
		
		[self setTimePeriod:numberOfDays];
		[dateTable reloadData];			
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	if(modeControl.selectedSegmentIndex == 0) 
	{
		CGPoint contentViewTouchPoint = [[tableView cellForRowAtIndexPath:indexPath] convertPoint:touchPoint fromView:tableView];

		if (![self modalViewIsToggled])
		{
			if(contentViewTouchPoint.x > 250 && [[self dayForIndexPath:indexPath] dailyReading] != nil) {
				
				NSString *quranApp;
				switch ([[[BAQamarDeenAppDelegate sharedDelegate] userSettings] integerForKey:@"QuranApp"]) {
					case 3:
						quranApp = @"Al Mus'haf";
						break;
					case 2:
						quranApp = @"iQuran";
						break;
					case 1:
					default:
						if([QDAppDelegate isRunningOnIpad]) {
							quranApp = @"Quran Reader HD";
						} else {
							quranApp = @"Quran Reader";
						}
						
						break;
						break;
				}
				
				UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" 
																		 delegate:self 
																cancelButtonTitle:[BALocalizer localizedString:@"PickerCancel"]
														   destructiveButtonTitle:nil 
																otherButtonTitles:[NSString stringWithFormat:[BALocalizer localizedString:@"QuranAction"], quranApp], nil];
				[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
				[actionSheet showInView:self.parentViewController.view];
				[actionSheet release];
				
			} else {
				
				[tableView setScrollEnabled:NO];
				
				CGFloat scrollPos = [[dateTable cellForRowAtIndexPath:indexPath] frame].origin.y - [self tableView:dateTable heightForHeaderInSection:[indexPath section]];
				[UIView beginAnimations:nil context:dateTable];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
				[self displayModalView];				
				[[self dateTable] setContentOffset:CGPointMake(0, scrollPos) animated:NO];
				[UIView commitAnimations];
				
				Reading *reading = [[self dayForIndexPath:indexPath] dailyReading];
				
				if(reading == nil) {
					reading = [Reading previousReadingFromDate:[[self dayForIndexPath:indexPath] gregorianDate] WithManagedObjectContext:self.managedObjectContext];
				}
				
				if(reading != nil) {
					[dailyPicker selectRow:[reading.endSurah intValue]-1 inComponent:0 animated:NO];
					[dailyPicker reloadComponent:1];
					[dailyPicker selectRow:[reading.endAyah intValue]-1 inComponent:1 animated:NO];
				} else {
					[dailyPicker selectRow:0 inComponent:0 animated:NO];
					[dailyPicker reloadComponent:1];
					[dailyPicker selectRow:0 inComponent:1 animated:NO];
				}
			}
		}
	} else {
		BAQamarDeenAppDelegate *appDelegate = [BAQamarDeenAppDelegate sharedDelegate];
		BAQuranSurahSelector *quranSurahSelector = [[[BAQuranSurahSelector alloc] initWithNibName:@"BAQuranSurahSelector" bundle:nil] autorelease];
		quranSurahSelector.delegate = self;
		[quranSurahSelector setHidesBottomBarWhenPushed:YES];
		[appDelegate.navigationController presentModalViewController:quranSurahSelector animated:YES];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

	if([actionSheet numberOfButtons] == 2) {
	
		if(buttonIndex == 0) {
			Reading *reading = [[self dayForIndexPath:[dateTable indexPathForSelectedRow]] dailyReading];
			
			int appMode = [[[BAQamarDeenAppDelegate sharedDelegate] userSettings] integerForKey:@"QuranApp"];
			if(appMode == 3) {
					NSURL *mushafURL = [NSURL URLWithString:[NSString stringWithFormat:@"mushaf://?sura=%i&ayah=%i",[reading.endSurah intValue],[reading.endAyah intValue]]];
					BOOL mushafInstalled = [[UIApplication sharedApplication] canOpenURL:mushafURL];
					
					if(mushafInstalled) {
						[[UIApplication sharedApplication] openURL:mushafURL];
					} else {
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Not Found" message:@"Unable to open application"
																	   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
						[alert show];	
						[alert release];
						
					}
			} else if(appMode == 2) {
					NSURL *iquranURL = [NSURL URLWithString:[NSString stringWithFormat:@"iquran://%i:%i",[reading.endSurah intValue],[reading.endAyah intValue]]];
					BOOL iquranInstalled = [[UIApplication sharedApplication] canOpenURL:iquranURL];
					
					if(iquranInstalled) {
						[[UIApplication sharedApplication] openURL:iquranURL];
					} else {
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Not Found" message:@"Unable to open application"
																	   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
						[alert show];	
						[alert release];
						
					}
			} else {
				
				if ([QDAppDelegate isRunningOnIpad])
				{
					NSURL *qrhdURL = [NSURL URLWithString:[NSString stringWithFormat:@"quranreaderhd://open?surah=%i&ayah=%i",[reading.endSurah intValue],[reading.endAyah intValue]]];
					BOOL qrhdInstalled = [[UIApplication sharedApplication] canOpenURL:qrhdURL];
									
					if(qrhdInstalled) {
						[[UIApplication sharedApplication] openURL:qrhdURL];
					} else {
						[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/quran-reader-hd/id385432976?mt=8"]];
					}
				}
				else 
				{
					NSURL *qrURL = [NSURL URLWithString:[NSString stringWithFormat:@"quranreader://open?surah=%i&ayah=%i",[reading.endSurah intValue],[reading.endAyah intValue]]];
					BOOL qrInstalled = [[UIApplication sharedApplication] canOpenURL:qrURL];
					
					if(qrInstalled) {
						[[UIApplication sharedApplication] openURL:qrURL];
					} else {
						[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/quran-reader/id305902828&mt=8"]];
					}
				}	
			}
		}
			
		[dateTable deselectRowAtIndexPath:[dateTable indexPathForSelectedRow] animated:NO];
	} else if([actionSheet numberOfButtons] == 3) {
		if(buttonIndex == 0) {
			modeControl.selectedSegmentIndex = 0;
			[self logDailySurah:logSurah andAyah:logAyah];
		} else if(buttonIndex == 1) {
			modeControl.selectedSegmentIndex = 1;
			[self logExtraSurah:logSurah];
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"QuranCell";
    
    BAQuranCell *cell = (BAQuranCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BAQuranCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
    }
		
	if(indexPath.row == 0 && indexPath.section == 0) {
		[cell setIsToday:[NSNumber numberWithBool:YES]];
	} else {
		[cell setIsToday:[NSNumber numberWithBool:NO]];		
	}
	
	NSDate *cellDate = [self dateForIndexPath:indexPath];
	[cell setDate:[BALocalizer localizedDay:cellDate]];
	[cell setDay:[BALocalizer localizedWeekday:cellDate]];
	
	NSString *surah = nil;
	NSString *ayah = nil;
	NSString *read = nil;
	
	if(modeControl.selectedSegmentIndex == 0) {
		Reading *reading = [[self dayForIndexPath:indexPath] dailyReading];
		if(reading != nil) {
			surah = [[surahs objectAtIndex:[[reading endSurah] intValue]-1] objectForKey:@"Name"];
			ayah = [BALocalizer localizedNumber:[reading endAyah]];
			int ayahDifference = [Reading ayahDifferenceBetweenAyah:[reading.startAyah intValue] 
															   ofSurah:[reading.startSurah intValue]
															   andAyah:[reading.endAyah intValue]
															   ofSurah:[reading.endSurah intValue]
														withSurahArray:surahs];

			ayahDifference = ayahDifference < 1 ? 0 : ayahDifference;
			read = [BALocalizer localizedInteger:ayahDifference];
		}
		
		[cell setSurah:surah andAyah:ayah andNumberRead:read];
		[cell setExceptionalReading:nil];
	} else {
		
		NSString *exceptionalReadingSurahs = nil;
		
		NSArray *exceptionalReadings = [[self dayForIndexPath:indexPath] exceptionalReadings];
		for (Reading *exceptionalReading in exceptionalReadings) {
			
			if(exceptionalReadingSurahs == nil) {
				exceptionalReadingSurahs = [NSString stringWithFormat:@"%@",
												[[surahs objectAtIndex:[[exceptionalReading endSurah] intValue]-1] objectForKey:@"Name"]
											];
			} else {
				exceptionalReadingSurahs = [exceptionalReadingSurahs stringByAppendingFormat:[BALocalizer localizedString:@"ExtraSurahListing"],
												[[surahs objectAtIndex:[[exceptionalReading endSurah] intValue]-1] objectForKey:@"Name"]
											];
			}
		}

		[cell setExceptionalReading:exceptionalReadingSurahs];
		[cell setSurah:nil andAyah:nil andNumberRead:nil];
	}

    return cell;
}

- (IBAction)setDailySurah:(id)sender
{	
	Reading *readingEntry = [[self dayForIndexPath:[dateTable indexPathForSelectedRow]] dailyReading];
	
	if(readingEntry == nil) {
		readingEntry = [[[Reading alloc] initAndInsertIntoManagedObjectContext:self.managedObjectContext] autorelease];
		readingEntry.day = [self dayForIndexPath:[dateTable indexPathForSelectedRow]];
	}

	readingEntry.startSurah = [NSNumber numberWithInt:1];
	readingEntry.startAyah = [NSNumber numberWithInt:0];
	readingEntry.endSurah = [NSNumber numberWithInt:[dailyPicker selectedRowInComponent:0]+1];
	readingEntry.endAyah = [NSNumber numberWithInt:[dailyPicker selectedRowInComponent:1]+1];
	readingEntry.isExceptional = [NSNumber numberWithBool:NO];
	
	Reading *previousReading = [Reading previousReadingFromDate:[[self dayForIndexPath:[dateTable indexPathForSelectedRow]] gregorianDate] WithManagedObjectContext:self.managedObjectContext];
	if(previousReading != nil) {
		readingEntry.startSurah = previousReading.endSurah;
		readingEntry.startAyah = previousReading.endAyah;
	}
	
	Reading *nextReading = [Reading nextReadingFromDate:[[self dayForIndexPath:[dateTable indexPathForSelectedRow]] gregorianDate] WithManagedObjectContext:self.managedObjectContext];
	if(nextReading != nil) {
		nextReading.startSurah = readingEntry.endSurah;
		nextReading.startAyah = readingEntry.endAyah;
	}
	
	[self toggleModalView:nil];
	
	[self setTimePeriod:numberOfDays];
	[dateTable reloadData];
}

- (IBAction)deleteDailySurah:(id)sender
{
	Reading *readingEntry = [[self dayForIndexPath:[dateTable indexPathForSelectedRow]] dailyReading];
	
	if(readingEntry != nil) {
		
		Reading *nextReading = [Reading nextReadingFromDate:[[self dayForIndexPath:[dateTable indexPathForSelectedRow]] gregorianDate] WithManagedObjectContext:self.managedObjectContext];
		[readingEntry deleteReading];
		
		if(nextReading != nil) {
			nextReading.startSurah = [NSNumber numberWithInt:1];
			nextReading.startAyah = [NSNumber numberWithInt:0];
			
			Reading *previousReading = [Reading previousReadingFromDate:[[self dayForIndexPath:[dateTable indexPathForSelectedRow]] gregorianDate] WithManagedObjectContext:self.managedObjectContext];
			if(previousReading != nil) {
				nextReading.startSurah = previousReading.endSurah;
				nextReading.startAyah = previousReading.endAyah;
			}
		}
		
		
		[self setTimePeriod:numberOfDays];
		[dateTable reloadData];	
	}
	
	[self toggleModalView:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
	if(component == 1) {
		return [[[surahs objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"Ayahs"] intValue];
	}
	
	return [surahs count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component 
{
	return component == 0 ? 190 : 130;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
			viewForRow:(NSInteger)row
		  forComponent:(NSInteger)component
		   reusingView:(UIView *)view {
	
	UILabel *pickerLabel = (UILabel *)view;
	
	if (pickerLabel == nil) {
		CGRect frame;
		if(component == 0) {
			frame = CGRectMake(30.0, 0.0, 160, 32);
		} else {
			frame = CGRectMake(30.0, 0.0, 100, 32);
		}
		pickerLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
		[pickerLabel setTextAlignment:UITextAlignmentLeft];
		[pickerLabel setBackgroundColor:[UIColor clearColor]];
		[pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
	}
	
	if(component == 0) {
		[pickerLabel setText:[NSString stringWithFormat:[BALocalizer localizedString:@"PickerSurah"],[BALocalizer localizedInteger:row+1],[[surahs objectAtIndex:row] objectForKey:@"Name"]]];
	} else {
		[pickerLabel setText:[NSString stringWithFormat:[BALocalizer localizedString:@"PickerAyah"],[BALocalizer localizedInteger:row+1]]];
	}
	
	return pickerLabel;
	
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
	if(component == 0) {
		[pickerView reloadComponent:1];
		[pickerView selectRow:0 inComponent:1 animated:NO];
	}
}





-(void)refreshTable
{
	[dateTable deselectRowAtIndexPath:[dateTable indexPathForSelectedRow] animated:NO];
	[self setTimePeriod:numberOfDays];
	[dateTable reloadData];	
}

- (NSArray *)currentExceptionalReadings
{
	return [[self dayForIndexPath:[dateTable indexPathForSelectedRow]] exceptionalReadings];
}

- (void)saveExceptionalReadings:(NSArray *)readings
{
	NSArray *currentReadings = [[self dayForIndexPath:[dateTable indexPathForSelectedRow]] exceptionalReadings];
	for(Reading *reading in currentReadings) {
		[reading deleteReading];
	}
	
	for(NSNumber *surahNumber in readings) {
		Reading *newExceptional = [[Reading alloc] initAndInsertIntoManagedObjectContext:self.managedObjectContext];
		newExceptional.day = [self dayForIndexPath:[dateTable indexPathForSelectedRow]];
		newExceptional.isExceptional = [NSNumber numberWithBool:YES];
		newExceptional.startSurah = surahNumber;
		newExceptional.endSurah = surahNumber;
		newExceptional.startAyah = [NSNumber numberWithInt:1];
		newExceptional.endAyah = [[surahs objectAtIndex:[surahNumber intValue]-1] objectForKey:@"Ayahs"];
		[newExceptional release];
	}
}



// override to allow orientations other than the default portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait); // support only portrait
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
	[surahs release];
    [super dealloc];
}

@end
