//
//  LineItem.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineItem : NSObject

@property (nonatomic, assign) NSUInteger objectId;
@property (nonatomic, assign) NSUInteger itemId;

@property (nonatomic, copy) NSString* itemTitle;
@property (nonatomic, copy) NSString* itemIconUrl;

@property (nonatomic, assign) NSUInteger quantity;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) float totalPrice;

@property (nonatomic, assign) BOOL visible;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
