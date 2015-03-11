//
//  ShipmentInfo.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipmentInfo : NSObject

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@property (nonatomic, assign) NSInteger oid;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* prefix;

@end
