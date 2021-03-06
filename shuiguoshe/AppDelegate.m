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
    
    [self checkVersion];
    
    return YES;
}

- (void)checkVersion
{
    NSString* appUrl = @"http://itunes.apple.com/lookup?id=974919575";
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:appUrl]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError)
    {
        if ( !connectionError ) {
            NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingAllowFragments error:nil];
            if ( appInfo&& [appInfo objectForKey:@"results"] ) {
                NSArray* results = [appInfo objectForKey:@"results"];
                NSDictionary* result = [results firstObject];
                if ( result ) {
                    NSString* versionInAppStore = [result objectForKey:@"version"];
                    NSString* localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    
                    if ( [versionInAppStore compare:localVersion
                                            options:NSNumericSearch] == NSOrderedDescending ) {
                        [ModalAlert showWithTitle:@"新版本提示"
                                          message:[NSString stringWithFormat:@"当前有新的版本%@",versionInAppStore]
                                     cancelButton:@"不了"
                                     otherButtons:@[@"马上升级"]
                                           result:^(NSUInteger buttonIndex) {
                                               if ( buttonIndex == 1 ) {
                                                   [[UIApplication sharedApplication] openURL:
                                                    [NSURL URLWithString:@"https://itunes.apple.com/app/id974919575"]];
                                               }
                                           }];
                    }
                }
            }
        }
    }];
}

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
    
    [self checkVersion];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
