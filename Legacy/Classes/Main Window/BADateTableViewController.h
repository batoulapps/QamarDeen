//
//  BADateTableViewController.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 5/2/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAQamarDeenAppDelegate.h"
#import "Day.h"

@interface BADateTableViewController : UIViewController <UITableViewDelegate>
{
	NSManagedObjectContext *managedObjectContext;
	IBOutlet UIView *modalView;
	IBOutlet UITableView *dateTable;
	NSCalendar *gregorianCalendar;
	NSNumberFormatter *numberFormatter;
	NSMutableArray *tableDates;
	int numberOfDays;
	NSString *tableBgFilename;
	NSString *tableFooterFilename;
	NSString *tableFooterSelectedFilename;
	CGPoint touchPoint;
	UIButton *moreButton;
	NSMutableArray *headerViewCache;
	NSMutableArray *sectionTitles;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UITableView *dateTable;
@property CGPoint touchPoint;
@property (nonatomic, retain) NSMutableArray *headerViewCache;
@property (nonatomic, retain) NSMutableArray *sectionTitles;

- (void)displayModalView;
- (IBAction)goToToday:(id)sender;
- (void)showMoreRows;
- (void)setTimePeriod:(int)days;
- (void)requiresRefresh;
- (IBAction)toggleModalView:(id)sender;
- (BOOL)modalViewIsToggled;
- (Day *)dayForIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath;
- (void)localizeUI;
- (void)reloadTable;

@end
