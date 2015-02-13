//
//  Item.h
//  shuiguoshe
//
//  Created by tomwey on 12/29/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, assign) NSUInteger iid;

@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* subtitle;

@property (nonatomic, copy)   NSString* intro;

@property (nonatomic, copy)   NSString* thumbImageUrl;

@property (nonatomic, copy)   NSString* lowPrice;
@property (nonatomic, copy)   NSString* originPrice;

@property (nonatomic, copy)   NSString* unit;
@property (nonatomic, assign) NSUInteger ordersCount;

@property (nonatomic, assign) NSUInteger discountScore;
@property (nonatomic, copy)   NSString* discountedAt;

@property (nonatomic, assign) NSUInteger likesCount;

- (Item *)initWithDictionary:(NSDictionary *)jsonObj;

- (NSString *)lowPriceText;
- (NSString *)originPriceText;

- (BOOL)liked;

@end
