//
//  BACreditsView.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 6/6/10.
//  Copyright 2010 Batoul Apps. All rights reserved.
//

#import "BACreditsView.h"


@implementation BACreditsView


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[viewTitle setText:[BALocalizer localizedString:@"MoreButton"]];
	creditsData = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Credits" ofType:@"plist"]];
	[backButton setTitle:[BALocalizer localizedString:@"BackButton"] forState:UIControlStateNormal];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [creditsData count];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section 
{
	return [[creditsData objectAtIndex:section] objectAtIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[creditsData objectAtIndex:section] objectAtIndex:1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	cell.textLabel.text = [[[creditsData objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row];

	return cell;
}

- (IBAction)backAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
