//
//  ItemDetail.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@interface ItemDetail : NSObject

@property (nonatomic, copy) NSString* largeImage;
@property (nonatomic, copy) NSString* note;
@property (nonatomic, copy) NSString* deliverInfo;
@property (nonatomic, copy) NSArray* photos;

@property (nonatomic, assign) NSUInteger itemId;
@property (nonatomic, assign) NSUInteger likesCount;

@property (nonatomic, copy) NSString* title;
@property (nonatomic, assign) CGFloat lowPrice;
@property (nonatomic, assign) CGFloat originPrice;

@property (nonatomic, assign) NSUInteger discountScore;

@property (nonatomic, copy) NSString* unit;

@property (nonatomic, assign) NSInteger ordersCount;

- (id)initWithDictionary:(NSDictionary *)jsonResult;

- (CGFloat)totalHeightForImages;

- (NSString *)lowPriceText;
- (NSString *)originPriceText;

@end
