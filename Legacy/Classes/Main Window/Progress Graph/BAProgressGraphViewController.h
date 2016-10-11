//
//  BAProgressGraphViewController.h
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKSparkline.h"

typedef enum {
	Period_1w = 8,
	Period_2w = 15,
	Period_1m = 29,
	Period_2m = 57,
	Period_3m = 85,
	Period_6m = 181,
	Period_1y = 361,
	Period_all = 0
} GraphPeriod;

typedef enum {
	DataPrayer,
	DataQuran,
	DataCharity,
	DataFasting,
	DataCombined
} DataType;

@interface BAProgressGraphViewController : UIViewController {
	
	GraphPeriod graphPeriod;
	DataType dataType;
	
	NSManagedObjectContext *managedObjectContext;
	
	IBOutlet UIButton *combinedTab;
	IBOutlet UIButton *prayerTab;
	IBOutlet UIButton *quranTab;
	IBOutlet UIButton *charityTab;
	IBOutlet UIButton *fastingTab;
	
	IBOutlet UIButton *periodButton_1w;
	IBOutlet UIButton *periodButton_2w;
	IBOutlet UIButton *periodButton_1m;
	IBOutlet UIButton *periodButton_2m;
	IBOutlet UIButton *periodButton_3m;
	IBOutlet UIButton *periodButton_6m;
	IBOutlet UIButton *periodButton_1y;
	IBOutlet UIButton *periodButton_all;
	
	IBOutlet UIScrollView *graphScrollView;
	
	IBOutlet UIImageView *pageControl_1;
	IBOutlet UIImageView *pageControl_2;
	
	IBOutlet UILabel *beginDate;
	IBOutlet UILabel *endDate;
	
	CKSparkline *sparkline;
	
	UIView *graphView;
	UIView *dataView;
	UIImageView *graphBg;
	
	NSDateFormatter *dateFormatter;
	NSNumberFormatter *numberFormatter;
	
	NSMutableArray *days;
	
	BOOL isSevenDay;
}

- (void)requiresRefresh;

- (void)localizeUI;
- (void)update;
- (void)setButtonStates;
- (void)pullData;
- (void)plotGraph;
- (void)updateChart;
- (void)updatePageControl;
- (void)positionName:(NSString *)name total:(NSNumber *)total percent:(NSNumber *)percent asLabelsAtPoint:(CGPoint)point inView:(UIView*)view;

- (IBAction)setTab_combined:(id)sender;
- (IBAction)setTab_prayer:(id)sender;
- (IBAction)setTab_quran:(id)sender;
- (IBAction)setTab_charity:(id)sender;
- (IBAction)setTab_fasting:(id)sender;

- (IBAction)setPeriod_1w:(id)sender;
- (IBAction)setPeriod_2w:(id)sender;
- (IBAction)setPeriod_1m:(id)sender;
- (IBAction)setPeriod_2m:(id)sender;
- (IBAction)setPeriod_3m:(id)sender;
- (IBAction)setPeriod_6m:(id)sender;
- (IBAction)setPeriod_1y:(id)sender;
- (IBAction)setPeriod_all:(id)sender;

@end
