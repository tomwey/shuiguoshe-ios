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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:30 * 1024 * 1024 diskPath:@"Images"];
    [NSURLCache setSharedURLCache:URLCache];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[CoordinatorController sharedInstance] navController];
    
    [WXApi registerApp:kWechatAppID];
    
    return YES;
}

//- (void)checkVersion
//{
//    NSString *urlPath = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appId];
//    NSURL *url = [NSURL URLWithString:urlPath];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if ([data length]>0 && !error ) {
//            NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            NSDictionary *result = nil;
//            if ([appInfo valueForKey:@"results"]) {
//                NSArray *arrary = [appInfo valueForKey:@"results"];
//                if (arrary && [arrary count]>0) {
//                    result = [arrary objectAtIndex:0];
//                }
//            }
//            
//            if (result) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSString *versionsInAppStore = [result valueForKey:@"version"];
//                    if (versionsInAppStore) {
//                        if ([[NSBundle bundleVersion] compare:versionsInAppStore options:NSNumericSearch] == NSOrderedAscending) {
//                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"新版本提示" message:[NSString stringWithFormat:@"当前有新的版本%@",versionsInAppStore] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上升级",nil];
//                            [alert show];
//                            [alert release];
//                        }
//                        else {
//                            if (showMsg) {
//                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                                    message:@"当前应用已为最新版本。"
//                                                                                   delegate:self
//                                                                          cancelButtonTitle:@"好的"
//                                                                          otherButtonTitles:nil];
//                                [alertView show];
//                                [alertView release];
//                            }
//                        }
//                    }
//                });
//            }
//        }
//    }];
//    [queue release];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [[KKShareWeiXin sharedManager ] handleOpenURL:url] |
    [[KKShareQQZone sharedManager] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic)
        {
            DLog(@"payment result: %@", resultDic);
            
            if ( [[DataVerifierManager sharedManager] verifyResult:resultDic] ) {
                DLog(@"验证成功");
            } else {
                DLog(@"验证失败");
            }
        }];
        
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             DLog(@"auth result: %@", resultDic);
                                         }];
        
        return YES;
    }
    
    return [[KKShareWeiXin sharedManager ] handleOpenURL:url] |
    [[KKShareQQZone sharedManager] handleOpenURL:url];
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
