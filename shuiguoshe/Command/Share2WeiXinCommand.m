//
//  Share2WeiXinCommand.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-4.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Share2WeiXinCommand.h"
#import "Defines.h"

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
    ItemDetail* item = self.userData;
    UIImage* image = [[UIImageView sharedImageCache] cachedImageForRequest:[NSURLRequest requestWithURL:
                                                                            [NSURL URLWithString:item.largeImage]]];
    if ( !image ) {
        [Toast showText:@"图片还在加载中，不能分享"];
        return;
    }
    
    [[KKShareWeiXin sharedManager] sendNews:item.title
                                description:[NSString stringWithFormat:@"%@", [item lowPriceText]]
                                 thumbImage:image
                                 webpageUrl:[NSString stringWithFormat:@"http://shuiguoshe.com/item-%d", item.itemId]
                                WXSceneType:(int)self.shareType];
}

@end
