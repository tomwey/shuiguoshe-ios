//
//  OrderCollection.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderCollection : NSObject

@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger totalRecord;

@property (nonatomic, copy) NSArray* orders;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
