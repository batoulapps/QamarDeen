//
//  BATouchView.h
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/4/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BADateTableViewController;

@interface BATouchView : UIView
{
	BADateTableViewController *controller;
	UIView *targetView;
}

@property (nonatomic, retain) BADateTableViewController *controller;
@property (nonatomic, retain) UIView *targetView;

@end
