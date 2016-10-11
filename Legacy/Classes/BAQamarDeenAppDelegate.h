//
//  QamarDeenAppDelegate.h
//  QamarDeen
//
//  Created by Ameir Al-Zoubi on 2/2/10.
//  Copyright Batoul Apps 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAQamarDeenAppDelegate : NSObject <UIApplicationDelegate>
{
	NSUserDefaults *userSettings;
	
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
    UIWindow *window;
	UINavigationController *navigationController;
	UITabBarController *tabBarController;
	
	UIImageView *loadingView;
	
	NSURL *logUrl;
	
	BOOL appIsProtected;
	
	/* localizing objects */
	NSDateFormatter *dayDateFormatter;
	NSDateFormatter *arabicDayDateFormatter;
	NSDateFormatter *dateDateFormatter;
	NSDateFormatter *arabicDateDateFormatter;
	NSDateFormatter *monthDateFormatter;
	
	NSNumberFormatter *localNumberFormatter;
	NSNumberFormatter *arabicNumberFormatter;
	
	NSDictionary *arabicStrings;
}

+ (BAQamarDeenAppDelegate*) sharedDelegate;
- (NSString *)applicationDocumentsDirectory;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) NSURL *logUrl;

@property (nonatomic, retain) NSUserDefaults *userSettings;

@property (nonatomic, retain) NSDateFormatter *dayDateFormatter;
@property (nonatomic, retain) NSDateFormatter *arabicDayDateFormatter;
@property (nonatomic, retain) NSDateFormatter *dateDateFormatter;
@property (nonatomic, retain) NSDateFormatter *arabicDateDateFormatter;
@property (nonatomic, retain) NSDateFormatter *monthDateFormatter;
@property (nonatomic, retain) NSNumberFormatter *localNumberFormatter;
@property (nonatomic, retain) NSNumberFormatter *arabicNumberFormatter;
@property (nonatomic, retain) NSDictionary *arabicStrings;

- (void)fadeOutLoadingScreen;
- (void)loadingFadeComplete;
- (void)logStoppingPoint;
- (void)dismissSecurityScreen;
- (void)migrate;
- (BOOL)isRunningOnIpad;

@end
