//
//  QamarDeenAppDelegate.m
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/2/10.
//  Copyright Batoul Apps 2010. All rights reserved.
//

#import "BAQamarDeenAppDelegate.h"
#import "BAPrayerViewController.h"
#import "BAQuranViewController.h"
#import "BACharityViewController.h"
#import "BAFastingViewController.h"
#import "BASettingsViewController.h"
#import "ProtectedViewController.h"
#import "BADSTFix.h"

@implementation BAQamarDeenAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize tabBarController;
@synthesize userSettings;
@synthesize dayDateFormatter;
@synthesize arabicDayDateFormatter;
@synthesize dateDateFormatter;
@synthesize arabicDateDateFormatter;
@synthesize monthDateFormatter;
@synthesize localNumberFormatter;
@synthesize arabicNumberFormatter;
@synthesize arabicStrings;
@synthesize logUrl;

static BAQamarDeenAppDelegate *sharedAppDelegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	logUrl = nil;
	appIsProtected = NO;
	
	userSettings = [[NSUserDefaults standardUserDefaults] retain];
	NSDictionary *appDefaults = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"]] retain];
	[userSettings registerDefaults:appDefaults];
	[appDefaults release];
	
	// migrate user data if needed
	[self migrate];
	
	
	// common date formatters used throughout the app
	dayDateFormatter = [[NSDateFormatter alloc] init];
	[dayDateFormatter setDateFormat:@"EE"];
	
	arabicDayDateFormatter = [[NSDateFormatter alloc] init];
	[arabicDayDateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ar"] autorelease]];
	[arabicDayDateFormatter setDateFormat:@"EE"];
	
	dateDateFormatter = [[NSDateFormatter alloc] init];
	[dateDateFormatter setDateFormat:@"d"];
	
	arabicDateDateFormatter = [[NSDateFormatter alloc] init];
	[arabicDateDateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ar"] autorelease]];
	[arabicDateDateFormatter setDateFormat:@"d"];
	
	monthDateFormatter = [[NSDateFormatter alloc] init];
	[monthDateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
	[monthDateFormatter setDateFormat:@"MMM"];
	
	localNumberFormatter = [[NSNumberFormatter alloc] init];
	[localNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	arabicNumberFormatter = [[NSNumberFormatter alloc] init];
	[arabicNumberFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ar"] autorelease]];
	[arabicNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

	
	// arabic strings dictionary
	arabicStrings = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ArabicStrings" ofType:@"plist"]];
	
	
	// add view controllers for the tabs
	BAPrayerViewController *prayerViewController = [[[BAPrayerViewController alloc] initWithNibName:@"BAPrayerView" bundle:nil] autorelease];	
	BAQuranViewController *quranViewController = [[[BAQuranViewController alloc] initWithNibName:@"BAQuranView" bundle:nil] autorelease];
	BACharityViewController *charityViewController = [[[BACharityViewController alloc] initWithNibName:@"BACharityView" bundle:nil] autorelease];
	BAFastingViewController *fastingViewController = [[[BAFastingViewController alloc] initWithNibName:@"BAFastingView" bundle:nil] autorelease];
	BASettingsViewController *settingsViewController = [[[BASettingsViewController alloc] initWithNibName:@"BASettingsView" bundle:nil] autorelease];	
	
	[tabBarController setViewControllers:[NSArray arrayWithObjects:prayerViewController,quranViewController,charityViewController,fastingViewController,settingsViewController,nil]];
	
	[self.navigationController setViewControllers:[NSArray arrayWithObject:tabBarController]];
	
	loadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
	
	[window addSubview:[self.navigationController view]];
	[window addSubview:loadingView];
	
	if(launchOptions != nil) {
		
		NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
		
		if ([[url scheme] isEqualToString:@"qamardeenlog"])
		{
			logUrl = [[NSURL alloc] initWithString:[url absoluteString]];
		}
	}	
	
	if ([userSettings boolForKey:@"ProtectionEnabled"]) {
		//bring up box to enter password
		ProtectedViewController *protectedView = [[[ProtectedViewController alloc] initWithNibName:@"ProtectedViewController" bundle:nil] autorelease];
		[protectedView setHidesBottomBarWhenPushed:YES];
		[self.navigationController presentModalViewController:protectedView animated:NO];
		appIsProtected = YES;
		
		[self fadeOutLoadingScreen];
	} else {
		[self fadeOutLoadingScreen];
		
		if(logUrl != nil) {
			[self logStoppingPoint];
		}
	}
	
	return NO;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{	
	if ([[url scheme] isEqualToString:@"qamardeenlog"])
	{
		if(logUrl != nil) {
			[logUrl release];
			logUrl = nil;
		}		
		logUrl = [[NSURL alloc] initWithString:[url absoluteString]];
		
		if(!appIsProtected) {
			[self logStoppingPoint];
		}
	}
	
	return YES;
}

- (void)logStoppingPoint
{	
	NSArray *urlComponents = [[[logUrl absoluteString] substringFromIndex:15] componentsSeparatedByString:@":"];
	int surah = [[urlComponents objectAtIndex:0] intValue];
	int ayah = [[urlComponents objectAtIndex:1] intValue];
	
	[[self tabBarController] setSelectedIndex:1];
	if([[[self tabBarController] selectedViewController] respondsToSelector:@selector(logFromUrlForSurah:andAyah:)]) {
		[(BAQuranViewController *)[[self tabBarController] selectedViewController] logFromUrlForSurah:surah andAyah:ayah];
	}
	
	if(logUrl != nil) {
		[logUrl release];
		logUrl = nil;
	}	
}

- (void)dismissSecurityScreen
{
	[[self navigationController] dismissModalViewControllerAnimated:YES];
	appIsProtected = NO;
	
	if(logUrl != nil) {
		[self logStoppingPoint];
	}
}

- (void)migrate
{
	NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString *dataVersion = [userSettings stringForKey:@"CurrentVersion"];
	
	if ([dataVersion compare:@"1.0.1" options:NSNumericSearch] == NSOrderedAscending)
	{
		// Fix DST bug
		[BADSTFix fixDSTDuplicatesInManagedObjectContext:self.managedObjectContext];
	} 
	
	if ([dataVersion compare:@"1.0.4" options:NSNumericSearch] == NSOrderedAscending) 
	{
		// Fix pre-DST dates bug
		[BADSTFix fixGMTDuplicatesInManagedObjectContext:self.managedObjectContext];
	}
	
	[userSettings setValue:bundleVersion forKey:@"CurrentVersion"];
}

- (void)loadingFadeComplete 
{
	[loadingView removeFromSuperview];
	[loadingView release];
}

- (void)fadeOutLoadingScreen
{
	[UIView beginAnimations:@"LoadingViewFade" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(loadingFadeComplete)];
	[UIView setAnimationDuration:0.20];
	[loadingView setAlpha:0.0];
	[UIView commitAnimations];
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
	[userSettings synchronize];
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	[userSettings synchronize];
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	if(logUrl != nil) {
		[logUrl release];
		logUrl = nil;
	}
	
	if([userSettings boolForKey:@"ProtectionEnabled"]) {
		
		[self.navigationController dismissModalViewControllerAnimated:NO];
		
		ProtectedViewController *protectedView = [[[ProtectedViewController alloc] initWithNibName:@"ProtectedViewController" bundle:nil] autorelease];
		[protectedView setHidesBottomBarWhenPushed:YES];
		[self.navigationController presentModalViewController:protectedView animated:NO];
		appIsProtected = YES;
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[dayDateFormatter release];
	dayDateFormatter = [[NSDateFormatter alloc] init];
	[dayDateFormatter setDateFormat:@"EE"];
	
	[dateDateFormatter release];
	dateDateFormatter = [[NSDateFormatter alloc] init];
	[dateDateFormatter setDateFormat:@"d"];	
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
	
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
	if (managedObjectModel != nil) {
		return managedObjectModel;
	}
	NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"QamarDeen" ofType:@"momd"];
	NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
	managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];	
	return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"QamarDeen.sqlite"]];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
									 NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
									 NSInferMappingModelAutomaticallyOption, nil];
	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	NSError *error = nil;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:@"QamarDeen"
															URL:storeUrl options:options error:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
	
    return persistentStoreCoordinator;
}

- (BOOL)isRunningOnIpad
{
	return [[[UIDevice currentDevice] model] isEqualToString:@"iPad"];
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}




#pragma mark -
#pragma mark Singleton

+ (BAQamarDeenAppDelegate*)sharedDelegate
{
	@synchronized(self) {
		if (sharedAppDelegate == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
    return sharedAppDelegate;
}


+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedAppDelegate == nil) {
            sharedAppDelegate = [super allocWithZone:zone];
            return sharedAppDelegate; // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


- (id)retain
{
    return self;
}


- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}


- (void)release
{
    //do nothing
}


- (id)autorelease
{
    return self;
}



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	if(logUrl != nil) {
		[logUrl release];
		logUrl = nil;
	}
	
	[dayDateFormatter release];
	[arabicDayDateFormatter release];
	[dateDateFormatter release];
	[arabicDateDateFormatter release];
	[monthDateFormatter release];
	[arabicStrings release];
	
	[userSettings release];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
	[navigationController release];
	[tabBarController release];
	[window release];
	[super dealloc];
}

@end

