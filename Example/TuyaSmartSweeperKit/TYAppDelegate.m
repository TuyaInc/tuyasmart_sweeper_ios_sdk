//
//  TYAppDelegate.m
//  TuyaSmartSweeperKit
//
//  Created by misakatao on 02/27/2020.
//  Copyright (c) 2020 misakatao. All rights reserved.
//

#import "TYAppDelegate.h"
#import <TuyaSmartBaseKit/TuyaSmartBaseKit.h>
#import "TYUserDefine.h"
#import "TYPLoginViewController.h"
#import "TYPDeviceListViewController.h"

@implementation TYAppDelegate
{
    UINavigationController *_rootVc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if DEBUG
    [[TuyaSmartSDK sharedInstance] setDebugMode:YES];
#endif
    
    [[TuyaSmartSDK sharedInstance] startWithAppKey:SDK_APPKEY secretKey:SDK_APPSECRET];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[TYPDeviceListViewController new]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    _rootVc = navigationController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoginVc)
                                                 name:TuyaSmartUserNotificationUserSessionInvalid
                                               object:nil];
    
    if (![TuyaSmartUser sharedInstance].isLogin) {
        [self showLoginVc];
    }
    
    // Override point for customization after application launch.
    return YES;
}

- (void)showLoginVc {
    TYPLoginViewController *loginVc = [[TYPLoginViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
    [_rootVc presentViewController:nav animated:YES completion:nil];
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
