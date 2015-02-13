//
//  Cart.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-13.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Cart.h"
#import "Defines.h"

NSString * const kAddToCartNotification = @"kAddToCartNotification";

@implementation Cart
{
    UILabel* _resultLabel;
}

+ (id)currentCart
{
    static Cart* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !instance ) {
            instance = [[Cart alloc] init];
        }
    });
    return instance;
}

- (void)setTotalCount:(NSUInteger)totalCount
{
    _totalCount = totalCount;
}

@end
