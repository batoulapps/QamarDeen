//
//  BACreditsView.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 6/6/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BACreditsView : UIViewController {
	NSArray *creditsData;
	IBOutlet UIButton *backButton;
	IBOutlet UILabel *viewTitle;
}

- (IBAction)backAction:(id)sender;

@end
