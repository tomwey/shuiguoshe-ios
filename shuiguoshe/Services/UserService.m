//
//  UserService.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "UserService.h"

@implementation UserService

+ (UserService *)sharedService
{
    static UserService* service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !service ) {
            service = [[UserService alloc] init];
        }
    });
    return service;
}

- (BOOL)isLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}

- (void)login:(User *)aUser
{
    
}

- (void)logout
{
    
}

- (User *)loadUser
{
    User* u = [[[User alloc] init] autorelease];
    u.name = @"13684043430";
    u.avatarUrl = @"";
    u.score = 0;
    return u;
}

- (void)uploadAvatar:(id)anImage completion:(void (^)(BOOL succeed))completion
{
    NSData* imageData = UIImageJPEGRepresentation(anImage, 0.5);
    
    UIWindow* window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/user/update_avatar.json", kAPIHost]
       parameters:@{@"token" : @"dc74a76f96062cdbaf17:10"}
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        
        }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"upload success");
              [MBProgressHUD hideHUDForView:window animated:YES];
              if ( completion ) {
                  completion(YES);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"upload error");
              [MBProgressHUD hideHUDForView:window animated:YES];
              if ( completion ) {
                  completion(NO);
              }
          }];
}

@end
