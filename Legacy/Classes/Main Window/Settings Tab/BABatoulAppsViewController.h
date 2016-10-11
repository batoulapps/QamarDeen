//
//  BABatoulAppsViewController.h
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BABatoulAppsViewController : UIViewController {
	IBOutlet UILabel *islamicApps;
	IBOutlet UIButton *doneButton;
	IBOutlet UILabel *quranTitle;
	IBOutlet UIButton *quranButton;
}

- (IBAction)doneAction:(id)sender;
- (IBAction)viewQuranReader:(id)sender;
- (IBAction)viewGuidance:(id)sender;
- (IBAction)viewSupplications:(id)sender;

@end
