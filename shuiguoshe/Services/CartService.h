//
//  CartService.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kAddToCartNotification;

@interface CartService : NSObject

+ (CartService *)sharedService;

- (void)setTotalCount:(NSUInteger)total;
- (NSUInteger)totalCount;

//- (void)loadCart:()

@end
