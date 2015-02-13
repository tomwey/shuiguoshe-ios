//
//  Cart.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-13.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kAddToCartNotification;

@interface Cart : NSObject

@property (nonatomic, assign) NSUInteger totalCount;

+ (id)currentCart;

@end
