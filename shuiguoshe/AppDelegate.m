//
//  AppDelegate.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "AppDelegate.h"
#import "Defines.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBarTintColor:RGB(99, 185, 76)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UITabBarController* tabBar = [[[UITabBarController alloc] init] autorelease];
    self.window.rootViewController = tabBar;
    
    UIViewController* home = [BaseViewController viewControllerWithClassName:@"HomeViewController"];
    home.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"首页"
                                                     image:nil
                                             selectedImage:nil] autorelease];
    
    UIViewController* items = [BaseViewController viewControllerWithClassName:@"ItemsViewController"];
    items.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"全部"
                                                     image:nil
                                             selectedImage:nil] autorelease];
    
    UIViewController* cart = [BaseViewController viewControllerWithClassName:@"CartViewController"];
    cart.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"我的购物车"
                                                      image:nil
                                              selectedImage:nil] autorelease];
    
    UIViewController* apartments = [BaseViewController viewControllerWithClassName:@"ApartmentsViewController"];
    
    apartments.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"服务小区"
                                                      image:nil
                                              selectedImage:nil] autorelease];
    
    UIViewController* user = [BaseViewController viewControllerWithClassName:@"UserViewController"];
    
    user.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"我的"
                                                     image:nil
                                             selectedImage:nil] autorelease];
    
    NSArray* controllers = @[home, items, cart, apartments, user];
    tabBar.viewControllers = controllers;
    
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
