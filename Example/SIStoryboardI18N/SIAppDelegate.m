//
//  SIAppDelegate.m
//  SIStoryboardI18N
//
//  Created by jsambells on 09/01/2015.
//  Copyright (c) 2015 jsambells. All rights reserved.
//

#import <SIStoryboardI18N/SIStoryboardI18N.h>

#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDFileLogger.h>


#import "SIAppDelegate.h"

@implementation SIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // CocoaLumberjack Setup
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
#ifdef DEBUG
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    UIColor *pink = [UIColor colorWithRed:(255 / 255.0)green:(58 / 255.0)blue:(159 / 255.0)alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:pink backgroundColor:nil forFlag:DDLogFlagInfo];
    UIColor *black = [UIColor colorWithWhite:0.404 alpha:1.000];
    [[DDTTYLogger sharedInstance] setForegroundColor:black backgroundColor:nil forFlag:DDLogFlagVerbose];
#endif
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 5;
    [DDLog addLogger:fileLogger];

    NSLog(@"Current Local: %@",[[[NSUserDefaults standardUserDefaults] arrayForKey:@"AppleLanguages"] firstObject]);
    NSLog(@"Main Bundle Localized Value = %@",NSLocalizedString(@"translated_content", nil));
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
