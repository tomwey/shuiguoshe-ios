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
    
    if (![WXApi isWXAppInstalled]) {
        [Toast showText:@"抱歉，您尚未安装微信"];
        return;
    }
    
    ItemDetail* item = self.userData;
//    UIImage* image = [[UIImageView sharedImageCache] cachedImageForRequest:[NSURLRequest requestWithURL:
//                                                                            [NSURL URLWithString:item.largeImage]]];
//    if ( !image ) {
//        [Toast showText:@"图片还在加载中，不能分享"];
//        return;
//    }
    [MBProgressHUD showHUDAddedTo:AppWindow() animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage* image = [UIImage imageWithData:
                          [NSData dataWithContentsOfURL:[NSURL URLWithString:item.largeImage]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:AppWindow() animated:YES];
            if ( image ) {
                [[KKShareWeiXin sharedManager] sendNews:item.title
                                            description:[NSString stringWithFormat:@"%@", [item lowPriceText]]
                                             thumbImage:image
                                             webpageUrl:[NSString stringWithFormat:@"http://shuiguoshe.com/item-%d", item.itemId]
                                            WXSceneType:(int)self.shareType];
            } else {
                [Toast showText:@"没找到要分享的图片，稍后再试"];
            }
        });
        
    });
    
    
}

@end
