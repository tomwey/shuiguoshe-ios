//
//  UserService.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Defines.h"

@interface UserService : NSObject

+ (UserService *)sharedService;

- (User *)loadUser;

- (void)uploadAvatar:(UIImage *)anImage completion:(void (^)(BOOL succeed))completion;

- (BOOL)isLogin;

- (NSString *)token;

- (void)login:(User *)aUser completion:( void (^)(BOOL succeed, NSString* errorMsg) )completion;
- (void)logout:( void (^)(BOOL succeed, NSString* errorMsg) )completion;

- (void)fetchCode:(User *)aUser completion:( void (^)(BOOL succeed, NSString* errorMsg) )completion;

- (void)signup:(User *)aUser completion:( void (^)(BOOL succeed, NSString* errorMsg) )completion;

- (void)forgetPassword:(User *)aUser completion:( void (^)(BOOL succeed, NSString* errorMsg) )completion;

@end
