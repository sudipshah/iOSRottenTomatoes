//
//  TDLAppDelegate.m
//  RottenTomatoes
//
//  Created by Sudip Shah on 6/4/14.
//  Copyright (c) 2014 Sudip. All rights reserved.
//

#import "TDLAppDelegate.h"
#import "MoviesViewController.h"

@implementation TDLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    // Create controller for Box Office movies
    MoviesViewController *boxOfficeController = [[MoviesViewController alloc]init];
    
    boxOfficeController.rottenTomatoesAPI = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=16&country=us&apikey=3dx3pgwhbgynhze6jvredten";
    
    UINavigationController *boxOfficeNavController = [[UINavigationController alloc]initWithRootViewController:boxOfficeController];
    
    boxOfficeNavController.tabBarItem.title = @"Box Office";
    
    
    
    // Create controller for Top DVD Rentals
    MoviesViewController *topDVDController = [[MoviesViewController alloc] init];
    
    topDVDController.rottenTomatoesAPI = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=3dx3pgwhbgynhze6jvredten";
    UINavigationController * topDVDNavController = [[UINavigationController alloc] initWithRootViewController:topDVDController];
    topDVDNavController.tabBarItem.title = @"Top DVDs";
    
    // Create the tab controller and assign the two controllers
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    
    tabBarController.viewControllers = @[boxOfficeNavController, topDVDNavController];
    
    self.window.rootViewController = tabBarController;
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
