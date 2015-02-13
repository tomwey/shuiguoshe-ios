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
    return [[self token] length] > 0;
}

- (NSString *)token
{
    NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if ( !token ) return nil;
    
    return [[[NSString alloc] initWithData:[GTMBase64 decodeString:token] encoding:NSUTF8StringEncoding] autorelease];
}

- (void)saveToken:(NSString *)token
{
    if ( !token ) {
        [[NSUserDefaults standardUserDefaults] setObject:@""
                                                  forKey:@"token"];
    } else {
        NSData* data = [GTMBase64 encodeData:[token dataUsingEncoding:NSUTF8StringEncoding]];
        [[NSUserDefaults standardUserDefaults] setObject:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]
                                                  forKey:@"token"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)login:(User *)aUser completion:( void (^)(BOOL succeed, NSString* errorMsg) )completion
{
    [[DataService sharedService] post:@"/account/login"
                               params:@{ @"login": aUser.name, @"password": aUser.password }
                           completion:^(id result, BOOL succeed2)
    {
        if ( succeed2 ) {
            if ( completion ) {
                NSString* token = [[result objectForKey:@"data"] objectForKey:@"token"];
                [self saveToken:token];
                
                completion(YES, nil);
            }
        } else {
            if ( completion ) {
                completion(NO, [result objectForKey:@"message"]);
            }
        }
    }];
}

- (void)logout:(void (^)(BOOL outSuccess, NSString *error))completion
{
    [[DataService sharedService] post:@"/account/logout"
                               params:@{ @"token" : [self token] }
                           completion:^(id result, BOOL succeed) {
                               if ( succeed ) {
                                   [self saveToken:nil];
                               }
                               
                               if ( completion ) {
                                   if ( succeed ) {
                                       completion(YES, nil);
                                   } else {
                                       completion(NO, [result objectForKey:@"message"]);
                                   }
                               }
                           }];
}

- (void)fetchCode:(User *)aUser completion:( void (^)(BOOL succeed2, NSString* errorMsg) )completion
{
    [[DataService sharedService] post:@"/auth_codes"
                               params:@{ @"mobile": aUser.name, @"type" : aUser.codeType }
                           completion:^(id result, BOOL succeed) {
                               NSLog(@"result:%@", result);
                               if ( succeed ) {
                                   if ( [[result objectForKey:@"code"] integerValue] == 0 ) {
                                       if ( completion ) {
                                           completion(YES, nil);
                                       }
                                   } else {
                                       if ( completion ) {
                                           completion(NO, [result objectForKey:@"message"]);
                                       }
                                   }
                               } else {
                                   if ( completion ) {
                                       completion(NO, [result objectForKey:@"message"]);
                                   }
                               }
                           }];
}

- (void)signup:(User *)aUser completion:( void (^)(BOOL succeed, NSString* errorMsg) )completion
{
    [[DataService sharedService] post:@"/account/sign_up"
                               params:@{ @"mobile": aUser.name, @"code": aUser.code, @"password": aUser.password }
                           completion:^(id result, BOOL succeed) {
                               if ( succeed ) {
                                   if ( [[result objectForKey:@"code"] integerValue] == 0 ) {
                                       [self saveToken:[[result objectForKey:@"data"] objectForKey:@"token"]];
                                       if ( completion ) {
                                           completion(YES, nil);
                                       }
                                   } else {
                                       if ( completion ) {
                                           completion(NO, [result objectForKey:@"message"]);
                                       }
                                   }
                               } else {
                                   if ( completion ) {
                                       completion(NO, [result objectForKey:@"message"]);
                                   }
                               }
                           }];
}

- (void)forgetPassword:(User *)aUser completion:( void (^)(BOOL succeed, NSString* errorMsg) )completion
{
    [[DataService sharedService] post:@"/account/password/reset"
                               params:@{ @"mobile": aUser.name, @"code": aUser.code, @"password": aUser.password }
                           completion:^(id result, BOOL succeed) {
                               if ( succeed ) {
                                   if ( [[result objectForKey:@"code"] integerValue] == 0 ) {
                                       [self saveToken:[[result objectForKey:@"data"] objectForKey:@"token"]];
                                       if ( completion ) {
                                           completion(YES, nil);
                                       }
                                   } else {
                                       if ( completion ) {
                                           completion(NO, [result objectForKey:@"message"]);
                                       }
                                   }
                               } else {
                                   if ( completion ) {
                                       completion(NO, [result objectForKey:@"message"]);
                                   }
                               }
                           }];
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
    [[DataService sharedService] uploadImage:anImage
                                         URI:@"/user/update_avatar.json"
                                      params:@{ @"token": [self token] }
                                  completion:^(id result, BOOL succeed) {
                                      NSLog(@"result:%@", result);
                                  }];
}

@end
