//
//  Catalog.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-9.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Catalog : NSObject

@property (nonatomic, assign) NSUInteger cid;

@property (nonatomic, copy) NSString* name;

- (Catalog *)initWithDictionary:(NSDictionary *)jsonObj;

@end
