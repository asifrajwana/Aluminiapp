//
//  AppDelegate.m
//  Uni Alnmni
//
//  Created by asif on 13/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "HomeController.h"
#import "CustomHeader.h"
#import "OAToken.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:13/255.0 green:40/255.0 blue:115/255.0 alpha:1]];
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [NSThread sleepForTimeInterval:3.0];
    [Parse enableLocalDatastore];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"logo"] forBarMetrics:UIBarMetricsDefault];
    
    // Leadstech Parse.
    [Parse setApplicationId:@"4jo1sGjnYSLUpCYVmLrzLYO3EAIM7wMPGUmIBMqm"
                  clientKey:@"4Ng2SkMcoJiGPtBWQGYMgqi6RT1uti8s70gMb3d9"];
    
    // Client Parse.
//    [Parse setApplicationId:@"ZPC6yYavnuuhxcoFWIPX0kWYs5i6yvN9Rq6GLNZl"
//                  clientKey:@"fajmI59TbYFflv0IRqS9lNx63l3JrKDgZUP090ct"];

    [PFUser enableRevocableSessionInBackground];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    OAToken *access_token = [defaults objectForKey:@"access_token"];
    
    if(access_token != nil){
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"LogIn"];
        UIViewController *viewController1 = [storyboard instantiateViewControllerWithIdentifier:@"homeController"];
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"navController"];
        NSArray *controllers = @[viewController,viewController1];
        [navController setViewControllers:controllers];
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
        
    }
    
    NSLog(@"Access Token%@",access_token);
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
