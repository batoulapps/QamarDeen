//
//  BATouchView.m
//  QamarDeen
//
//  Created by Matthew Crenshaw on 5/4/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BATouchView.h"
#import "BADateTableViewController.h"


@implementation BATouchView

@synthesize controller, targetView;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[targetView touchesBegan:touches withEvent:event];
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[targetView touchesMoved:touches withEvent:event];
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[targetView touchesEnded:touches withEvent:event];
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[targetView touchesCancelled:touches withEvent:event];
	[super touchesCancelled:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if (controller && event.type == UIEventTypeTouches)
	{
		[controller setTouchPoint:point];
	}
	return nil;
}

- (void)dealloc {
	controller = nil;
    [super dealloc];
}


@end
