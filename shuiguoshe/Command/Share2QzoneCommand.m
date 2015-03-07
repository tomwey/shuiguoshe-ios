//
//  Share2QzoneCommand.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-4.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Share2QzoneCommand.h"
#import "Defines.h"
#import <TencentOpenAPI/TencentApiInterface.h>

@implementation Share2QzoneCommand

- (void)execute:(void (^)(id))result
{
    
    if ( ![TencentApiInterface isTencentAppInstall:kIphoneQQ] ) {
        [Toast showText:@"抱歉，您尚未安装QQ"];
        return;
    }
    
//    NSLog(@"分享到QQ空间");
    ItemDetail* item = self.userData;
    
//    UIImage* image = [[UIImageView sharedImageCache] cachedImageForRequest:[NSURLRequest requestWithURL:
//                                                           [NSURL URLWithString:item.largeImage]]];
//    
//    if ( !image ) {
//        [Toast showText:@"图片还在加载，请稍等"];
//        return;
//    }
    
    
    
    TCAddShareDic *params = [TCAddShareDic dictionary];
    params.paramTitle = item.title;
    params.paramSummary =  [NSString stringWithFormat:@"%.2f元 %@", item.lowPrice, item.unit];
    params.paramImages = item.largeImage;
    params.paramComment = @"水果社";
    params.paramUrl = [NSString stringWithFormat:@"http://shuiguoshe.com/item-%d", item.itemId];
    
    [[KKShareQQZone sharedManager] addShare:params];
    
}

@end
