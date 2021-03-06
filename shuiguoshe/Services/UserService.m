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
    if ( token.length == 0 ) return nil;
    
    return token; //[[[NSString alloc] initWithData:[GTMBase64 decodeString:token] encoding:NSUTF8StringEncoding] autorelease];
}

- (void)saveToken:(NSString *)token
{
    if ( !token ) {
        [[NSUserDefaults standardUserDefaults] setObject:@""
                                                  forKey:@"token"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)login:(User *)aUser completion:( void (^)(BOOL succeed, NSString* errorMsg) )completion
{
    NSString* password = aUser.password;
    password = [[password dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
    
    [[DataService sharedService] post:@"/account/login"
                               params:@{ @"login": aUser.name,
                                         @"password": password }
                           completion:^(NetworkResponse* resp)
    {
        if ( !resp.requestSuccess ) {
            [Toast showText:@"呃，系统出错了"];
        } else {
            if ( resp.statusCode == 0 ) {
                if ( completion ) {
                    NSString* token = [resp.result objectForKey:@"token"];
                    [self saveToken:token];
                    
                    completion(YES, nil);
                }
            } else {
                if ( completion ) {
                    completion(NO, resp.message);
                }
            }
        }
    }];
}

- (void)logout:(void (^)(BOOL outSuccess, NSString *error))completion
{
    [[DataService sharedService] post:@"/account/logout"
                               params:@{ @"token" : [self token] }
                           completion:^(NetworkResponse* resp)
    {
                               
       if ( !resp.requestSuccess ) {
           [Toast showText:@"呃，系统出错了"];
       } else {
           if ( resp.statusCode == 0 ) {
               [self saveToken:nil];
               if ( completion ) {
                   completion(YES, nil);
               }
           } else {
               if ( completion ) {
                   completion(NO, resp.message);
               }
           }
       }
       
    }];
}

- (void)fetchCode:(User *)aUser completion:( void (^)(BOOL succeed2, NSString* errorMsg) )completion
{
    [[DataService sharedService] post:@"/auth_codes"
                               params:@{ @"mobile": aUser.name, @"type" : aUser.codeType }
                           completion:^(NetworkResponse* resp)
     {
         if ( !resp.requestSuccess ) {
             [Toast showText:@"呃，系统出错了"];
             completion(NO, resp.message);
         } else {
             if ( resp.statusCode == 0 ) {
                 if ( completion ) {
                     completion(YES, nil);
                 }
             } else {
                 if ( completion ) {
                     completion(NO, resp.message);
                 }
             }
         }
    }];
}

- (void)signup:(User *)aUser completion:( void (^)(BOOL succeed, NSString* errorMsg) )completion
{
    NSString* password = aUser.password;
    password = [[password dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
    
    [[DataService sharedService] post:@"/account/sign_up"
                               params:@{ @"mobile": aUser.name, @"code": aUser.code, @"password": password }
                           completion:^(NetworkResponse* resp) {
                               if ( !resp.requestSuccess ) {
                                   [Toast showText:@"呃，系统出错了"];
                                   if ( completion ) {
                                       completion(NO, resp.message);
                                   }
                               } else {
                                   if ( resp.statusCode == 0 ) {
                                       [self saveToken:[resp.result objectForKey:@"token"]];
                                       if ( completion ) {
                                           completion(YES, nil);
                                       }
                                   } else {
                                       if ( completion ) {
                                           completion(NO, resp.message);
                                       }
                                   }
                               }
                               
                           }];
}

- (void)forgetPassword:(User *)aUser completion:( void (^)(BOOL succeed, NSString* errorMsg) )completion
{
    NSString* password = aUser.password;
    password = [[password dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
    
    [[DataService sharedService] post:@"/account/password/reset"
                               params:@{ @"mobile": aUser.name, @"code": aUser.code, @"password": password }
                           completion:^(NetworkResponse* resp) {
                               if ( !resp.requestSuccess ) {
                                   [Toast showText:@"呃，系统出错了"];
                                   if ( completion ) {
                                       completion(NO, resp.message);
                                   }
                               } else {
                                   if ( resp.statusCode == 0 ) {
                                       [self saveToken:[resp.result objectForKey:@"token"]];
                                       if ( completion ) {
                                           completion(YES, nil);
                                       }
                                   } else {
                                       if ( completion ) {
                                           completion(NO, resp.message);
                                       }
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
                                  completion:^(NetworkResponse* resp) {
                                      if ( !resp.requestSuccess ) {
                                          [Toast showText:@"呃，系统出错了"];
                                      } else {
                                          if ( completion ) {
                                              if ( resp.statusCode == 0 ) {
                                                  completion(YES);
                                              } else {
                                                  completion(NO);
                                              }
                                          }
                                      }
                                      
                                  }];
}

@end
