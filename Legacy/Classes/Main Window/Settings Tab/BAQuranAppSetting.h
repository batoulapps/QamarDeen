//
//  BAQuranAppSetting.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 6/2/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BAQuranAppSetting : UIViewController {
	IBOutlet UILabel *header;
	IBOutlet UIButton *doneButton;
	IBOutlet UIImageView *checkmark;
	IBOutlet UIButton *quranReaderButton;
	IBOutlet UIButton *iquranButton;
	IBOutlet UIButton *mushafButton;
}

- (IBAction)doneAction:(id)sender;
- (IBAction)setQuranReader:(id)sender;
- (IBAction)setiQuran:(id)sender;
- (IBAction)setAlMushaf:(id)sender;

@end
