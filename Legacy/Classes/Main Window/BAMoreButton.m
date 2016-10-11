//
//  BAMoreButton.m
//  QamarDeen
//
//  Created by Matthew Crenshaw on 6/12/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BAMoreButton.h"


@implementation BAMoreButton

- (void)layoutSubviews
{
	[super layoutSubviews];
	[[self titleLabel] setFrame:CGRectMake(40, 15, 280, 15)];
}

@end
