//
//  Cart.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-13.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cart : NSObject

@property (nonatomic, assign) NSUInteger totalQuantity; // 总的商品数
@property (nonatomic, assign) float totalPrice; // 总钱数

@property (nonatomic, copy) NSArray* items;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
