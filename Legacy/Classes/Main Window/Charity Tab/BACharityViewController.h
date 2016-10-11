//
//  BACharityViewController.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 4/30/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BADateTableViewController.h"

@interface BACharityViewController : BADateTableViewController {
	IBOutlet UILabel *viewTitle;
	IBOutlet UILabel *charityHeader;
	IBOutlet UIButton *doneButton;
	IBOutlet UIButton *cancelButton;
	
	IBOutlet UIButton *buttonMoney;
	IBOutlet UIButton *buttonEffort;
	IBOutlet UIButton *buttonFood;
	IBOutlet UIButton *buttonClothes;
	IBOutlet UIButton *buttonSmile;
	IBOutlet UIButton *buttonOther;
}

- (IBAction)doneAction:(id)sender;

- (IBAction)enableMoney:(id)sender;
- (IBAction)enableEffort:(id)sender;
- (IBAction)enableFood:(id)sender;
- (IBAction)enableClothes:(id)sender;
- (IBAction)enableSmile:(id)sender;
- (IBAction)enableOther:(id)sender;

@end
