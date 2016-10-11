//
//  ProtectedViewController.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 6/10/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProtectedViewController : UIViewController {
	IBOutlet UITextField *passField;
	IBOutlet UIImageView *passScreen;
	IBOutlet UIImageView *passNum1;
	IBOutlet UIImageView *passNum2;
	IBOutlet UIImageView *passNum3;
	IBOutlet UIImageView *passNum4;
	IBOutlet UILabel *enterPass;
	IBOutlet UILabel *wrongPass;
}

- (IBAction)checkPassword:(id)sender;
- (void)finalShake;
- (void)resetPassImages;
- (void)dismissScreen;

@end
