//
//  Share2WeiXinCommand.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-4.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Share2WeiXinCommand.h"

@implementation Share2WeiXinCommand

- (id)init
{
    if ( self = [super init] ) {
        self.shareType = ShareWeiXinTypeFriend;
    }
    return self;
}

- (void)execute:(void (^)(id))result
{
    if ( self.shareType == ShareWeiXinTypeFriend ) {
        NSLog(@"分享到微信好友");
    } else {
        NSLog(@"分享到微信朋友圈");
    }
}

@end
