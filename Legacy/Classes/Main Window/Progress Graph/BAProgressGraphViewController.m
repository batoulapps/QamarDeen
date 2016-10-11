//
//  BAProgressGraphViewController.m
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAProgressGraphViewController.h"
#import "BAQamarDeenAppDelegate.h"
#import "Day.h"
#import "Fast.h"
#import "Charity.h"
#import	"Prayer.h"
#import "Reading.h"
#import "BAPointCalculator.h"

@implementation BAProgressGraphViewController

// the designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
        self.wantsFullScreenLayout = NO; // we don't want to overlap the status bar.
        
		// when presented, we want to display using a cross dissolve
		self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad 
{
	BAQamarDeenAppDelegate *appDelegate = [BAQamarDeenAppDelegate sharedDelegate];
	isSevenDay = [[appDelegate userSettings] boolForKey:@"IsSevenDay"];
	
	sparkline = [[CKSparkline alloc] initWithFrame:CGRectMake(25, 0, 430, 172)];
	sparkline.lineColor = [UIColor colorWithRed:85.0/255.0 green:124.0/255.0 blue:66.0/255.0 alpha:1];
    [graphView addSubview:sparkline];
	
	managedObjectContext = [[BAQamarDeenAppDelegate sharedDelegate] managedObjectContext];
	
	dataType = DataCombined;
	graphPeriod = Period_1m;
	days = [[NSMutableArray arrayWithCapacity:30] retain];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	if(	[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"]) {
		[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ar"] autorelease]];
	}
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	numberFormatter = [[NSNumberFormatter alloc] init];
	if(	[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"]) {
		[numberFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ar"] autorelease]];
	}
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMaximumFractionDigits:2];
	
	[self setPeriod_1m:nil];
	[self setTab_combined:nil];
		
	[graphScrollView setContentSize:CGSizeMake(960, 175)];
	
	graphView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 175)];
	graphBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ls-bg-1m.png"]];
	graphBg.center = CGPointMake(240, 100);
	[graphView addSubview:graphBg];
	dataView = [[UIView alloc] initWithFrame:CGRectMake(480, 0, 480, 175)];
	[graphScrollView addSubview:graphView];
	[graphScrollView addSubview:dataView];
	
	[self plotGraph];


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
	[self localizeUI];
	[self update];	
}

- (void)localizeUI
{
	[dateFormatter release];
	dateFormatter = [[NSDateFormatter alloc] init];
	if(	[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"]) {
		[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ar"] autorelease]];
	}
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	[numberFormatter release];
	numberFormatter = [[NSNumberFormatter alloc] init];
	if(	[[QDAppDelegate userSettings] boolForKey:@"ArabicMode"]) {
		[numberFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ar"] autorelease]];
	}
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMaximumFractionDigits:2];
}

- (void)viewWillAppear:(BOOL)animated
{
	
	switch ([[[BAQamarDeenAppDelegate sharedDelegate] tabBarController] selectedIndex]) {
		case 0:
			dataType = DataPrayer;
			break;
		case 1:
			dataType = DataQuran;
			break;
		case 2:
			dataType = DataCharity;
			break;
		case 3:
			dataType = DataFasting;
			break;
		case 4:	
		default:
			dataType = DataCombined;
			break;
	}

	[self update];
}

- (void)update
{
	[self setButtonStates];
	[self pullData];
	[self plotGraph];
	[self updateChart];
}

- (void)setButtonStates
{
	combinedTab.enabled = dataType == DataCombined ? NO : YES;
	prayerTab.enabled = dataType == DataPrayer ? NO : YES;
	quranTab.enabled = dataType == DataQuran ? NO : YES;
	charityTab.enabled = dataType == DataCharity ? NO : YES;
	fastingTab.enabled = dataType == DataFasting ? NO : YES;
	
	periodButton_1w.enabled = graphPeriod == Period_1w ? NO : YES;
	periodButton_2w.enabled = graphPeriod == Period_2w ? NO : YES;
	periodButton_1m.enabled = graphPeriod == Period_1m ? NO : YES;
	periodButton_2m.enabled = graphPeriod == Period_2m ? NO : YES;
	periodButton_3m.enabled = graphPeriod == Period_3m ? NO : YES;
	periodButton_6m.enabled = graphPeriod == Period_6m ? NO : YES;
	periodButton_1y.enabled = graphPeriod == Period_1y ? NO : YES;
	periodButton_all.enabled = graphPeriod == Period_all ? NO : YES;
}

- (void)pullData
{
	NSTimeInterval offset = ((double)graphPeriod-1) * -86400;
	NSDate *today = [Day midnightForDate:[NSDate date]];
	NSDate *earlier = (graphPeriod > 0) ? [[Day midnightForDate:[NSDate date]] addTimeInterval:offset] : [NSDate distantPast];
	
	[days removeAllObjects];
	[days addObjectsFromArray:[Day daysBetween:[earlier addTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:earlier]] and:[today addTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:today]] inManagedObjectContext:managedObjectContext]];
	
	[endDate setText:[dateFormatter stringFromDate:[NSDate date]]];
	if([days count] > 0) {
		[beginDate setText:[dateFormatter stringFromDate:[[days objectAtIndex:[days count] - 1] gregorianDate]]];
	} else {
		[beginDate setText:[dateFormatter stringFromDate:[NSDate date]]];	
	}
}

- (void)plotGraph
{
	[sparkline removeFromSuperview];
    [sparkline release];
	
	NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:1];
	
	if (graphPeriod > [days count])
	{
		for (int i = 0; i < graphPeriod - [days count]; i++)
		{
			[dataArray addObject:[NSNumber numberWithInt:0]];
		}
	}
	
	for (int dayIterator = [days count] - 1; dayIterator >= 0; dayIterator--)
	{
		Day *day = [days objectAtIndex:dayIterator];
		
		switch (dataType) {
			case DataCombined:
				[dataArray addObject:[NSNumber numberWithInt:[day prayerPoints]+[day quranPoints]+[day charityPoints]+[day fastingPoints]]];
				break;
			case DataPrayer:
				[dataArray addObject:[NSNumber numberWithInt:[day prayerPoints]]];
				break;
			case DataQuran:
				[dataArray addObject:[NSNumber numberWithInt:[day quranPoints]]];
				break;
			case DataCharity:
				[dataArray addObject:[NSNumber numberWithInt:[day charityPoints]]];
				break;
			case DataFasting:
				[dataArray addObject:[NSNumber numberWithInt:[day fastingPoints]]];
				break;
			default:
				break;
		}
	}
	
	sparkline = [[CKSparkline alloc] initWithFrame:CGRectMake(25, 27, 430, 145)];
	sparkline.lineColor = [UIColor colorWithRed:85.0/255.0 green:124.0/255.0 blue:66.0/255.0 alpha:1];
    sparkline.data = dataArray;
	[dataArray release];
	
    [graphView addSubview:sparkline];
}

- (void)positionName:(NSString *)name total:(NSNumber *)total percent:(NSNumber *)percent asLabelsAtPoint:(CGPoint)point inView:(UIView*)labelView
{
	NSString *totalString = [NSString stringWithFormat:@" (%@) ", [numberFormatter stringFromNumber:total]];
	NSString *percentString;
	if ([percent intValue] < 0)
	{
		percentString = @"";
	}
	else
	{
		percentString = [NSString stringWithFormat:@"%@%%", [numberFormatter stringFromNumber:percent]];
	}
	
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	
	[nameLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
	[totalLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
	[percentLabel setFont:[UIFont systemFontOfSize:15.0]];
	
	[nameLabel setBackgroundColor:[UIColor clearColor]];
	[totalLabel setBackgroundColor:[UIColor clearColor]];
	[percentLabel setBackgroundColor:[UIColor clearColor]];
	
	[nameLabel setTextColor:[UIColor blackColor]];
	[totalLabel setTextColor:[UIColor brownColor]];
	[percentLabel setTextColor:[UIColor grayColor]];
	
	CGSize nameSize = [name sizeWithFont:[UIFont boldSystemFontOfSize:15.0]];
	CGSize totalSize = [totalString sizeWithFont:[UIFont boldSystemFontOfSize:15.0]];
	CGSize percentSize = [percentString sizeWithFont:[UIFont systemFontOfSize:15.0]];
	
	CGRect nameRect = CGRectMake(point.x, point.y, nameSize.width, nameSize.height);
	CGRect totalRect = CGRectMake(nameRect.origin.x + nameSize.width, point.y, totalSize.width, totalSize.height);
	CGRect percentRect = CGRectMake(totalRect.origin.x + totalSize.width, point.y, percentSize.width, percentSize.height);
	
	nameLabel.frame = nameRect;
	totalLabel.frame = totalRect;
	percentLabel.frame = percentRect;
	
	[nameLabel setText:name];
	[totalLabel setText:totalString];
	[percentLabel setText:percentString];
	
	[labelView addSubview:nameLabel];
	[labelView addSubview:totalLabel];
	[labelView addSubview:percentLabel];
	
	[nameLabel release];
	[totalLabel release];
	[percentLabel release];
}

- (void)updateChart
{
	for (UIView *subview in [dataView subviews])
	{
		[subview removeFromSuperview];
	}
	
	int daysWithData = (graphPeriod > [days count]) ? graphPeriod : [days count];
	int daysWithoutFasting = daysWithData - [days count];
	int daysWithoutCharity = daysWithData - [days count];
	int daysWithoutQuran = daysWithData - [days count];
	
	for (Day *day in days)
	{
		if ([day quranPoints] == 0) daysWithoutQuran++;
		if ([day charityPoints] == 0) daysWithoutCharity++;
		if ([day fastingPoints] == 0) daysWithoutFasting++;
	}
	
	NSArray *namesArray;
	NSMutableArray *totalArray = [NSMutableArray new];
	NSMutableArray *percentArray = [NSMutableArray new];
	
	switch (dataType)
	{
		case DataCombined:
			namesArray = [NSArray arrayWithObjects:[BALocalizer localizedString:@"TotalPrayers"],
						  [BALocalizer localizedString:@"TotalReadings"],
						  [BALocalizer localizedString:@"TotalCharity"],
						  [BALocalizer localizedString:@"TotalFasts"],
						  nil];
			break;
		case DataPrayer:
			namesArray = [NSArray arrayWithObjects:[BALocalizer localizedString:@"prayerButtonGroupWithVoluntary"],
						  [BALocalizer localizedString:@"prayerButtonGroup"],
						  [BALocalizer localizedString:@"prayerButtonAloneWithVoluntary"],
						  [BALocalizer localizedString:@"prayerButtonAlone"],
						  [BALocalizer localizedString:@"prayerButtonLate"],
						  [BALocalizer localizedString:@"prayerButtonNone"],
						  nil];
			break;
		case DataQuran:
			namesArray = [NSArray arrayWithObjects:[BALocalizer localizedString:@"ReadingDays"],
						  [BALocalizer localizedString:@"NonReadingDays"],
						  [BALocalizer localizedString:@"AverageAyahPerDay"],
						  nil];
			break;
		case DataCharity:
			namesArray = [NSArray arrayWithObjects:[BALocalizer localizedString:@"CharitableDays"],
						  [BALocalizer localizedString:@"UncharitableDays"],
						  [BALocalizer localizedString:@"CharityMoney"],
						  [BALocalizer localizedString:@"CharityEffort"],
						  [BALocalizer localizedString:@"CharityFood"],
						  [BALocalizer localizedString:@"CharityClothes"],
						  [BALocalizer localizedString:@"CharitySmile"],
						  [BALocalizer localizedString:@"CharityOther"],
						  nil];
			break;
		case DataFasting:
			namesArray = [NSArray arrayWithObjects:[BALocalizer localizedString:@"FastingDays"],
						  [BALocalizer localizedString:@"NonFastingDays"],
						  [BALocalizer localizedString:@"FastingTypeMandatory"],
						  [BALocalizer localizedString:@"FastingTypeVoluntary"],
						  [BALocalizer localizedString:@"FastingTypeReconcile"],
						  [BALocalizer localizedString:@"FastingTypeForgiveness"],
						  [BALocalizer localizedString:@"FastingTypeVow"],
						  nil];
			break;
		default:
			namesArray = [NSArray array];
			break;
	}
		
	double indexOneTotal = 0;
	double indexTwoTotal = 0;
	double indexThreeTotal = 0;
	double indexFourTotal = 0;
	double indexFiveTotal = 0;
	double indexSixTotal = 0;
	double indexSevenTotal = 0;
	double indexEightTotal = 0;
	
	switch (dataType)
	{
		case DataQuran:
			indexOneTotal = daysWithData - daysWithoutQuran;
			indexTwoTotal = daysWithoutQuran;
			break;
		case DataCharity:
			indexOneTotal = daysWithData - daysWithoutCharity;
			indexTwoTotal = daysWithoutCharity;
			break;
		case DataFasting:
			indexOneTotal = daysWithData - daysWithoutFasting;
			indexTwoTotal = daysWithoutFasting;
			break;
		default:
			break;
	}
		
	for (Day *day in days)
	{
		switch (dataType)
		{
			case DataCombined:
				for (Prayer *prayer in [day prayers])
				{
					if ([prayer method] == PrayerMethodExcused || [prayer method] == PrayerMethodNone) continue;
					if (!isSevenDay && [prayer type] == PrayerTypeShuruq) continue;
					if (!isSevenDay && [prayer type] == PrayerTypeQiyam) continue;
					indexOneTotal++;
				}
				indexTwoTotal += [day ayasRead];
				indexThreeTotal += ([day charityPoints] > 0);
				indexFourTotal += ([day fastingType] > 0);
				break;
			case DataPrayer:
				for (Prayer *prayer in [day prayers])
				{
					if (!isSevenDay && [prayer type] == PrayerTypeShuruq) continue;
					if (!isSevenDay && [prayer type] == PrayerTypeQiyam) continue;
					switch ([prayer method]) {
						case PrayerMethodGroupWithVoluntary:
							indexOneTotal++;
							break;
						case PrayerMethodGroup:
							indexTwoTotal++;
							break;
						case PrayerMethodAloneWithVoluntary:
							indexThreeTotal++;
							break;
						case PrayerMethodAlone:
							indexFourTotal++;
							break;
						case PrayerMethodLate:
							indexFiveTotal++;
							break;
						default:
							break;
					}
				}
				break;
			case DataQuran:
				indexThreeTotal += [day ayasRead];
				break;
			case DataCharity:
				for (Charity *charity in [day charities])
				{
					switch ([charity type]) {
						case CharityTypeMoney:
							indexThreeTotal++;
							break;
						case CharityTypeEffort:
							indexFourTotal++;
							break;
						case CharityTypeFeeding:
							indexFiveTotal++;
							break;
						case CharityTypeClothes:
							indexSixTotal++;
							break;
						case CharityTypeSmile:
							indexSevenTotal++;
							break;
						case CharityTypeOther:
							indexEightTotal++;
							break;
						default:
							break;
					}
				}
				break;
			case DataFasting:
				switch ([day fastingType]) {
					case FastingTypeMandatory:
						indexThreeTotal++;
						break;
					case FastingTypeVoluntary:
						indexFourTotal++;
						break;
					case FastingTypeReconcile:
						indexFiveTotal++;
						break;
					case FastingTypeForgiveness:
						indexSixTotal++;
						break;
					case FastingTypeVow:
						indexSevenTotal++;
						break;
					default:
						break;
				}
				break;
			default:
				break;
		}
	}
		
	switch (dataType)
	{
		case DataCombined:
			[percentArray addObject:[NSNumber numberWithInt:-1]];
			[percentArray addObject:[NSNumber numberWithInt:-1]];
			[percentArray addObject:[NSNumber numberWithInt:-1]];
			[percentArray addObject:[NSNumber numberWithInt:-1]];
			[totalArray addObject:[NSNumber numberWithInt:indexOneTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexTwoTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexThreeTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexFourTotal]];
			break;
		case DataPrayer:
			if (indexOneTotal + indexTwoTotal + indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal == 0)
			{
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
			}
			else
			{
				[percentArray addObject:[NSNumber numberWithInt:round(indexOneTotal / (indexOneTotal + indexTwoTotal + indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexTwoTotal / (indexOneTotal + indexTwoTotal + indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexThreeTotal / (indexOneTotal + indexTwoTotal + indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexFourTotal / (indexOneTotal + indexTwoTotal + indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexFiveTotal / (indexOneTotal + indexTwoTotal + indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexSixTotal / (indexOneTotal + indexTwoTotal + indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal) * 100)]];
			}
			[totalArray addObject:[NSNumber numberWithInt:indexOneTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexTwoTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexThreeTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexFourTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexFiveTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexSixTotal]];
			break;
		case DataQuran:
			if (indexOneTotal + indexTwoTotal == 0)
			{
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
			}
			else
			{
				[percentArray addObject:[NSNumber numberWithInt:round(indexOneTotal / (indexOneTotal + indexTwoTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexTwoTotal / (indexOneTotal + indexTwoTotal) * 100)]];
			}
			[percentArray addObject:[NSNumber numberWithInt:-1]];
			[totalArray addObject:[NSNumber numberWithInt:indexOneTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexTwoTotal]];
			[totalArray addObject:[NSNumber numberWithDouble: daysWithData > 0 ? indexThreeTotal / (double)daysWithData : 0]];
			break;
		case DataCharity:
			if (indexOneTotal + indexTwoTotal == 0)
			{
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
			}
			else
			{
				[percentArray addObject:[NSNumber numberWithInt:round(indexOneTotal / (indexOneTotal + indexTwoTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexTwoTotal / (indexOneTotal + indexTwoTotal) * 100)]];
			}
			if (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal + indexEightTotal == 0)
			{
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
			}
			else
			{
				[percentArray addObject:[NSNumber numberWithInt:round(indexThreeTotal / (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal + indexEightTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexFourTotal / (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal + indexEightTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexFiveTotal / (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal + indexEightTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexSixTotal / (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal + indexEightTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexSevenTotal / (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal + indexEightTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexEightTotal / (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal + indexEightTotal) * 100)]];
			}
			[totalArray addObject:[NSNumber numberWithInt:indexOneTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexTwoTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexThreeTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexFourTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexFiveTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexSixTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexSevenTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexEightTotal]];
			break;
		case DataFasting:
			if (indexOneTotal + indexTwoTotal == 0)
			{
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
			}
			else
			{
				[percentArray addObject:[NSNumber numberWithInt:round(indexOneTotal / (indexOneTotal + indexTwoTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexTwoTotal / (indexOneTotal + indexTwoTotal) * 100)]];
			}
			if (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal == 0)
			{
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
				[percentArray addObject:[NSNumber numberWithInt:0]];
			}
			else
			{
				[percentArray addObject:[NSNumber numberWithInt:round(indexThreeTotal / (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexFourTotal / (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexFiveTotal / (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexSixTotal / (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal) * 100)]];
				[percentArray addObject:[NSNumber numberWithInt:round(indexSevenTotal / (indexThreeTotal + indexFourTotal + indexFiveTotal + indexSixTotal + indexSevenTotal) * 100)]];
			}
			[totalArray addObject:[NSNumber numberWithInt:indexOneTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexTwoTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexThreeTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexFourTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexFiveTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexSixTotal]];
			[totalArray addObject:[NSNumber numberWithInt:indexSevenTotal]];
			break;
		default:
			break;
	}
	
	int posY = 10.0;
	CGPoint point;
	
	for (int i = 0; i < [namesArray count]; i++)
	{
		if (i % 2 == 0)
		{
			point = CGPointMake(25.0, posY);
		}
		else
		{
			point = CGPointMake(245.0, posY);
			posY += 40;
		}
		
		[self positionName:[namesArray objectAtIndex:i]	total:[totalArray objectAtIndex:i] percent:[percentArray objectAtIndex:i] asLabelsAtPoint:point inView:dataView];
	}
	[totalArray release];
	[percentArray release];
}
	

- (IBAction)setTab_combined:(id)sender
{
	dataType = DataCombined;
	[self update];
}

- (IBAction)setTab_prayer:(id)sender
{
	dataType = DataPrayer;
	[self update];

}

- (IBAction)setTab_quran:(id)sender
{
	dataType = DataQuran;
	[self update];

}

- (IBAction)setTab_charity:(id)sender
{
	dataType = DataCharity;
	[self update];

}

- (IBAction)setTab_fasting:(id)sender
{
	dataType = DataFasting;
	[self update];

}


- (IBAction)setPeriod_1w:(id)sender
{
	graphPeriod = Period_1w;
	graphBg.image = [UIImage imageNamed:@"ls-bg-1w.png"];
	[self update];
}

- (IBAction)setPeriod_2w:(id)sender
{
	graphPeriod = Period_2w;
	graphBg.image = [UIImage imageNamed:@"ls-bg-2w.png"];
	[self update];
}

- (IBAction)setPeriod_1m:(id)sender
{
	graphPeriod = Period_1m;
	graphBg.image = [UIImage imageNamed:@"ls-bg-1m.png"];
	[self update];
}

- (IBAction)setPeriod_2m:(id)sender
{
	graphPeriod = Period_2m;
	graphBg.image = [UIImage imageNamed:@"ls-bg-2m.png"];
	[self update];
}

- (IBAction)setPeriod_3m:(id)sender
{
	graphPeriod = Period_3m;
	graphBg.image = [UIImage imageNamed:@"ls-bg-3m.png"];
	[self update];
}

- (IBAction)setPeriod_6m:(id)sender
{
	graphPeriod = Period_6m;
	graphBg.image = [UIImage imageNamed:@"ls-bg-6m.png"];
	[self update];
}

- (IBAction)setPeriod_1y:(id)sender
{
	graphPeriod = Period_1y;
	graphBg.image = [UIImage imageNamed:@"ls-bg-1y.png"];
	[self update];
}

- (IBAction)setPeriod_all:(id)sender
{
	graphPeriod = Period_all;
	graphBg.image = [UIImage imageNamed:@"ls-bg-all.png"];
	[self update];	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self updatePageControl];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if(decelerate) return;
	[self updatePageControl];
}

- (void)updatePageControl
{
	if(graphScrollView.contentOffset.x < graphScrollView.contentSize.width/2) {
		[pageControl_1 setImage:[UIImage imageNamed:@"pageCurrent.png"]];
		[pageControl_2 setImage:[UIImage imageNamed:@"pageNormal.png"]];		
	} else {
		[pageControl_1 setImage:[UIImage imageNamed:@"pageNormal.png"]];
		[pageControl_2 setImage:[UIImage imageNamed:@"pageCurrent.png"]];
	}
}

// override to allow orientations other than the default portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
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
    [sparkline release];
	[days release];
	[dateFormatter release];
	[numberFormatter release];
	[graphView release];
	[dataView release];
	[graphBg release];
	
    [super dealloc];
}


@end
