//
//  CartService.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "CartService.h"

NSString * const kAddToCartNotification = @"kAddToCartNotification";

@implementation CartService

+ (CartService *)sharedService
{
    static CartService* service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !service ) {
            service = [[CartService alloc] init];
        }
    });
    return service;
}

@end
