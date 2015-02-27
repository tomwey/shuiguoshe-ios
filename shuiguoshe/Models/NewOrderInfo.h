//
//  NewOrderInfo.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-27.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DeliverInfo;
@interface NewOrderInfo : NSObject

@property (nonatomic, assign) NSInteger userScore;
@property (nonatomic, retain) DeliverInfo* deliverInfo;

@property (nonatomic, assign) float totalPrice;

@property (nonatomic, copy) NSArray* items;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
