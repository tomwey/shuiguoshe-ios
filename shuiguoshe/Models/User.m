//
//  User.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "User.h"

@implementation User

- (void)dealloc
{
    self.name = nil;
    self.avatarUrl = nil;
    [super dealloc];
}

@end
