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

@end
