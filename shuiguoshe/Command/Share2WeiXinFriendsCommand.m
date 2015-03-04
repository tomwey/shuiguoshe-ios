//
//  Share2WeiXinFriendsCommand.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-4.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Share2WeiXinFriendsCommand.h"

@implementation Share2WeiXinFriendsCommand

- (id)init
{
    if ( self = [super init] ) {
        self.shareType = ShareWeiXinTypeAllFriends;
    }
    return self;
}

@end
