//
//  Order.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, assign) NSInteger oid;

@property (nonatomic, copy) NSString* no;

@property (nonatomic, copy) NSString* state;

@property (nonatomic, copy) NSString* orderedAt;

@property (nonatomic, copy) NSString* deliveredAt;

@property (nonatomic, assign) float totalPrice;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
