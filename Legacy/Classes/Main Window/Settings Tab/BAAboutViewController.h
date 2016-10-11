//
//  BAAboutViewController.h
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/31/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BAAboutViewController : UIViewController
{
	IBOutlet UIButton *bandarButton;
	IBOutlet UIButton *moreButton;
	IBOutlet UIButton *backButton;
	IBOutlet UILabel *copyrightLabel;
	IBOutlet UILabel *versionLabel;
	IBOutlet UILabel *appName;
}

- (IBAction)batoulAppsButtonAction:(id)sender;
- (IBAction)bandarButtonAction:(id)sender;
- (IBAction)moreButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;

@end
